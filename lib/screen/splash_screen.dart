import 'package:flutter/material.dart';

import '../service/auth_service.dart';

/// Splash 画面
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // スプラッシュ画面が見えるよう最低2秒遷移させない
      Future.delayed(Duration(milliseconds: 2000), () async {
        final user = await AuthService().getFirebaseUser();
        if (user != null) {
          await Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (_) => false);
        } else {
          await Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (_) => false);
        }
      });
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
