import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../service/auth_service.dart';

class StorageService {
  Future<String> getDownloadURL(String path) async {
    final pathRef = FirebaseStorage.instance.ref().child(path);
    final dynamic url = await pathRef.getDownloadURL();
    debugPrint('URL:[$url]');
    return url.toString();
  }

  Future<StorageReference> uploadFile(
      String storagePath, String localFilePath) async {
    final user = await AuthService().getFirebaseUser();
    final ref =
        FirebaseStorage.instance.ref().child('${user.uid}/$storagePath');
    final uploadTask = ref.putFile(File(localFilePath));

    final result = await uploadTask.onComplete;
    if (result.error == null) return result.ref;
    if (result.error == StorageError.retryLimitExceeded) {
      debugPrint('Retry limit exceeded. error:[$result]');
      return null;
    }
    debugPrint('Unknown error. error:[$result]');
    throw Exception('faild to upload file');
  }
}
