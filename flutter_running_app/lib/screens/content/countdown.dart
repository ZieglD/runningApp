import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_running_app/screens/content/activity.dart';
import 'package:flutter_running_app/shared/constants.dart';

import '../../shared/button_widget.dart';

class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  static const maxSeconds = 5;
  int seconds = maxSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        if (seconds > 0) {
          setState(() => seconds--);
        } else {
          stopTimer();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Activity()));
        }
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  Widget countdownButton() {
    return ButtonWidget(
      text: 'Start',
      onClicked: () {
        startTimer();
      },
    );
  }

  Widget countdownText() {
    return Text(
      '$seconds',
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 80),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          countdownText(),
        ],
      )),
    );
  }
}
