import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../screen/sign_up_screen.dart';
import '../service/auth_service.dart';
import '../service/ui_service.dart';
import '../service/shared_preferences_service.dart';
import '../style/text_style.dart';
import '../notifier/auth_field_notifire.dart';
import '../widget/email_form.dart';
import '../widget/password_form.dart';

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
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(45.0),
            child: ChangeNotifierProvider(
              create: (context) => AuthFieldNotifier(),
              child: _LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 120,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        _GoogleLoginButton(),
        Padding(
          padding: EdgeInsets.only(top: 30.0),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0),
          child: EmailForm(
            formKey: _emailFormKey,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0),
          child: PasswordForm(
            formKey: _passwordFormKey,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'IDを保存',
              style: plainTextStyle,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
            ),
            Consumer<AuthFieldNotifier>(
              builder: (context, model, child) {
                return CupertinoSwitch(
                  onChanged: (value) {
                    setState(() {
                      model.canKeepEmail = value;
                    });
                  },
                  value: model.canKeepEmail,
                  activeColor: Theme.of(context).primaryColor,
                );
              },
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        _LoginButton(
          emailFormKey: _emailFormKey,
          passwordFormKey: _passwordFormKey,
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.0),
        ),
        Row(
          children: <Widget>[
            Text('新規登録は', style: plainTextStyle),
            InkWell(
              child: Text(
                'こちら',
                style: linkedPlainTextStyle,
              ),
              onTap: () async {
                await Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (context) => SignUpScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
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

/// ログインボタン
///
/// ログインを実行するボタン。
/// フォームのバリデーションのためにフォームキーを持つ。
class _LoginButton extends StatefulWidget {
  _LoginButton({
    @required GlobalKey<FormState> emailFormKey,
    @required GlobalKey<FormState> passwordFormKey,
  })  : _emailFormKey = emailFormKey,
        _passwordFormKey = passwordFormKey;
  final GlobalKey<FormState> _emailFormKey;
  final GlobalKey<FormState> _passwordFormKey;

  Future<void> _onLoginButtonPressed(
      BuildContext context, AuthFieldNotifier loginField) async {
    final email = loginField.email;
    final password = loginField.password;
    final canKeepEmail = loginField.canKeepEmail;
    // 現在の仕様ではバリデーションでエラーになることはない(ボタンが押せなくなるため)
    debugPrint("Login button is pressed. email:[$email]");
    if (_emailFormKey.currentState.validate() &&
        _passwordFormKey.currentState.validate()) {
      if (!canKeepEmail) {
        // ID保存スイッチがオフのときはログイン成否にかかわらずIDクリアする
        await clearLoginID();
      }

      // ログイン処理を実行する
      showIndicator(context);
      try {
        await AuthService().signInByEmailAndPass(email, password);
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

      debugPrint("Checking auth... email:[$email]");
      if (canKeepEmail) {
        // ID保存スイッチがオンかつログイン成功時にログインIDを保存する
        await saveLoginID(email);
      }
      await Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (route) => false);
    } else {
      showErrorDialog(context, 'Fail to login');
    }
  }

  @override
  State<StatefulWidget> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      alignment: Alignment.center,
      child: _buildButton(),
    );
  }

  // ボタン
  Widget _buildButton() {
    return Consumer<AuthFieldNotifier>(
      builder: (context, model, child) {
        // validationをパスした場合のみボタンを有効化する
        return ButtonTheme(
          minWidth: 200,
          height: 50,
          child: RaisedButton(
            onPressed: model.isValidAll()
                ? () => widget._onLoginButtonPressed(context, model)
                : null, // == null のとき, ボタンは disabled
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
            ),
            color: Theme.of(context).primaryColor,
            child: child,
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'ログイン',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
