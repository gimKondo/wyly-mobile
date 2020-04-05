import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/auth_service.dart';
import '../service/ui_service.dart';
import '../service/validate_service.dart';

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
              create: (context) => _LoginFieldStatus(),
              child: _LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginFieldStatus extends ChangeNotifier {
  bool isValidEmail = false;
  bool isValidPassword = false;
  bool canKeepEmail = true;
  String email = '';
  String password = '';

  void notifyEmailValidation(bool isValid) {
    isValidEmail = isValid;
    notifyListeners();
  }

  void notifyPasswordValidation(bool isValid) {
    isValidPassword = isValid;
    notifyListeners();
  }

  bool isValidAll() => isValidEmail && isValidPassword;
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
        Text(
          'ID :',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0),
          child: _EmailForm(
            formKey: _emailFormKey,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        Text(
          'PASSWORD :',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0),
          child: _PasswordForm(
            formKey: _passwordFormKey,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'IDを保存する',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
            ),
            Consumer<_LoginFieldStatus>(
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
      ],
    );
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

  /// ログインIDを保存する
  Future<void> _saveLoginId(String email) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('canKeepEmail', true);
    await pref.setString('email', email);
  }

  /// アプリが保持するログインIDをクリアする
  Future<void> _clearLoginId() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('canKeepEmail', false);
    await pref.setString('email', '');
  }

  Future<void> _onLoginButtonPressed(BuildContext context) async {
    debugPrint("Login button is pressed.");
    final email = Provider.of<_LoginFieldStatus>(context).email;
    final password = Provider.of<_LoginFieldStatus>(context).password;
    final canKeepEmail = Provider.of<_LoginFieldStatus>(context).canKeepEmail;
    // 現在の仕様ではバリデーションでエラーになることはない(ボタンが押せなくなるため)
    debugPrint("Login button is pushed. email:[$email]");
    if (_emailFormKey.currentState.validate() &&
        _passwordFormKey.currentState.validate()) {
      if (!canKeepEmail) {
        // ID保存スイッチがオフのときはログイン成否にかかわらずIDクリアする
        await _clearLoginId();
      }

      // ログイン処理を実行する
      showIndicator(context);
      try {
        await AuthService().loginByEmailAndPass(email, password);
      } on Exception {
        //  ネットワーク未接続など、APIにアクセス出来ない場合は汎用エラーを出して完了
        Navigator.of(context).pop();
        showErrorDialog(context, "Fail to login");
        return;
      }
      Navigator.of(context).pop();

      debugPrint("Checking auth... email:[$email]");
      if (canKeepEmail) {
        // ID保存スイッチがオンかつログイン成功時にログインIDを保存する
        await _saveLoginId(email);
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
      height: 47,
      child: Consumer<_LoginFieldStatus>(
        builder: (context, model, child) {
          // validationをパスした場合のみボタンを有効化する
          return RaisedButton(
            onPressed: model.isValidAll()
                ? () => widget._onLoginButtonPressed(context)
                : null, // == null のとき, ボタンは disabled
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
            ),
            color: Theme.of(context).primaryColor,
            child: child,
          );
        },
        child: Container(
          height: 50,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'ログイン',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

/// メールアドレス入力欄
class _EmailForm extends StatefulWidget {
  const _EmailForm({
    @required this.formKey,
  }) : assert(formKey != null);
  final GlobalKey<FormState> formKey;
  @override
  State<StatefulWidget> createState() => _EmailFormState();
}

class _EmailFormState extends State<_EmailForm> {
  /// コントローラ
  final _controller = TextEditingController();

  /// フォームの文字色
  Color _textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final pref = await SharedPreferences.getInstance();
    final email = pref.getString('email') ?? '';
    setState(() {
      _controller.text = email;
      Provider.of<_LoginFieldStatus>(context, listen: false).email = email;
      // 空白以外の初期値に対してはバリデーションを行う
      if (email != '') {
        _validateEmail(email);
      }
    });
  }

  String _validateEmail(String value) {
    // メールアドレスの形式チェックを行う
    final isValid = isValidEmai(value);
    setState(() {
      _textColor = isValid ? Colors.black : Colors.red[500];
    });
    // バリデーション結果を通知する
    Provider.of<_LoginFieldStatus>(context, listen: false)
        .notifyEmailValidation(isValid);
    return isValid ? null : '正しいメールアドレスを入力してください';
  }

  void _onTextFormFieldChanged() {
    widget.formKey.currentState.validate();
    debugPrint("email is changed");
    Provider.of<_LoginFieldStatus>(context, listen: false).email =
        _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'メールアドレスを入力してください',
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[300],
              width: 0.0,
            ),
            borderRadius: BorderRadius.circular(32.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          prefixIcon: Icon(
            Icons.mail_outline,
            color: Theme.of(context).primaryColor,
          ),
          filled: true,
          fillColor: Colors.grey[300],
        ),
        style: TextStyle(
          color: _textColor,
        ),
        onChanged: (text) => _onTextFormFieldChanged(),
        validator: _validateEmail,
      ),
    );
  }
}

/// パスワード入力欄
class _PasswordForm extends StatefulWidget {
  const _PasswordForm({
    @required this.formKey,
  }) : assert(formKey != null);
  final GlobalKey<FormState> formKey;
  @override
  State<StatefulWidget> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<_PasswordForm> {
  /// コントローラ
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _validatePassword(String value) {
    // ひとまず空でなければOK
    final isValid = value.isNotEmpty;
    Provider.of<_LoginFieldStatus>(context, listen: false)
        .notifyPasswordValidation(isValid);
    return isValid ? null : 'パスワードを入力してください';
  }

  void _onTextFormFieldChanged() {
    widget.formKey.currentState.validate();
    Provider.of<_LoginFieldStatus>(context, listen: false).password =
        _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'パスワードを入力してください',
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300], width: 0.0),
            borderRadius: BorderRadius.circular(32.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          prefixIcon: Icon(
            Icons.vpn_key,
            color: Theme.of(context).primaryColor,
          ),
          filled: true,
          fillColor: Colors.grey[300],
        ),
        obscureText: true,
        onChanged: (text) => _onTextFormFieldChanged(),
        validator: _validatePassword,
      ),
    );
  }
}
