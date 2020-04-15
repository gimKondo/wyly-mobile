import 'package:flutter/material.dart';

import '../repository/timeline_repository.dart';
import '../model/timeline.dart';
import '../model/post.dart';
import '../extension/datetime_ext.dart';

class TimelineList extends StatefulWidget {
  @override
  _TimelineListState createState() => _TimelineListState();
}

class _TimelineListState extends State<TimelineList> {
  final _repository = TimelineRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _repository.list(),
      builder:
          // ignore: avoid_types_on_closure_parameters
          (context, AsyncSnapshot<Stream<List<Timeline>>> snapshot) {
        if (snapshot.hasData) {
          return StreamBuilder(
              stream: snapshot.data,
              builder:
                  // ignore: avoid_types_on_closure_parameters
                  (context, AsyncSnapshot<List<Timeline>> timelineSnapshot) {
                if (timelineSnapshot.hasError) return Text('error');
                switch (timelineSnapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    return _buildBody(timelineSnapshot);
                }
              });
        } else {
          return Text('error');
        }
      },
    );
  }

  Widget _buildBody(AsyncSnapshot<List<Timeline>> snapshot) {
    if (snapshot.hasError) return Text('error');
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('none');
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      default:
        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, position) {
              final timeline = snapshot.data[position];
              return _buildTimeline(timeline);
            });
    }
  }

  Widget _buildTimeline(Timeline timeline) {
    return FutureBuilder<Post>(
        future: timeline.getPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final post = snapshot.data;
            return Card(
                child: ListTile(
                    title: Text(post.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(timeline.createdAt.toDateTimeString()),
                        Text(post.imagePath),
                      ],
                    )));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
