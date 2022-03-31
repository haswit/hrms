import 'package:geofence/geofence.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:geofencing/geofencing.dart';

abstract class GeofencingPlugin {
  static const MethodChannel _channel =
      const MethodChannel('plugins.flutter.io/geofencing_plugin');

  static Future<bool> initialize() async {
    final callback = PluginUtilities.getCallbackHandle(callbackDispatcher);
    await _channel.invokeMethod('GeofencingPlugin.initializeService',
        <dynamic>[callback.toRawHandle()]);
  }

  static Future<bool> registerGeofence(
      GeofenceRegion region,
      void Function(List<String> id, Location location, GeofenceEvent event)
          callback) {
    if (Platform.isIOS &&
        region.triggers.contains(GeofenceEvent.dwell) &&
        (region.triggers.length == 1)) {
      throw UnsupportedError("iOS does not support 'GeofenceEvent.dwell'");
    }
    final args = <dynamic>[
      PluginUtilities.getCallbackHandle(callback).toRawHandle()
    ];
    args.addAll(region._toArgs());
    _channel.invokeMethod('GeofencingPlugin.registerGeofence', args);
  }

  /*
  * … `removeGeofence` methods here …
  */
}
