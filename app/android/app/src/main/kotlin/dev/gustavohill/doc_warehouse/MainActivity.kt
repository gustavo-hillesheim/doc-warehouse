package dev.gustavohill.doc_warehouse

import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.widget.ImageView
import io.flutter.embedding.android.DrawableSplashScreen
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.SplashScreen
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.HashMap

class MainActivity() : FlutterActivity(), MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private val METHOD_CHANNEL = "gustavohill.shareIntentReceiver/method_channel"
    private val EVENT_CHANNEL = "gustavohill.shareIntentReceiver/event_channel"
    private var eventSink: EventChannel.EventSink? = null

    override fun provideSplashScreen(): SplashScreen? {
        val manifestSplashDrawable = getSplashScreenFromManifest();
        return DrawableSplashScreen(
                manifestSplashDrawable,
                ImageView.ScaleType.FIT_XY,
                0 // Fade in duration
        );
    }

    // Copied from FlutterActivity since it's private
    private fun getSplashScreenFromManifest(): Drawable {
        val activityInfo = getPackageManager().getActivityInfo(getComponentName(), PackageManager.GET_META_DATA)
        val metadata = activityInfo.metaData
        val splashScreenId = metadata.getInt("io.flutter.embedding.android.SplashScreenDrawable")
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP) {
            return getResources().getDrawable(splashScreenId, getTheme())
        } else {
            return getResources().getDrawable(splashScreenId)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(binaryMessenger, METHOD_CHANNEL).setMethodCallHandler(this)
        EventChannel(binaryMessenger, EVENT_CHANNEL).setStreamHandler(this)
    }

    override fun onNewIntent(intent: Intent) {
        val sharedData = handleIntent(intent)
        if (sharedData != null) {
            eventSink?.success(sharedData)
        }
    }

    private fun handleIntent(intent: Intent): Map<String, String>? {
        intent.component
        if (intent.type?.startsWith("text") != true && intent.action == Intent.ACTION_SEND) {
            println("Received sharing intent of ACTION_SEND")
            val uri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
            val path = uri?.let { FileDirectory.createTempCopy(applicationContext, it) }
            if (path != null) {
                print("Sending received intent with path $path")
                val data = HashMap<String, String>()
                data["path"] = path
                return data
            } else {
                println("Not sending received intent because path is null")
            }
        }
        return null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "getSharedData") {
            val sharedData = handleIntent(intent)
            result.success(sharedData)
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        when (arguments) {
            "sharedData" -> eventSink = events
        }
    }

    override fun onCancel(arguments: Any?) {
        when (arguments) {
            "sharedData" -> eventSink = null
        }
    }
}
