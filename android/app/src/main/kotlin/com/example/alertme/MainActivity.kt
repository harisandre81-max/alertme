package com.example.alertme

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.IntentFilter
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class MainActivity: FlutterActivity() {

    private val CHANNEL = "sos_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    val filter = IntentFilter()
    filter.addAction("com.example.alertme.SOS_TRIGGER")

    val receiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            android.util.Log.d("SOS_TEST", "🔥 Broadcast recibido")
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .invokeMethod("triggerSOS", null)
        }
    }

    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
        registerReceiver(receiver, filter, Context.RECEIVER_EXPORTED)
    } else {
        registerReceiver(receiver, filter)
    }
}
}