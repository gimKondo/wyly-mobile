import 'package:flutter/material.dart';

import '../widget/bottom_navigator.dart';
import '../service/timeline_service.dart';
import '../widget/timeline_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wyly')),
      body: TimelineList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _onPressSearchButton(context),
        tooltip: 'Search',
        child: Icon(Icons.directions_walk),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigator(0),
    );
  }

  void _onPressSearchButton(BuildContext context) {
    TimelineService().createItem(context);
  }
}
