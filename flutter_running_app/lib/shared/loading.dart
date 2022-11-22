import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFCA1C),
      child: const Center(
        child: SpinKitWave(
          color: Color(0xFF393939),
          size: 50.0,),
      )
    );
  }
}