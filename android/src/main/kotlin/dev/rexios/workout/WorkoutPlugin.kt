package dev.rexios.workout

import android.app.Activity
import androidx.annotation.NonNull
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.fitness.Fitness
import com.google.android.gms.fitness.FitnessOptions
import com.google.android.gms.fitness.data.DataType
import com.google.android.gms.fitness.request.OnDataPointListener
import com.google.android.gms.fitness.request.SensorRequest
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.TimeUnit

/** WorkoutPlugin */
class WorkoutPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private val tag = "WorkoutPlugin"
    private val googleFitPermissionsRequestCode = 1

    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity

    private lateinit var fitnessOptions: FitnessOptions
    private val dataTypes = mutableListOf<DataType>()

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

    private fun start(arguments: List<String>) {
        dataTypes.clear()

        if (arguments.contains("heartRate")) {
            dataTypes.add(DataType.TYPE_HEART_RATE_BPM)
        }
        if (arguments.contains("calories")) {
            dataTypes.add(DataType.TYPE_CALORIES_EXPENDED)
        }
        if (arguments.contains("steps")) {
            dataTypes.add(DataType.TYPE_STEP_COUNT_DELTA)
        }
        if (arguments.contains("distance")) {
            dataTypes.add(DataType.TYPE_DISTANCE_DELTA)
        }
        if (arguments.contains("speed")) {
            dataTypes.add(DataType.TYPE_SPEED)
        }

        val fitnessOptionsBuilder = FitnessOptions.builder()
        dataTypes.forEach { fitnessOptionsBuilder.addDataType(it) }
        fitnessOptions = fitnessOptionsBuilder.build()

        val account = GoogleSignIn.getAccountForExtension(activity, fitnessOptions)

        if (!GoogleSignIn.hasPermissions(account, fitnessOptions)) {
            GoogleSignIn.requestPermissions(
                activity,
                googleFitPermissionsRequestCode,
                account,
                fitnessOptions
            )
        } else {
            startGoogleFit()
        }
    }

    private fun stop() {
        stopGoogleFit()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener { requestCode, resultCode, data ->
            when (resultCode) {
                Activity.RESULT_OK -> when (requestCode) {
                    googleFitPermissionsRequestCode -> startGoogleFit()
                }
            }
            return@addActivityResultListener true
        }
    }

    private val listener = OnDataPointListener { dataPoint ->
        when (dataPoint.dataType) {
            DataType.TYPE_HEART_RATE_BPM -> {

            }
        }
        for (field in dataPoint.dataType.fields) {
            val value = dataPoint.getValue(field)
            Log.i(tag, "Detected DataPoint field: ${field.name}")
            Log.i(tag, "Detected DataPoint value: $value")
        }
    }

    private fun startGoogleFit() {
        val sensorClient = Fitness.getSensorsClient(
            activity,
            GoogleSignIn.getAccountForExtension(activity, fitnessOptions)
        )

        dataTypes.forEach {
            sensorClient.add(
                SensorRequest.Builder()
                    .setDataType(it)
                    .setSamplingRate(1, TimeUnit.SECONDS)
                    .build(),
                listener
            ).addOnSuccessListener {
                Log.i(tag, "Listener registered!")
            }.addOnFailureListener {
                Log.e(tag, "Listener not registered.")
            }
        }
    }

    private fun stopGoogleFit() {
        Fitness.getSensorsClient(
            activity,
            GoogleSignIn.getAccountForExtension(activity, fitnessOptions)
        )
            .remove(listener)
            .addOnSuccessListener {
                Log.i(tag, "Listener was removed!")
            }
            .addOnFailureListener {
                Log.i(tag, "Listener was not removed.")
            }
    }

    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {}
    override fun onDetachedFromActivity() {}
}
