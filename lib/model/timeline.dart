import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Timeline {
  DateTime createdAt;
  DocumentReference post;

  Timeline.fromMap(Map<String, dynamic> data) {
    createdAt = (data['createdAt'] as Timestamp).toDate();
    post = data['post'] as DocumentReference;
  }

  String get createdAtAsDay => DateFormat('yyyy/MM/dd').format(createdAt);
  String get createdAtAsDateTime =>
      DateFormat('yyyy/MM/dd HH:mm').format(createdAt);
}
