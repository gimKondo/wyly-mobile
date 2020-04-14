import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// Firebase Functions 接続のための共通クラス
class FunctionsService {
  CloudFunctions _cloudFunctions;

  /// コンストラクタ
  FunctionsService(BuildContext context) {
    _cloudFunctions = CloudFunctions(
      app: FirebaseApp.instance,
      region: 'asia-northeast1', // TODO: set region by config
    );
  }

  /// Function 呼び出し
  Future<HttpsCallableResult> callFunction(
    String functionName,
    dynamic params,
  ) async {
    final callable = _cloudFunctions.getHttpsCallable(
      functionName: functionName,
    );
    return await callable.call(params);
  }
}
