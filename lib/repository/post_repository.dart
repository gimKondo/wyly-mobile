import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/post.dart';
import '../service/auth_service.dart';

/// Repository of Post document
class PostRepository {
  /// create Post document
  Future<DocumentSnapshot> create(Post post) async {
    final user = await AuthService().getFirebaseUser();
    final doc = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('posts')
        .add(post.toMap());
    return doc.get();
  }

  /// get own posts stream
  Future<Stream<List<Post>>> list() async {
    final user = await AuthService().getFirebaseUser();
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => Post.fromFirestoreData(doc.data))
            .toList());
  }
}
