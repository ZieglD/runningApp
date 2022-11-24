import 'package:flutter/material.dart';
import 'package:flutter_running_app/shared/constants.dart';

import '../../shared/button_widget.dart';

class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Widget countdownButton() {
    return ButtonWidget(
      text: 'Start',
      onClicked: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Center(child: countdownButton()),
    );
  }
}
