import UIKit
import Flutter
import GoogleMaps  // Add this import


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyCYN6YXuCbg2bQYKcmP6So4csr8WDGNLhE")

     if (@available(iOS 10.0, *)) {
    [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
  }

 

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

