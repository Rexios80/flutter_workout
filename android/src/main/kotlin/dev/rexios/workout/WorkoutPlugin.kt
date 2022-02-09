package dev.rexios.workout

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import androidx.health.services.client.HealthServices
import androidx.health.services.client.HealthServicesClient
import androidx.health.services.client.MeasureCallback
import androidx.health.services.client.data.Availability
import androidx.health.services.client.data.DataPoint
import androidx.health.services.client.data.DataType
import androidx.health.services.client.data.PassiveMonitoringUpdate
import androidx.lifecycle.coroutineScope
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

/** WorkoutPlugin */
class WorkoutPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, BroadcastReceiver() {
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity
    private lateinit var lifecycleScope: CoroutineScope

    private val dataTypes = mutableListOf<DataType>()
    private lateinit var healthClient: HealthServicesClient

    // Since the system gives these to us in delta values we have to keep track of the total
    private var calories = 0.0
    private var steps = 0.0
    private var distance = 0.0

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "workout")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "start" -> {
                start(call.arguments as List<String>)
                result.success(null)
            }
            "stop" -> {
                stop()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        lifecycleScope = (binding.lifecycle as HiddenLifecycleReference).lifecycle.coroutineScope
        healthClient = HealthServices.getClient(activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {}
    override fun onDetachedFromActivity() {}

    private val dataCallback = object : MeasureCallback {
        override fun onAvailabilityChanged(dataType: DataType, availability: Availability) {
            // Handle availability change.
        }

        override fun onData(data: List<DataPoint>) {
            val dataPoint = data.first()

            when (dataPoint.dataType) {
                DataType.HEART_RATE_BPM -> channel.invokeMethod(
                    "dataReceived",
                    listOf("heartRate", dataPoint.value.asDouble())
                )
                DataType.TOTAL_CALORIES -> {
                    calories += dataPoint.value.asDouble()
                    channel.invokeMethod(
                        "dataReceived",
                        listOf("calories", calories)
                    )
                }
                DataType.STEPS -> {
                    steps += dataPoint.value.asDouble()
                    channel.invokeMethod(
                        "dataReceived",
                        listOf("steps", steps.toInt())
                    )
                }
                DataType.DISTANCE -> {
                    distance += dataPoint.value.asDouble()
                    channel.invokeMethod(
                        "dataReceived",
                        listOf("distance", distance)
                    )
                }
                DataType.SPEED -> channel.invokeMethod(
                    "dataReceived",
                    listOf("speed", dataPoint.value.asDouble())
                )
            }
        }
    }

    private fun start(arguments: List<String>) {
        dataTypes.clear()

        if (arguments.contains("heartRate")) {
            dataTypes.add(DataType.HEART_RATE_BPM)
        }
        if (arguments.contains("calories")) {
            dataTypes.add(DataType.TOTAL_CALORIES)
        }
        if (arguments.contains("steps")) {
            dataTypes.add(DataType.STEPS)
        }
        if (arguments.contains("distance")) {
            dataTypes.add(DataType.DISTANCE)
        }
        if (arguments.contains("speed")) {
            dataTypes.add(DataType.SPEED)
        }

        // Register the callback.
        lifecycleScope.launch {
            dataTypes.forEach {
                healthClient.measureClient.registerCallback(it, dataCallback)
            }
        }
    }

    private fun stop() {
        calories = 0.0
        steps = 0.0
        distance = 0.0

        // Unregister the callback.
        lifecycleScope.launch {
            dataTypes.forEach {
                healthClient.measureClient.unregisterCallback(it, dataCallback)
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        // val state = PassiveMonitoringUpdate.fromIntent(intent) ?: return
        // // Get the most recent heart rate measurement.
        // val latestDataPoint = state.dataPoints
        //     // dataPoints can have multiple types (e.g. if the app registered for multiple types).
        //     .filter { it.dataType == DataType.HEART_RATE_BPM }
        //     // where accuracy information is available, only show readings that are of medium or
        //     // high accuracy. (Where accuracy information isn't available, show the reading if it is
        //     // a positive value).
        //     .filter {
        //         it.accuracy == null ||
        //                 setOf(
        //                     HrAccuracy.SensorStatus.ACCURACY_MEDIUM,
        //                     HrAccuracy.SensorStatus.ACCURACY_HIGH
        //                 ).contains((it.accuracy as HrAccuracy).sensorStatus)
        //     }
        //     .filter {
        //         it.value.asDouble() > 0
        //     }
        //     // HEART_RATE_BPM is a SAMPLE type, so start and end times are the same.
        //     .maxByOrNull { it.endDurationFromBoot }
        // // If there were no data points, the previous function returns null.
        //     ?: return

        // val latestHeartRate = latestDataPoint.value.asDouble() // HEART_RATE_BPM is a Float type.
        // Log.d(TAG, "Received latest heart rate in background: $latestHeartRate")

        // runBlocking {
        //     repository.storeLatestHeartRate(latestHeartRate)
        // }
    }
}
