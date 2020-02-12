import 'package:flutter/material.dart';

import '../widget/bottom_navigator.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wyly')),
      body: Center(child: Text('Camera')),
      bottomNavigationBar: BottomNavigator(2),
    );
  }
}
