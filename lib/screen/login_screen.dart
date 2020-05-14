import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../service/auth_service.dart';
import '../service/ui_service.dart';
import '../style/text_style.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text('Wyly', style: titleTextStyle),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              Image.asset(
                'assets/images/logo.png',
                width: 120,
                height: 120,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              _GoogleLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.GoogleDark,
      text: "Sign in with Google",
      onPressed: () => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    debugPrint('Sign in with Google');

    // ログイン処理を実行する
    showIndicator(context);
    try {
      await AuthService().signInByGoogle();
    } on Exception catch (e) {
      Navigator.of(context).pop();
      showErrorDialog(context, "Fail to login.\n$e");
      return;
    } catch (e) {
      //  ネットワーク未接続など、APIにアクセス出来ない場合は汎用エラーを出して完了
      Navigator.of(context).pop();
      showErrorDialog(context, "login error.\n$e");
      return;
    }
    Navigator.of(context).pop();

    await Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (route) => false);
  }
}
