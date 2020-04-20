import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import '../widget/bottom_navigator.dart';
import '../service/storage_service.dart';
import '../model/post.dart';
import '../repository/post_repository.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wyly')),
      bottomNavigationBar: BottomNavigator(2),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        backgroundColor: Theme.of(context).primaryColor,
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final fileName = DateTime.now().millisecondsSinceEpoch.toString();
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '$fileName.jpg',
            );
            debugPrint('local file path. path:[$path]');

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            await Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (context) => DisplayPictureScreen(
                  fileName: fileName,
                  localFilePath: path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String fileName;
  final String localFilePath;

  const DisplayPictureScreen({Key key, this.fileName, this.localFilePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(localFilePath)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload),
        backgroundColor: Theme.of(context).primaryColor,
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
          );
          await PostRepository().create(post);

          await Navigator.pushNamedAndRemoveUntil(
              context, '/camera', (_) => false);
        },
      ),
    );
  }
}
