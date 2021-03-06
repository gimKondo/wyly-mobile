import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';

import '../repository/timeline_repository.dart';
import '../service/storage_service.dart';
import '../model/timeline.dart';
import '../model/post.dart';
import '../screen/timeline_detail_screen.dart';
import '../widget/list_header_datetime.dart';

class TimelineList extends StatefulWidget {
  @override
  _TimelineListState createState() => _TimelineListState();
}

class _TimelineListState extends State<TimelineList> {
  final _repository = TimelineRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _repository.list(),
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
  }

  Widget _buildBody(AsyncSnapshot<List<Timeline>> snapshot) {
    if (snapshot.hasError) return Text('error');
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('none');
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      default:
        return InfiniteList(
          maxChildCount: snapshot.data.length,
          builder: (context, index) {
            final timeline = snapshot.data[index];
            return InfiniteListItem(
              headerAlignment: HeaderAlignment.centerLeft,
              headerStateBuilder: (context, state) =>
                  _buildListItemHeader(context, state, timeline),
              contentBuilder: (context) =>
                  _buildListItemContent(context, timeline),
              minOffsetProvider: (state) => 80,
            );
          },
        );
    }
  }

  Future<void> _onTapTimelineItem(Timeline timeline) async {
    await Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (context) => TimelineDetailScreen(timeline),
      ),
    );
  }

  Widget _buildListItemHeader(
      BuildContext context, StickyState state, Timeline timeline) {
    return InkWell(
      onTap: () => _onTapTimelineItem(timeline),
      child: ListHeaderDatetime(
        datetime: timeline.createdAt,
        position: state.position,
      ),
    );
  }

  Widget _buildListItemContent(BuildContext context, Timeline timeline) {
    return InkWell(
      onTap: () => _onTapTimelineItem(timeline),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
        ),
        padding: EdgeInsets.all(8),
        height: 160,
        width: 300,
        margin: EdgeInsets.only(
          left: 100,
          top: 5,
          bottom: 5,
          right: 0,
        ),
        child: _buildTimelineItem(timeline),
      ),
    );
  }

  Widget _buildTimelineItem(Timeline timeline) {
    return FutureBuilder<Post>(
        future: timeline.fetchPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final post = snapshot.data;
            return ListTile(
              title: Text(post.name),
              subtitle: _buildPostImage(post.imagePath),
            );
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
                  alignment: Alignment.centerLeft,
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
