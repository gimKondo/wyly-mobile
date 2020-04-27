import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/auth_field_notifire.dart';

/// パスワード入力欄
class PasswordForm extends StatefulWidget {
  const PasswordForm({
    @required this.formKey,
  }) : assert(formKey != null);
  final GlobalKey<FormState> formKey;
  @override
  State<StatefulWidget> createState() => PasswordFormState();
}

class PasswordFormState extends State<PasswordForm> {
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
    Provider.of<AuthFieldNotifier>(context, listen: false)
        .notifyPasswordValidation(isValid);
    return isValid ? null : 'パスワードを入力してください';
  }

  void _onTextFormFieldChanged() {
    widget.formKey.currentState.validate();
    Provider.of<AuthFieldNotifier>(context, listen: false).password =
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
