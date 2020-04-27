import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/shared_preferences_service.dart';
import '../service/validate_service.dart';
import '../notifier/auth_field_notifire.dart';

/// メールアドレス入力欄
class EmailForm extends StatefulWidget {
  const EmailForm({
    @required this.formKey,
  }) : assert(formKey != null);
  final GlobalKey<FormState> formKey;
  @override
  State<StatefulWidget> createState() => EmailFormState();
}

class EmailFormState extends State<EmailForm> {
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
    final email = await getLoginID();
    setState(() {
      _controller.text = email;
      Provider.of<AuthFieldNotifier>(context, listen: false).email = email;
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
    Provider.of<AuthFieldNotifier>(context, listen: false)
        .notifyEmailValidation(isValid);
    return isValid ? null : '正しいメールアドレスを入力してください';
  }

  void _onTextFormFieldChanged() {
    widget.formKey.currentState.validate();
    debugPrint("email is changed");
    Provider.of<AuthFieldNotifier>(context, listen: false).email =
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
