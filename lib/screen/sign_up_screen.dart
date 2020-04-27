import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/auth_service.dart';
import '../service/ui_service.dart';
import '../service/shared_preferences_service.dart';
import '../notifier/auth_field_notifire.dart';
import '../widget/email_form.dart';
import '../widget/password_form.dart';
import '../widget/standard_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
              child: _SignUpForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    );
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.asset(
            'assets/images/logo.png',
            width: 120,
            height: 120,
          ),
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
                style: defaultTextStyle,
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
          _SignUpButton(
            emailFormKey: _emailFormKey,
            passwordFormKey: _passwordFormKey,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          StandardButton(
            onTap: () async => await Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false),
            text: 'キャンセル',
            color: Theme.of(context).disabledColor,
          ),
        ]);
  }
}

/// 新規登録ボタン
///
/// ログインを実行するボタン。
/// フォームのバリデーションのためにフォームキーを持つ。
class _SignUpButton extends StatefulWidget {
  _SignUpButton({
    @required GlobalKey<FormState> emailFormKey,
    @required GlobalKey<FormState> passwordFormKey,
  })  : _emailFormKey = emailFormKey,
        _passwordFormKey = passwordFormKey;
  final GlobalKey<FormState> _emailFormKey;
  final GlobalKey<FormState> _passwordFormKey;

  Future<void> _onSignUpButtonPressed(
      BuildContext context, AuthFieldNotifier loginField) async {
    final email = loginField.email;
    final password = loginField.password;
    final canKeepEmail = loginField.canKeepEmail;
    // 現在の仕様ではバリデーションでエラーになることはない(ボタンが押せなくなるため)
    debugPrint("Sign Up button is pressed. email:[$email]");
    if (_emailFormKey.currentState.validate() &&
        _passwordFormKey.currentState.validate()) {
      if (!canKeepEmail) {
        // ID保存スイッチがオフのときはログイン成否にかかわらずIDクリアする
        await clearLoginID();
      }

      // ログイン処理を実行する
      showIndicator(context);
      try {
        await AuthService().signUpByEmailAndPass(email, password);
      } on Exception catch (e) {
        Navigator.of(context).pop();
        showErrorDialog(context, "Fail to sign up.\n$e");
        return;
      } catch (e) {
        //  ネットワーク未接続など、APIにアクセス出来ない場合は汎用エラーを出して完了
        Navigator.of(context).pop();
        showErrorDialog(context, "sign up error.\n$e");
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
      showErrorDialog(context, 'Fail to sign up');
    }
  }

  @override
  State<StatefulWidget> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<_SignUpButton> {
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
                ? () => widget._onSignUpButtonPressed(context, model)
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
          '新規登録',
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
