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
}
