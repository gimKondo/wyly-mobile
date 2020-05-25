import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String documentId;
  final String displayName;
  final String photoURL;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    this.documentId,
    @required this.displayName,
    @required this.photoURL,
    @required this.createdAt,
    @required this.updatedAt,
  });

  Profile.fromFirestoreData(DocumentSnapshot doc)
      : documentId = doc.documentID,
        displayName = doc.data['displayName'] as String,
        photoURL = doc.data['photoURL'] as String,
        createdAt = (doc.data['createdAt'] as Timestamp).toDate(),
        updatedAt = (doc.data['updatedAt'] as Timestamp).toDate();

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
