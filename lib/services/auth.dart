import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms_app/views/login.dart';
import 'package:hrms_app/main.dart';
import 'package:hrms_app/services/my_shared_prederences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/models/profile.dart';
import 'package:hrms_app/services/http_service.dart';

import '../views/gps_alert.dart';
import 'request_location.dart';

class AuthService {
  static Future<bool> authenticateUser() async {
    //initialize Local Authentication plugin.
    final LocalAuthentication _localAuthentication = LocalAuthentication();

    //status of authentication.
    bool isAuthenticated = false;

    //check if device supports biometrics authentication.
    bool isBiometricSupported = await _localAuthentication.isDeviceSupported();

    // List<BiometricType> biometricTypes =
    //     await _localAuthentication.getAvailableBiometrics();

    //if device supports biometrics, then authenticate.
    if (isBiometricSupported) {
      try {
        isAuthenticated = await _localAuthentication.authenticate(
            localizedReason: 'To continue, you must complete the biometrics',
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true);
      } on PlatformException catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    return isAuthenticated;
  }

  logout(context) {
    MySharedPreferences.instance.setStringValue("logged_in", "");

    final Profile profile = Provider.of<Profile>(context, listen: false);
    profile.loggedin = false;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  bioAuth(context) async {
    bool isAuthenticated = await AuthService.authenticateUser();
    if (isAuthenticated) {
      Future<bool> location = requestLocation();

      // ignore: unrelated_type_equality_checks
      if (location == false) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GpsAlert()),
        );
      } else {
        MySharedPreferences.instance.setStringValue("logged_in", "true");

        final Profile profile = Provider.of<Profile>(context, listen: false);

        profile.loggedin = true;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication failed.'),
        ),
      );
    }
  }

  authUser(cin, id, passw, context) async {
    await HttpService.login(
      cin,
      id,
      passw,
      context,
    );
  }
}
