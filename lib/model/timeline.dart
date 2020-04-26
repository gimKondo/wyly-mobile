import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/post.dart';

class Timeline {
  DateTime createdAt;
  DocumentReference postRef;

  Timeline.fromFirestoreData(Map<String, dynamic> data) {
    createdAt = (data['createdAt'] as Timestamp).toDate();
    postRef = data['post'] as DocumentReference;
  }

  Future<Post> getPost() async {
    final postDoc = await postRef.get();
    return Post.fromFirestoreData(postDoc.data);
  }
}
