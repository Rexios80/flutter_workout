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
#include <list>

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
                        registrar->messenger(), "workout",
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

    list<sensor_listener_h> sensorListeners;

    string start(const EncodableValue arguments) {
        string error = "";
        if (holds_alternative<EncodableList>(arguments)) {
            const EncodableList argumentList = get<EncodableList>(arguments);
            for (int i = 0; i < argumentList.size(); i++) {
                string stringArgument = get<string>(argumentList[i]);
                sensor_listener_h listener;
                sensorListeners.push_front(listener);
                if (stringArgument == "heartRate") {
                    error += "" + startSensor(SENSOR_HRM, listener);
                } else if (stringArgument == "pedometer") {
                    error += "" + startSensor(SENSOR_HUMAN_PEDOMETER, listener);
                }
            }
        }

        return error;
    }

    string startSensor(sensor_type_e type, sensor_listener_h listener) {
        sensor_h sensor;

        bool supported;
        int error = sensor_is_supported(type, &supported);
        if (error != SENSOR_ERROR_NONE) {
            return "sensor_is_supported error: " + to_string(type) + ", " + to_string(error);
        }

        if (!supported) {
            return "SENSOR_HRM not supported";
        }

        int count;
        sensor_h *list;

        error = sensor_get_sensor_list(type, &list, &count);
        if (error != SENSOR_ERROR_NONE) {
            return "sensor_get_sensor_list error: " + to_string(type) + ", " + to_string(error);
        } else {
            free(list);
        }

        error = sensor_get_default_sensor(type, &sensor);
        if (error != SENSOR_ERROR_NONE) {
            return "sensor_get_default_sensor error: " + to_string(type) + ", " + to_string(error);
        }

        // creating an event listener
        error = sensor_create_listener(sensor, &listener);
        if (error != SENSOR_ERROR_NONE) {
            return "sensor_create_listener error: " + to_string(type) + ", " + to_string(error);
        }

        string userData = "Why do I need this?";
        // Callback for sensor value change
        error = sensor_listener_set_event_cb(listener, 1000, on_sensor_event, &userData);
        if (error != SENSOR_ERROR_NONE) {
            return "sensor_listener_set_event_cb error: " + to_string(type) + ", " + to_string(error);
        }

        error = sensor_listener_start(listener);
        if (error != SENSOR_ERROR_NONE) {
            return "sensor_listener_start error: " + to_string(type) + ", " + to_string(error);
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

        EncodableList wrapped;
        switch (type) {
            case SENSOR_HRM: {
                wrapped = {EncodableValue("heartRate"), EncodableValue(event->values[0])};
                break;
            }
            case SENSOR_HUMAN_PEDOMETER: {
                wrapped = {
                        EncodableValue("pedometer"),
                        EncodableValue(event->values[0]),
                        EncodableValue(event->values[3]),
                        EncodableValue(event->values[4]),
                        EncodableValue(event->values[5]),
                };
                break;
            }
            default: {
                dlog_print(DLOG_ERROR, LOG_TAG, "Unknown event");
                return;
            }
        }

        auto arguments = std::make_unique<EncodableValue>(wrapped);
        channel_->InvokeMethod("dataReceived", move(arguments));
    }

    void stop() {
        for_each(sensorListeners.begin(), sensorListeners.end(), stopListener);
        sensorListeners.clear();
    }

    static void stopListener(sensor_listener_h listener) {
        sensor_listener_stop(listener);
        sensor_destroy_listener(listener);
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
