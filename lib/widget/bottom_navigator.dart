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
            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            break;
          case 1:
            _pushNamedAndRemoveUntilHome(context, '/sample');
            break;
          case 2:
            _pushNamedAndRemoveUntilHome(context, '/camera');
        }
      },
    );
  }

  void _pushNamedAndRemoveUntilHome(BuildContext context, String name) {
    Navigator.pushNamedAndRemoveUntil(context, name, ModalRoute.withName("/"));
  }
}
