import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'first_splash_screen.dart'; // Add this import
import 'auth_service.dart'; // Import AuthService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.initialize();
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      home: const SplashScreenFirst(), // This will now use the imported class
    );
  }
}
