import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/auth_service.dart';

/// Repository of Timeline document
class TimelineRepository {
  /// get timelines stream
  Future<Stream<List<Map>>> list() async {
    final user = await AuthService().getFirebaseUser();
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('timelines')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.documents.map((doc) => doc.data).toList());
  }
}
