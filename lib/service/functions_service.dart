import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:wyly/config.dart';

/// Service for Firebase Functions
class FunctionsService {
  CloudFunctions _cloudFunctions;

  FunctionsService(BuildContext context) {
    _cloudFunctions = CloudFunctions(
      app: FirebaseApp.instance,
      region: Config.of(context).cloudFunctionRegion,
    );
  }

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
