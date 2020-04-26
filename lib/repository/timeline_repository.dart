import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../service/auth_service.dart';

import '../model/timeline.dart';

/// Repository of Timeline document
class TimelineRepository {
  /// get timelines stream
  Stream<List<Timeline>> list() {
    try {
      return Firestore.instance
          .collection('users')
          .document(AuthService().user.uid)
          .collection('timelines')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.documents
              .map((doc) => Timeline.fromFirestoreData(doc))
              .toList());
    } on Error catch (e) {
      debugPrint('Fail to get timeline stream. err:[$e]');
      return Stream.empty();
    }
  }
}
