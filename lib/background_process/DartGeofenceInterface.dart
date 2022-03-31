// import 'package:hrms_app/geofencing/geofencing.dart';

// /// A circular region which represents a geofence.
// abstract class GeofenceRegion {
//   /// The ID associated with the geofence.
//   ///
//   /// This ID identifies the geofence and is required to delete a
//   /// specific geofence.
//   final String id;

//   /// The location (center point) of the geofence.
//   final Location location;

//   /// The radius around `location` that is part of the geofence.
//   final double radius;

//   /// Listen to these geofence events.
//   final List<GeofenceEvent> triggers;

//   /// Android-specific settings for a geofence.
//   final AndroidGeofencingSettings androidSettings;
  
//   GeofenceRegion(
//     this.id, double latitude, double longitude, this.radius, this.triggers, this.location, this.androidSettings,
//     {androidSettings_});
// }

// abstract class GeofencingPlugin {
//   /// Initialize the plugin and request relevant permissions from the user.
  
//   /// Register for geofence events for a [GeofenceRegion].
//   ///
//   /// `region` is the geofence region to register with the system.
//   /// `callback` is the method to be called when a geofence event associated
//   /// with `region` occurs.
//   static Future<bool> registerGeofence(
//     GeofenceRegion region,
//     void Function(List<String> id, Location location, GeofenceEvent event) callback) {
//     // TODO: implement registerGeofence
//     throw UnimplementedError();
//   }

//   /// Stop receiving geofence events for a given [GeofenceRegion].
  
//   /// Stop receiving geofence events for an identifier associated with a
//   /// geofence region.
// }