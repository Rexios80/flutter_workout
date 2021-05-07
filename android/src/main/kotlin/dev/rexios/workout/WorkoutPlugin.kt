package dev.rexios.workout

import androidx.annotation.NonNull
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.fitness.FitnessOptions
import com.google.android.gms.fitness.data.DataType
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** WorkoutPlugin */
class WorkoutPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private val googleFitPermissionsRequestCode = 1

    private lateinit var channel: MethodChannel
    private lateinit var activity: FlutterActivity

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
        val fitnessOptionsBuilder = FitnessOptions.builder()
        if (arguments.contains("heartRate")) {
            fitnessOptionsBuilder.addDataType(
                DataType.TYPE_HEART_RATE_BPM,
                FitnessOptions.ACCESS_READ
            )
        }
        if (arguments.contains("calories")) {
            fitnessOptionsBuilder.addDataType(
                DataType.TYPE_CALORIES_EXPENDED,
                FitnessOptions.ACCESS_READ
            )
        }
        if (arguments.contains("steps")) {
            fitnessOptionsBuilder.addDataType(
                DataType.TYPE_STEP_COUNT_DELTA,
                FitnessOptions.ACCESS_READ
            )
        }
        if (arguments.contains("distance")) {
            fitnessOptionsBuilder.addDataType(
                DataType.TYPE_DISTANCE_DELTA,
                FitnessOptions.ACCESS_READ
            )
        }
        if (arguments.contains("speed")) {
            fitnessOptionsBuilder.addDataType(DataType.TYPE_SPEED, FitnessOptions.ACCESS_READ)
        }
        val fitnessOptions = fitnessOptionsBuilder.build()

        val account = GoogleSignIn.getAccountForExtension(activity, fitnessOptions)

        if (!GoogleSignIn.hasPermissions(account, fitnessOptions)) {
            GoogleSignIn.requestPermissions(
                activity,
                googleFitPermissionsRequestCode,
                account,
                fitnessOptions
            )
        } else {
            accessGoogleFit()
        }
    }

    private fun stop() {

    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterActivity
    }

    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {}
    override fun onDetachedFromActivity() {}
}
