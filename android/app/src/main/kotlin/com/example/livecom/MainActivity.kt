package com.example.livecom

import androidx.lifecycle.lifecycleScope
import com.example.livecom.sdk.LiveComPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    private var liveComPlugin: LiveComPlugin? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        liveComPlugin = LiveComPlugin(flutterEngine, lifecycleScope, this)
    }
}
