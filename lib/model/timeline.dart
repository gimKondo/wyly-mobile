import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/post.dart';

class Timeline {
  final String documentId;
  final DateTime createdAt;
  final String type;
  final DocumentReference postRef;

  Timeline.fromFirestoreData(DocumentSnapshot doc)
      : documentId = doc.documentID,
        createdAt = (doc.data['createdAt'] as Timestamp).toDate(),
        type = doc.data['type'] as String,
        postRef = doc.data['post'] as DocumentReference;

  Future<Post> fetchPost() async {
    final postDoc = await postRef.get();
    return Post.fromFirestoreData(postDoc);
  }
}
