import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import './screen/splash_screen.dart';
import './screen/login_screen.dart';
import './screen/home_screen.dart';
import './screen/camera_screen.dart';
import './screen/own_post_screen.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wyly',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(0xFF, 0x98, 0x4F, 0x2B), // #984F2B
        cardColor: Color.fromARGB(0xFF, 0xA9, 0x6F, 0x4B), // #A96F4B
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/posts': (context) => OwnPostScreen(),
        '/camera': (context) => CameraScreen(
              camera: cameras[0],
            ),
      },
    );
  }
}
