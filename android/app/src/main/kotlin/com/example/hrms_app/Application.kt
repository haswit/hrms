package com.example.hrms_app

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
// import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingPlugin
import io.flutter.view.FlutterMain
// import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService


class Application : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        // FlutterFirebaseMessagingService.setPluginRegistrant(this);
        // FlutterMain.startInitialization(this)
        // GeofencingService.setPluginRegistrant(this);
    }

    override fun registerWith(registry: PluginRegistry?) {
        // GeneratedPluginRegistrant.registerWith(registry);
        // if (!registry!!.hasPlugin("io.flutter.plugins.firebasemessaging")) {
        //     FlutterFirebaseMessagingPlugin.registerWith(registry!!.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
        // }
    }
}
