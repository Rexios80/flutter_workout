#include "health_tizen_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>
#include <string>
#include <sensor.h>
#include <variant>

#include "log.h"

using namespace std;
using namespace flutter;

class HealthTizenPlugin : public Plugin {
public:
    static void RegisterWithRegistrar(PluginRegistrar *registrar) {
        auto plugin = make_unique<HealthTizenPlugin>(registrar);
        registrar->AddPlugin(move(plugin));
    }

    explicit HealthTizenPlugin(PluginRegistrar *registrar) {
        auto channel =
                make_unique<MethodChannel<EncodableValue> >(
                        registrar->messenger(), "health_tizen",
                        &StandardMethodCodec::GetInstance());

        channel->SetMethodCallHandler(
                [plugin_pointer = this](const auto &call, auto result) {
                    plugin_pointer->HandleMethodCall(call, move(result));
                });

        channel_ = std::move(channel);
    }

    ~HealthTizenPlugin() override = default;

private:
    void HandleMethodCall(
            const MethodCall<EncodableValue> &method_call,
            unique_ptr<MethodResult<EncodableValue> > result) {
        const auto &arguments = *method_call.arguments();

        if (method_call.method_name() == "start") {
            string error = start(arguments);
            if (error.empty()) {
                result->Success();
            } else {
                result->Error("1", error);
            }
        } else if (method_call.method_name() == "stop") {
            stop();
            result->Success();
        } else {
            result->NotImplemented();
        }
    }

    string start(const EncodableValue arguments) {
        string error = "";
        if (holds_alternative<EncodableList>(arguments)) {
            const EncodableList argumentList = get<EncodableList>(arguments);
            for (int i = 0; i < argumentList.size(); i++) {
                string stringArgument = get<string>(argumentList[i]);
                if (stringArgument == "hrm") {
                    error += "" + startHrm();
                } else if (stringArgument == "pedometer") {
                    error += "" + startPedometer();
                }
            }
        }

        return error;
    }


    sensor_listener_h hrListener;

    string startHrm() {
        sensor_h sensor;

        bool supported;
        int error = sensor_is_supported(SENSOR_HRM, &supported);
        if (error != SENSOR_ERROR_NONE) {
            return "sensor_is_supported error: " + to_string(error);
        }

        if (!supported) {
            return "SENSOR_HRM not supported";
        }

        int count;
        sensor_h *list;

        error = sensor_get_sensor_list(SENSOR_HRM, &list, &count);
        if (error != SENSOR_ERROR_NONE) {
            return "sensor_get_sensor_list error: " + to_string(error);
        } else {
            free(list);
        }

        error = sensor_get_default_sensor(SENSOR_HRM, &sensor);
        if (error != SENSOR_ERROR_NONE) {
            return "sensor_get_default_sensor error: " + to_string(error);
        }

        // creating an event listener
        error = sensor_create_listener(sensor, &hrListener);
        if (error != SENSOR_ERROR_NONE) {
            return "sensor_create_listener error: " + to_string(error);
        }

        string userData = "Why do I need this?";
        // Callback for sensor value change
        error = sensor_listener_set_event_cb(hrListener, 1000, on_sensor_event, &userData);
        if (error != SENSOR_ERROR_NONE) {
            return "sensor_listener_set_event_cb error: " + to_string(error);
        }

        error = sensor_listener_start(hrListener);
        if (error != SENSOR_ERROR_NONE) {
            return "sensor_listener_start error: " + to_string(error);
        }

        return "";
    }

    string startPedometer() {
        return "";
    }

    static void on_sensor_event(sensor_h sensor, sensor_event_s *event, void *user_data) {
        // Select a specific sensor with a sensor handle
        sensor_type_e type;
        sensor_get_type(sensor, &type);

        switch (type) {
            case SENSOR_HRM: {
                EncodableList wrapped = {EncodableValue("hrm"), EncodableValue(event->values[0])};
                auto arguments = std::make_unique<EncodableValue>(wrapped);
                channel_->InvokeMethod("dataReceived", move(arguments));
                break;
            }
            case SENSOR_HUMAN_PEDOMETER: {
                break;
            }
            default: {
                dlog_print(DLOG_ERROR, LOG_TAG, "Unknown event");
            }
        }
    }

    void stop() {
        sensor_listener_stop(hrListener);
        sensor_destroy_listener(hrListener);
    }

    static unique_ptr<MethodChannel<EncodableValue>> channel_;
};

unique_ptr<MethodChannel<EncodableValue>> HealthTizenPlugin::channel_;

void HealthTizenPluginRegisterWithRegistrar(
        FlutterDesktopPluginRegistrarRef registrar) {
    HealthTizenPlugin::RegisterWithRegistrar(
            PluginRegistrarManager::GetInstance()
                    ->GetRegistrar<PluginRegistrar>(registrar));
}
