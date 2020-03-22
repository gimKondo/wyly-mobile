import 'package:flutter/material.dart';

import '../widget/bottom_navigator.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wyly')),
      body: Center(child: Text('Photo')),
      bottomNavigationBar: BottomNavigator(0),
    );
  }
}
