import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:video_call_app/controllers/a_init.dart';
import 'package:video_call_app/views/splash_screen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyD-I2GjapPX0vzLX6R3PY61lQzQoivcHDw',
      appId: '1:958551537982:android:70695467329fdbcc1b546f',
      messagingSenderId: '958551537982',
      projectId: 'video-call-52487',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitBindings(),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      title: 'Video Call App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
