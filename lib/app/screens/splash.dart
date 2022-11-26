// splash screen

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed('/home');
  }

  _checkPermissions() async {
    // we need access to storage, wifi, type of network, and location
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      await Permission.location.request();
      await Permission.locationWhenInUse.request();
      await Permission.locationAlways.request();

      // we check again if we have permission
      // if we don't have permission, we show a dialog
      // if user still doesn't give permission, we close the app
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission denied'),
            content: const Text('You need to give permission to use this app'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0x00111111),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logo.png',
                height: 200,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
