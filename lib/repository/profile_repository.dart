import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../service/auth_service.dart';

import '../model/profile.dart';

/// Repository of Profile document
class ProfileRepository {
  /// get timelines stream
  Stream<Profile> getMe() {
    try {
      return Firestore.instance
          .collection('profiles')
          .document(AuthService().user.uid)
          .snapshots()
          .map((snapshot) => Profile.fromFirestoreData(snapshot));
    } on Error catch (e) {
      debugPrint('Fail to get timeline stream. err:[$e]');
      return Stream.empty();
    }
  }
}
