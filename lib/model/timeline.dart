import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/post.dart';

class Timeline {
  final String documentId;
  final DateTime createdAt;
  final String type;
  final DocumentReference postRef;

  Timeline.fromFirestoreData(DocumentSnapshot doc)
      : this.documentId = doc.documentID,
        this.createdAt = (doc.data['createdAt'] as Timestamp).toDate(),
        this.type = doc.data['type'] as String,
        this.postRef = doc.data['post'] as DocumentReference;

  Future<Post> getPost() async {
    final postDoc = await postRef.get();
    return Post.fromFirestoreData(postDoc);
  }
}
