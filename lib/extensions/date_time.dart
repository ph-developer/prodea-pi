import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toDateStr() {
    return DateFormat('d/M/y').format(this);
  }
}
