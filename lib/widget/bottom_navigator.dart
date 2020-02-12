import 'package:flutter/material.dart';

class BottomNavigator extends StatelessWidget {
  BottomNavigator(this._index);
  final int _index;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          title: Text('Home'),
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          title: Text('Sample'),
          icon: Icon(Icons.watch),
        ),
        BottomNavigationBarItem(
          title: Text('Camera'),
          icon: Icon(Icons.camera),
        ),
      ],
      onTap: (int value) {
        switch (value) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/sample');
            break;
          case 2:
            Navigator.pushNamed(context, '/camera');
        }
      },
    );
  }
}
