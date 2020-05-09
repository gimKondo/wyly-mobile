import 'package:flutter/material.dart';

import '../widget/bottom_navigator.dart';
import '../service/timeline_service.dart';
import '../service/ui_service.dart';
import '../widget/timeline_list.dart';
import './search_result_screen.dart';

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

  Future<void> _onPressSearchButton(BuildContext context) async {
    showIndicator(context);
    try {
      final post = await TimelineService().createItem(context);
      await Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (context) => SearchResultScreen(post),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      showErrorDialog(context, "Fail to search.\n$e");
      return;
    }
  }
}
