package dev.rexios.workout

import android.os.SystemClock
import androidx.concurrent.futures.await
import androidx.health.services.client.ExerciseClient
import androidx.health.services.client.ExerciseUpdateCallback
import androidx.health.services.client.HealthServices
import androidx.health.services.client.data.Availability
import androidx.health.services.client.data.DataType
import androidx.health.services.client.data.ExerciseConfig
import androidx.health.services.client.data.ExerciseLapSummary
import androidx.health.services.client.data.ExerciseType
import androidx.health.services.client.data.ExerciseUpdate
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.coroutineScope
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import java.time.Instant

/** WorkoutPlugin */
class WorkoutPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, ExerciseUpdateCallback {
    private lateinit var channel: MethodChannel
    private lateinit var lifecycleScope: CoroutineScope

    private lateinit var exerciseClient: ExerciseClient

    // Generate the ExerciseType dart enum and print it to logcat for copy/paste
//    private fun generateExerciseTypeEnum() {
//        fun String.toCamelCase(): String {
//            val split = split("_")
//            return split.first().lowercase() + split.drop(1)
//                .joinToString("") { it.lowercase().replaceFirstChar { it.uppercase() } }
//        }
//        ExerciseType.VALUES.forEach {
//            val name = it.name.toCamelCase()
//            Log.d("WorkoutPlugin", "/// $name")
//            Log.d("WorkoutPlugin", "$name(${it.id}),")
//        }
//    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "workout")
        channel.setMethodCallHandler(this)

        exerciseClient =
            HealthServices.getClient(flutterPluginBinding.applicationContext).exerciseClient
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getSupportedExerciseTypes" -> getSupportedExerciseTypes(result)
            "start" -> start(call.arguments as Map<String, Any>, result)
            "stop" -> {
                stop()
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        stop()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        val lifecycle: Lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
        lifecycleScope = lifecycle.coroutineScope

        exerciseClient.setUpdateCallback(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {}
    override fun onDetachedFromActivity() {}

    private val dataTypeStringMap = mapOf(
        DataType.HEART_RATE_BPM to "heartRate",
        DataType.CALORIES_TOTAL to "calories",
        DataType.STEPS_TOTAL to "steps",
        DataType.DISTANCE_TOTAL to "distance",
        DataType.SPEED to "speed",
    )

    private fun dataTypeToString(type: DataType<*, *>): String {
        return dataTypeStringMap[type] ?: "unknown"
    }

    private fun dataTypeFromString(string: String): DataType<*, *> {
        return dataTypeStringMap.entries.firstOrNull { it.value == string }?.key
            ?: throw IllegalArgumentException("Unknown data type: $string")
    }

    private fun getSupportedExerciseTypes(result: Result) {
        lifecycleScope.launch {
            val capabilities = exerciseClient.getCapabilitiesAsync().await()
            result.success(capabilities.supportedExerciseTypes.map { it.id })
        }
    }

    private fun start(arguments: Map<String, Any>, result: Result) {
        val exerciseTypeId = arguments["exerciseType"] as Int
        val exerciseType = ExerciseType.fromId(exerciseTypeId)

        val typeStrings = arguments["sensors"] as List<String>
        val requestedDataTypes = typeStrings.map { dataTypeFromString(it) }

        val enableGps = arguments["enableGps"] as Boolean

        lifecycleScope.launch {
            val capabilities = exerciseClient.getCapabilitiesAsync().await()
            if (exerciseType !in capabilities.supportedExerciseTypes) {
                result.error("ExerciseType $exerciseType not supported", null, null)
                return@launch
            }
            val exerciseCapabilities = capabilities.getExerciseTypeCapabilities(exerciseType)
            val supportedDataTypes = exerciseCapabilities.supportedDataTypes
            val requestedUnsupportedDataTypes = requestedDataTypes.minus(supportedDataTypes)
            val requestedSupportedDataTypes = requestedDataTypes.intersect(supportedDataTypes)

            val config = ExerciseConfig(
                exerciseType = exerciseType,
                dataTypes = requestedSupportedDataTypes,
                isAutoPauseAndResumeEnabled = false,
                isGpsEnabled = enableGps,
            )

            exerciseClient.startExerciseAsync(config).await()

            // Return the unsupported data types so the developer can handle them
            result.success(mapOf("unsupportedFeatures" to requestedUnsupportedDataTypes.map {
                dataTypeToString(it)
            }))
        }
    }

    override fun onExerciseUpdateReceived(update: ExerciseUpdate) {
        val data = mutableListOf<List<Any>>()
        val bootInstant =
            Instant.ofEpochMilli(System.currentTimeMillis() - SystemClock.elapsedRealtime())

        update.latestMetrics.sampleDataPoints.forEach { dataPoint ->
            data.add(
                listOf(
                    dataTypeToString(dataPoint.dataType),
                    (dataPoint.value as Number).toDouble(),
                    dataPoint.getTimeInstant(bootInstant).toEpochMilli()
                )
            )
        }

        update.latestMetrics.cumulativeDataPoints.forEach { dataPoint ->
            data.add(
                listOf(
                    dataTypeToString(dataPoint.dataType), dataPoint.total.toDouble(),
                    // I feel like this should have getEndInstant on it like above, but whatever
                    dataPoint.end.toEpochMilli()
                )
            )
        }

        data.forEach {
            channel.invokeMethod("dataReceived", it)
        }
    }

    override fun onLapSummaryReceived(lapSummary: ExerciseLapSummary) {}
    override fun onRegistered() {}
    override fun onRegistrationFailed(throwable: Throwable) {}
    override fun onAvailabilityChanged(dataType: DataType<*, *>, availability: Availability) {}

    private fun stop() {
        exerciseClient.endExerciseAsync()
    }
}
