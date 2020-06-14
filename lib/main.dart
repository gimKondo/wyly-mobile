import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:wyly/style/color.dart';
import './screen/splash_screen.dart';
import './screen/login_screen.dart';
import './screen/home_screen.dart';
import './screen/camera_screen.dart';
import './screen/own_post_list_screen.dart';

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
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        cardColor: cardColor,
        disabledColor: disabledColor,
        accentColor: accentColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/posts': (context) => OwnPostListScreen(),
        '/camera': (context) => CameraScreen(
              camera: cameras[0],
            ),
      },
    );
  }
}
