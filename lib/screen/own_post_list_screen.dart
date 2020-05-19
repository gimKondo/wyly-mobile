import 'package:flutter/material.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './own_post_edit_screen.dart';
import '../repository/post_repository.dart';
import '../model/post.dart';
import '../service/storage_service.dart';
import '../widget/bottom_navigator.dart';
import '../widget/list_header_datetime.dart';

class OwnPostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wyly')),
      body: _PostList(),
      bottomNavigationBar: BottomNavigator(1),
    );
  }
}

class _PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<_PostList> {
  final _repository = PostRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _repository.fetchOwnList(),
        builder:
            // ignore: avoid_types_on_closure_parameters
            (context, AsyncSnapshot<List<Post>> timelineSnapshot) {
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

  Widget _buildBody(AsyncSnapshot<List<Post>> snapshot) {
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
            final post = snapshot.data[index];
            return InfiniteListItem(
              headerAlignment: HeaderAlignment.centerLeft,
              headerStateBuilder: (context, state) {
                return _buildListItemHeader(context, state, post);
              },
              contentBuilder: (context) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: post.isPublic
                      ? Theme.of(context).cardColor
                      : Theme.of(context).disabledColor,
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
                child: _buildPostItem(post),
              ),
              minOffsetProvider: (state) => 80,
            );
          },
        );
    }
  }

  Widget _buildListItemHeader(
      BuildContext context, StickyState state, Post post) {
    return InkWell(
      onTap: () => _onTapPostItem(post),
      child: ListHeaderDatetime(
        datetime: post.createdAt,
        position: state.position,
      ),
    );
  }

  Widget _buildPostItem(Post post) {
    return InkWell(
      onTap: () => _onTapPostItem(post),
      child: ListTile(
        title: Row(children: _buildPostTitle(post)),
        subtitle: _buildPostBody(post),
        trailing: Container(width: 60, child: _buildPublishButton(post)),
      ),
    );
  }

  List<Widget> _buildPostTitle(Post post) {
    if (post.isPublic) {
      return <Widget>[Text(post.name)];
    }
    return <Widget>[
      Icon(Icons.lock),
      Text(post.name),
    ];
  }

  Widget _buildPostBody(Post post) {
    return FutureBuilder<String>(
        future: StorageService().getDownloadURL(post.imagePath),
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

  Widget _buildPublishButton(Post post) {
    if (post.isPublic) {
      return Container();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          onPressed: () async =>
              await PostRepository().publish(post.documentId),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          child: Text('公開'),
        ),
      ],
    );
  }

  Future<void> _onTapPostItem(Post post) async {
    await Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (context) => OwnPostEditScreen(post),
      ),
    );
  }
}
