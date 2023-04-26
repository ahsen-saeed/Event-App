import 'package:event_app/extensions/primitive_extension.dart';

extension DateTimeExtension on DateTime {
  String get humanReadableDatetime {
    final dateDay = day;
    final dateMonth = month.monthName;
    return '$dateDay $dateMonth $year';
  }
}