import 'package:flutter/material.dart';

/// アプリケーション設定
class Config extends InheritedWidget {
  /// アプリケーションで使用する定数の定義
  static Config of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  Config(
    Widget child, {
    this.cloudFunctionRegion,
    this.isDebug,
  }) : super(child: child);

  final String appTitle = 'Wyly';
  final String cloudFunctionRegion;
  final bool isDebug;

  @override
  bool updateShouldNotify(Config oldWidget) => false;
}
