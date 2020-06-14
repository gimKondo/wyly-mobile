import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

import 'package:wyly/app_root.dart';
import 'package:wyly/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, //縦固定
  ]);
  final cameras = await availableCameras();

  runApp(Config(
    AppRoot(cameras),
    isDebug: true,
    cloudFunctionRegion: 'asia-northeast1',
  ));
}
