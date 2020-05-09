import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Post {
  final String documentId;
  final String name;
  final String imagePath;
  final DateTime createdAt;
  final bool isPublic;

  const Post({
    this.documentId,
    @required this.name,
    @required this.imagePath,
    @required this.createdAt,
    @required this.isPublic,
  });

  Post.fromFirestoreData(DocumentSnapshot doc)
      : this.documentId = doc.documentID,
        this.name = doc.data['name'] as String,
        this.imagePath = doc.data['imagePath'] as String,
        this.createdAt = (doc.data['createdAt'] as Timestamp).toDate(),
        this.isPublic = doc.data['isPublic'] as bool;

  Post.fromSearchResult(HttpsCallableResult result)
      : this.documentId = null,
        this.name = result.data['name'] as String,
        this.imagePath = result.data['imagePath'] as String,
        this.createdAt = (result.data['createdAt'] as Timestamp).toDate(),
        this.isPublic = true;

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
