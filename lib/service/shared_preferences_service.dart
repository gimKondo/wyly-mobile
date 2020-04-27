import 'package:shared_preferences/shared_preferences.dart';

/// アプリが保持するログインIDを取得する
Future<String> getLoginID() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getString('email') ?? '';
}

/// デバイスにログインIDを保存する
Future<void> saveLoginID(String email) async {
  final pref = await SharedPreferences.getInstance();
  await pref.setBool('canKeepEmail', true);
  await pref.setString('email', email);
}

/// デバイスが保持するログインIDをクリアする
Future<void> clearLoginID() async {
  final pref = await SharedPreferences.getInstance();
  await pref.setBool('canKeepEmail', false);
  await pref.setString('email', '');
}
