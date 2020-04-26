import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String name;
  final String imagePath;
  final DateTime createdAt;
  final bool isPublic;

  const Post({
    @required this.name,
    @required this.imagePath,
    @required this.createdAt,
    this.isPublic = true,
  });

  Post.fromFirestoreData(Map<String, dynamic> data)
      : this.name = data['name'] as String,
        this.imagePath = data['imagePath'] as String,
        this.createdAt = (data['createdAt'] as Timestamp).toDate(),
        this.isPublic = data['isPublic'] as bool;

  Map<String, dynamic> toMap() {
    // ignore: implicit_dynamic_map_literal
    return {
      'name': name,
      'imagePath': imagePath,
      'createdAt': createdAt,
      'isPublic': isPublic,
    };
  }
}
