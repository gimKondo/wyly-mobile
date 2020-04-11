import 'package:flutter/material.dart';

import '../service/auth_service.dart';

class BottomNavigator extends StatelessWidget {
  BottomNavigator(this._index);
  final int _index;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      type: BottomNavigationBarType.fixed,
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
        BottomNavigationBarItem(
          title: Text('Logout'),
          icon: Icon(Icons.power_settings_new),
        ),
      ],
      onTap: (value) {
        switch (value) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
            break;
          case 1:
            _pushNamedAndRemoveUntilHome(context, '/sample');
            break;
          case 2:
            _pushNamedAndRemoveUntilHome(context, '/camera');
            break;
          case 3:
            _signOut(context);
            break;
        }
      },
    );
  }

  void _pushNamedAndRemoveUntilHome(BuildContext context, String name) {
    Navigator.pushNamedAndRemoveUntil(
        context, name, ModalRoute.withName('/home'));
  }

  void _signOut(BuildContext context) {
    AuthService().singOut();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }
}
