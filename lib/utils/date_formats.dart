import 'package:intl/intl.dart';

String formatDateWithSuffix(DateTime date) {
  // Format the day as an integer
  String day = DateFormat.d().format(date);

  // Determine the ordinal suffix
  String suffix;
  if (day.endsWith('1') && day != '11') {
    suffix = 'st';
  } else if (day.endsWith('2') && day != '12') {
    suffix = 'nd';
  } else if (day.endsWith('3') && day != '13') {
    suffix = 'rd';
  } else {
    suffix = 'th';
  }

  // Format the month as a short name
  String month = DateFormat.MMM().format(date);

  // Combine day with suffix and month
  return '$day$suffix $month';
}

String formatTime(DateTime time) {
  int hour = time.hour;
  int minute = time.minute;
  String period = hour < 12 ? 'AM' : 'PM';

  // Convert to 12-hour format
  hour = hour % 12;
  hour = hour == 0 ? 12 : hour;

  return '$hour:${minute.toString().padLeft(2, '0')} $period';
}
