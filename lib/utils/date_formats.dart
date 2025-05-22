import 'package:intl/intl.dart';

String formatChatTimestamp(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final oneWeekAgo = today.subtract(const Duration(days: 7));

  final localDate = date.toLocal();
  final messageDate = DateTime(localDate.year, localDate.month, localDate.day);

  final timeString = formatTime(localDate);

  if (messageDate == today) {
    return 'Today, $timeString';
  }

  if (messageDate == yesterday) {
    return 'Yesterday, $timeString';
  }

  if (messageDate.isAfter(oneWeekAgo) && messageDate.isBefore(yesterday)) {
    final dayName = DateFormat('EEEE').format(localDate);
    return '$dayName, $timeString';
  }

  return '${formatDateWithSuffix(localDate)}, $timeString';
}

String formatChatDivider(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.day, now.month, now.year);
  final yesterday = today.subtract(const Duration(days: 1));
  final oneWeekAgo = today.subtract(const Duration(days: 7));

  final messageDate = DateTime(date.day, date.month, date.year);

  if (messageDate.isAtSameMomentAs(today)) {
    return 'Today';
  }

  if (messageDate.isAtSameMomentAs(yesterday)) {
    return 'Yesterday';
  }

  if (messageDate.isAfter(oneWeekAgo) && messageDate.isBefore(yesterday)) {
    final dayName = DateFormat('EEEE').format(date);
    return dayName;
  }

  return formatDateWithSuffix(date);
}

String formatDateWithSuffix(DateTime date) {
  String day = DateFormat.d().format(date);

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

  String month = DateFormat.MMM().format(date);

  return '$day$suffix $month';
}

String formatTime(DateTime time) {
  int hour = time.hour;
  int minute = time.minute;
  String period = hour < 12 ? 'AM' : 'PM';

  hour = hour % 12;
  hour = hour == 0 ? 12 : hour;

  return '$hour:${minute.toString().padLeft(2, '0')} $period';
}
