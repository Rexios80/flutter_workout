package dev.rexios.workout

import androidx.annotation.NonNull
import androidx.concurrent.futures.await
import androidx.health.services.client.ExerciseClient
import androidx.health.services.client.ExerciseUpdateListener
import androidx.health.services.client.HealthServices
import androidx.health.services.client.MeasureCallback
import androidx.health.services.client.data.*
import androidx.health.services.client.proto.DataProto
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

/** WorkoutPlugin */
class WorkoutPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var lifecycleScope: CoroutineScope

    private lateinit var exerciseClient: ExerciseClient

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "workout")
        channel.setMethodCallHandler(this)

        exerciseClient =
            HealthServices.getClient(flutterPluginBinding.applicationContext).exerciseClient

        val listener = object : ExerciseUpdateListener {
            override fun onExerciseUpdate(update: ExerciseUpdate) {
                update.latestMetrics.forEach { key, values ->
                    values.forEach {
                        channel.invokeMethod("")
                    }
                }
                // Process the latest information about the exercise.
                exerciseStatus = update.state // e.g. ACTIVE, USER_PAUSED, etc.
                activeDuration = update.activeDuration // Duration
                latestMetrics = update.latestMetrics // Map<DataType, List<DataPoint>>
                latestAggregateMetrics =
                    update.latestAggregateMetrics // Map<DataType, AggregateDataPoint>
                latestGoals = update.latestAchievedGoals // Set<AchievedExerciseGoal>
                latestMilestones =
                    update.latestMilestoneMarkerSummaries // Set<MilestoneMarkerSummary>

            }

            override fun onLapSummary(lapSummary: ExerciseLapSummary) {}
            override fun onAvailabilityChanged(dataType: DataType, availability: Availability) {}
        }

        lifecycleScope.launch {
            exerciseClient.setUpdateListener(listener).await()
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "start" -> {
                start(call.arguments as Map<String, Any>, result)
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
        stop()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        lifecycleScope = FlutterLifecycleAdapter.getActivityLifecycle(binding).coroutineScope
    }

    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {}
    override fun onDetachedFromActivity() {}

    private fun dataTypeToString(type: DataType): String {
        return when (type) {
            DataType.HEART_RATE_BPM -> "heartRate"
            DataType.TOTAL_CALORIES -> "calories"
            DataType.STEPS -> "steps"
            DataType.DISTANCE -> "distance"
            DataType.SPEED -> "speed"
            else -> "unknown"
        }
    }

    private fun dataTypeFromString(string: String): DataType {
        return when (string) {
            "heartRate" -> DataType.HEART_RATE_BPM
            "calories" -> DataType.TOTAL_CALORIES
            "steps" -> DataType.STEPS
            "distance" -> DataType.DISTANCE
            "speed" -> DataType.SPEED
            else -> throw IllegalArgumentException()
        }
    }

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

    // This should probably me more developer configurable, but Tizen doesn't support any of these checks right now
    private fun start(arguments: Map<String, Any>, result: Result) {
        val exerciseTypeId = arguments["exercise"] as Int
        val exerciseType = ExerciseType.fromId(exerciseTypeId)

        val typeStrings = arguments["sensors"] as List<String>
        val types = typeStrings.map { dataTypeFromString(it) }

        lifecycleScope.launch {
            val capabilities = exerciseClient.capabilities.await()
            if (exerciseType !in capabilities.supportedExerciseTypes) {
                result.error("ExerciseType not supported", null, null)
                return@launch
            }
            val exerciseCapabilities = capabilities.getExerciseTypeCapabilities(exerciseType)
            val supportedDataTypes = exerciseCapabilities.supportedDataTypes

            result.success(null)
        }
    }

    private fun stop() {
        lifecycleScope.launch {
            exerciseClient.endExercise()
        }
    }
}
