import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String name;
  final String imagePath;
  final DateTime createdAt;

  const Post({this.name, this.imagePath, this.createdAt});

  Post.fromMap(Map<String, dynamic> data)
      : this.name = data['name'] as String,
        this.imagePath = data['imagePath'] as String,
        this.createdAt = (data['createdAt'] as Timestamp).toDate();

  Map<String, dynamic> toMap() {
    // ignore: implicit_dynamic_map_literal
    return {'name': name, 'imagePath': imagePath, 'createdAt': createdAt};
  }
}
