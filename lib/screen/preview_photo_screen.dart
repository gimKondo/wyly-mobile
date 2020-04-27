import 'dart:io';

import 'package:flutter/material.dart';

import '../service/storage_service.dart';
import '../model/post.dart';
import '../repository/post_repository.dart';

// Preview phot and input basic data
class PreviewPhotoScreen extends StatelessWidget {
  final String fileName;
  final String localFilePath;

  const PreviewPhotoScreen({Key key, this.fileName, this.localFilePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(localFilePath)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload),
        // Provide an onPressed callback.
        onPressed: () async {
          // uplaod iamge
          // TODO: error handling
          final storageRef = await StorageService()
              .uploadFile('posts/$fileName', localFilePath);
          final storagePath = await storageRef.getPath();

          // create Post document
          final post = Post(
            name: 'Unknown',
            imagePath: storagePath,
            createdAt: DateTime.now(),
            isPublic: false,
          );
          await PostRepository().create(post);

          await Navigator.pushNamedAndRemoveUntil(
              context, '/camera', (_) => false);
        },
      ),
    );
  }
}
