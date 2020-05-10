import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/post.dart';
import '../model/timeline.dart';
import '../service/storage_service.dart';
import '../widget/bottom_navigator.dart';

class TimelineDetailScreen extends StatelessWidget {
  final Timeline timeline;
  TimelineDetailScreen(this.timeline);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wyly')),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigator(0),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<Post>(
        future: timeline.fetchPost(),
        builder: (context, snapshotPost) {
          if (!snapshotPost.hasData) {
            return Text('Now loading...');
          }
          return _buildImage(snapshotPost.data);
        });
  }

  Widget _buildImage(Post post) {
    return FutureBuilder<String>(
        future: StorageService().getDownloadURL(post.imagePath),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return CachedNetworkImage(
            imageUrl: snapshot.data,
            imageBuilder: (context, imageProvider) => Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
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
