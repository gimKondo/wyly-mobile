import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/profile.dart';
import '../repository/profile_repository.dart';

class AppBarTitle extends StatefulWidget {
  @override
  _AppBarTitleState createState() => _AppBarTitleState();
}

class _AppBarTitleState extends State<AppBarTitle> {
  final _repository = ProfileRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _repository.getMe(),
        builder:
            // ignore: avoid_types_on_closure_parameters
            (context, AsyncSnapshot<Profile> profileSnapshot) {
          if (profileSnapshot.hasError) return Text('Wyly');
          switch (profileSnapshot.connectionState) {
            case ConnectionState.none:
              return Text('Wyly');
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return Row(
                children: [
                  Container(
                    width: 40,
                    child: _buildIcon(context, profileSnapshot.data.photoURL),
                  ),
                  Text("${profileSnapshot.data.displayName}'s Post"),
                ],
              );
          }
        });
  }

  Widget _buildIcon(BuildContext context, String imageUrl) {
    debugPrint('--------------------- $imageUrl');
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: 30,
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
  }
}
