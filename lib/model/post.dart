import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String name;
  String imagePath;
  DateTime createdAt;

  Post.fromMap(Map<String, dynamic> data) {
    name = data['name'] as String;
    imagePath = data['imagePath'] as String;
    createdAt = (data['createdAt'] as Timestamp).toDate();
  }
}
