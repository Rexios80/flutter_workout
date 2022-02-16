package dev.rexios.workout

import android.os.SystemClock
import androidx.annotation.NonNull
import androidx.concurrent.futures.await
import androidx.health.services.client.ExerciseClient
import androidx.health.services.client.ExerciseUpdateListener
import androidx.health.services.client.HealthServices
import androidx.health.services.client.data.*
import io.flutter.Log
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
class WorkoutPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private val tag = "Workout"

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
                this@WorkoutPlugin.onExerciseUpdate(update)
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

    // This should probably me more developer configurable, but Tizen doesn't support any of these checks right now
    private fun start(arguments: Map<String, Any>, result: Result) {
        val exerciseTypeId = arguments["exercise"] as Int
        val exerciseType = ExerciseType.fromId(exerciseTypeId)

        val typeStrings = arguments["sensors"] as List<String>
        val requestedDataTypes = typeStrings.map { dataTypeFromString(it) }

        lifecycleScope.launch {
            val capabilities = exerciseClient.capabilities.await()
            if (exerciseType !in capabilities.supportedExerciseTypes) {
                result.error("ExerciseType $exerciseType not supported", null, null)
                return@launch
            }
            val exerciseCapabilities = capabilities.getExerciseTypeCapabilities(exerciseType)
            val supportedDataTypes = exerciseCapabilities.supportedDataTypes
            val requestedUnsupportedDataTypes = requestedDataTypes.minus(supportedDataTypes)
            val requestedSupportedDataTypes = requestedDataTypes.intersect(supportedDataTypes)

            if (requestedUnsupportedDataTypes.isNotEmpty()) {
                Log.d(
                    tag,
                    "DataTypes were requested that are unsupported by ExerciseType $exerciseType: $requestedUnsupportedDataTypes"
                )
            }

            // Types for which we want to receive metrics.
            val dataTypes = requestedSupportedDataTypes.intersect(
                setOf(DataType.HEART_RATE_BPM, DataType.SPEED)
            )

            // Types for which we want to receive aggregate metrics.
            val aggregateDataTypes = requestedSupportedDataTypes.intersect(
                setOf(
                    // "Total" here refers not to the aggregation but to basal + activity.
                    DataType.TOTAL_CALORIES,
                    DataType.STEPS,
                    DataType.DISTANCE
                )
            )

            val config = ExerciseConfig.builder()
                .setExerciseType(exerciseType)
                .setDataTypes(dataTypes)
                .setAggregateDataTypes(aggregateDataTypes)
                .build()

            exerciseClient
                .startExercise(config)
                .await()

            result.success(null)
        }
    }

    private fun onExerciseUpdate(update: ExerciseUpdate) {
        val data = mutableListOf<List<Any>>()
        val bootInstant =
            Instant.ofEpochMilli(System.currentTimeMillis() - SystemClock.elapsedRealtime())

        update.latestMetrics.forEach { (type, values) ->
            values.forEach { dataPoint ->
                data.add(
                    listOf(
                        dataTypeToString(type),
                        dataPoint.value.asDouble(),
                        dataPoint.getEndInstant(bootInstant).toEpochMilli()
                    )
                )
            }
        }

        update.latestAggregateMetrics.forEach { (type, value) ->
            val dataPoint = (value as CumulativeDataPoint)
            data.add(
                listOf(
                    dataTypeToString(type),
                    dataPoint.total.asDouble(),
                    bootInstant.plusMillis(dataPoint.endTime.toEpochMilli()).toEpochMilli()
                )
            )
        }

        data.forEach {
            channel.invokeMethod("dataReceived", it)
        }
    }

    private fun stop() {
        lifecycleScope.launch {
            exerciseClient.endExercise()
        }
    }
}
