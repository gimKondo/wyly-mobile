import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/post.dart';
import '../service/storage_service.dart';
import '../widget/bottom_navigator.dart';
import '../widget/standard_button.dart';

class SearchResultScreen extends StatelessWidget {
  final Post post;
  SearchResultScreen(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wyly')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.0),
          ),
          _buildHeadline(context, post.name),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
          ),
          _buildImage(context),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
          ),
          Container(
            width: 200,
            child: StandardButton(
              onTap: () async => await Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home', (route) => false),
              text: 'OK',
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigator(0),
    );
  }

  Widget _buildHeadline(BuildContext context, String text) {
    final defaultTextStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    );
    return Text(
      '「$text」を発見！',
      style: defaultTextStyle,
    );
  }

  Widget _buildImage(BuildContext context) {
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
