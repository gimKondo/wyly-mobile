import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/auth_service.dart';

import '../model/timeline.dart';

/// Repository of Timeline document
class TimelineRepository {
  /// get timelines stream
  Stream<List<Timeline>> list() {
    return Firestore.instance
        .collection('users')
        .document(AuthService().user.uid)
        .collection('timelines')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => Timeline.fromFirestoreData(doc.data))
            .toList());
  }
}
