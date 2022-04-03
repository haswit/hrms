import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms_app/home.dart';
import 'package:hrms_app/navigatino_home_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/models/profile.dart';

class AuthService {
  static Future<bool> authenticateUser() async {
    //initialize Local Authentication plugin.
    final LocalAuthentication _localAuthentication = LocalAuthentication();

    //status of authentication.
    bool isAuthenticated = false;

    //check if device supports biometrics authentication.
    bool isBiometricSupported = await _localAuthentication.isDeviceSupported();

    List<BiometricType> biometricTypes =
        await _localAuthentication.getAvailableBiometrics();

    print(biometricTypes);

    //if device supports biometrics, then authenticate.
    if (isBiometricSupported) {
      try {
        isAuthenticated = await _localAuthentication.authenticate(
            localizedReason: 'To continue, you must complete the biometrics',
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true);
      } on PlatformException catch (e) {
        print(e);
      }
    }

    return isAuthenticated;
  }
}

void logout(context) {
  final Profile profile = Provider.of<Profile>(context, listen: false);
  print("CLICKED LOGOUT=========================");
  profile.loggedin = false;
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Home()),
  );
}
