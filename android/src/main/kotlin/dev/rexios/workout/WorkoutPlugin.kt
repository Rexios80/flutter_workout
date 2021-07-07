package dev.rexios.workout

import android.app.Activity
import androidx.annotation.NonNull
import androidx.health.services.client.HealthServices
import androidx.health.services.client.HealthServicesClient
import androidx.health.services.client.MeasureCallback
import androidx.health.services.client.data.Availability
import androidx.health.services.client.data.DataPoint
import androidx.health.services.client.data.DataType
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
class WorkoutPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private val tag = "WorkoutPlugin"

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
            "start" -> start(call.arguments as List<String>)
            "stop" -> stop()
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
}
