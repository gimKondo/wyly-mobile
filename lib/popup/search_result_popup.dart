import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/post.dart';
import '../service/storage_service.dart';
import '../style/text_style.dart';

Future<void> showSearchResultPopup(BuildContext context, Post post) async {
  await showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: _buildHeadline(context, post.name),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: _buildImage(context, post),
          ),
        ],
      );
    },
  );
}

Widget _buildHeadline(BuildContext context, String text) {
  return Text(
    '「$text」を発見！',
    style: headlineTextStyle,
  );
}

Widget _buildImage(BuildContext context, Post post) {
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
