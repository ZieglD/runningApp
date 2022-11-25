import 'package:flutter/material.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: primary,
        child: const Center(
          child: SpinKitWave(
            color: secondary,
            size: 50.0,
          ),
        ));
  }
}
