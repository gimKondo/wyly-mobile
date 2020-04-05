import 'package:flutter/material.dart';

/// 処理待ちのインジケータを表示する
void showIndicator(BuildContext context) {
  showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) =>
        Center(child: CircularProgressIndicator()),
  );
}

/// システムエラーのポップアップを表示する
void showErrorDialog(BuildContext context, String message) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          autofocus: true,
          child: Text('OK'),
          onPressed: () {
            // ポップアップを閉じる
            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}
