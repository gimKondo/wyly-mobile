import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pedantic/pedantic.dart';

import '../model/post.dart';
import '../repository/post_repository.dart';
import '../service/storage_service.dart';
import '../style/text_style.dart';
import '../widget/bottom_navigator.dart';

class OwnPostEditScreen extends StatelessWidget {
  final Post post;

  OwnPostEditScreen(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Wyly')),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigator(1),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildImage(post),
        _ChangeForm(post: post),
      ],
    );
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

class _ChangeForm extends StatefulWidget {
  final Post post;

  _ChangeForm({this.post});

  @override
  _ChangeFormState createState() => _ChangeFormState();
}

class _ChangeFormState extends State<_ChangeForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FractionallySizedBox(
        alignment: Alignment.center,
        widthFactor: 0.8,
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: widget.post.name,
              enabled: true,
              maxLength: 30,
              maxLengthEnforced: false,
              style: plainTextStyle,
              maxLines: 1,
              validator: (value) {
                if (value.isEmpty) {
                  return '種名を入力してください';
                }
                return null;
              },
              onSaved: (value) => _name = value,
            ),
            RaisedButton(
              onPressed: _submit,
              child: Text('Update'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await PostRepository().rename(widget.post.documentId, _name);
      unawaited(Fluttertoast.showToast(
        msg: 'Updated name',
        gravity: ToastGravity.CENTER,
      ));
      debugPrint('updated name:[$_name]');
    }
  }
}
