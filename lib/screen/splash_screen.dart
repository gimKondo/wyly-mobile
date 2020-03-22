import 'package:flutter/material.dart';

/// Splash 画面
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // スプラッシュ画面が見えるよう最低2秒遷移させない
      Future.delayed(
        Duration(milliseconds: 2000),
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false),
      );
    });
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/splash.png',
            width: 120,
            height: 120,
          ),
        ),
        Positioned(
          child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Text('Wyly Works')),
        ),
      ]),
    );
  }
}
