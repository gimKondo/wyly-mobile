import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../repository/timeline_repository.dart';
import '../service/storage_service.dart';
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
              return _buildTimelineItem(timeline);
            });
    }
  }

  Widget _buildTimelineItem(Timeline timeline) {
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
                        _buildPostImage(post.imagePath),
                      ],
                    )));
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildPostImage(String imagePath) {
    return FutureBuilder<String>(
        future: StorageService().getDownloadURL(imagePath),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return CachedNetworkImage(
            imageUrl: snapshot.data,
            imageBuilder: (context, imageProvider) => Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, dynamic error) => Icon(Icons.error),
          );
        });
  }
}
