import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService {
  Future<String> getDownloadURL(String path) async {
    final pathRef = FirebaseStorage.instance.ref().child(path);
    final dynamic url = await pathRef.getDownloadURL();
    debugPrint('URL:[$url]');
    return url.toString();
  }
}
