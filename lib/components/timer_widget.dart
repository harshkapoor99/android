import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:guftagu_mobile/utils/context_less_nav.dart';

class TimerWidget extends StatefulWidget {
  final bool showHour;
  final DateTime startTime;

  const TimerWidget({
    super.key,
    this.showHour = false,
    required this.startTime,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  late DateTime _startTime; // Renamed for clarity: marks when the timer started

  @override
  void initState() {
    super.initState();
    _startTime =
        widget.startTime; // Initialize to the current time when mounted
    if (kReleaseMode) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Always cancel the timer to prevent memory leaks
    super.dispose();
  }

  void _startTimer() {
    // Timer.periodic calls the callback every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // setState triggers a rebuild, updating the displayed time
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the elapsed time since _startTime
    Duration elapsedTime = DateTime.now().difference(_startTime);

    // Calculate hours, minutes, and seconds from the elapsed time
    // Using remainder to ensure values wrap around (e.g., minutes don't go above 59)
    int hours =
        elapsedTime
            .inHours; // No need for remainder(24) here, as inHours gives total hours
    String hoursString = hours.toString().padLeft(2, '0');
    String minutes = elapsedTime.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String seconds = elapsedTime.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    // Determine the format based on showHour and whether hours are present
    String timeDisplay;
    if (widget.showHour || hours > 0) {
      timeDisplay = '$hoursString:$minutes:$seconds';
    } else {
      timeDisplay = '$minutes:$seconds';
    }

    return Text(
      timeDisplay,
      // Using a default TextStyle for demonstration.
      // You can replace this with your app's specific text style.
      style: context.appTextStyle.textSmall,
    );
  }
}
