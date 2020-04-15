import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String toDateString() => DateFormat('yyyy/MM/dd').format(this);
  String toDateTimeString() => DateFormat('yyyy/MM/dd HH:mm').format(this);
}
