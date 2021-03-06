import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:wyly/style/color.dart';
import 'package:wyly/config.dart';
import './screen/splash_screen.dart';
import './screen/login_screen.dart';
import './screen/home_screen.dart';
import './screen/camera_screen.dart';
import './screen/own_post_list_screen.dart';

class AppRoot extends StatelessWidget {
  AppRoot(this.cameras);
  final List<CameraDescription> cameras;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.of(context).appTitle,
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
