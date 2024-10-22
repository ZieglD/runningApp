import 'package:flutter/material.dart';
import 'package:flutter_running_app/models/my_user.dart';
import 'package:flutter_running_app/screens/authenticate/authenticate.dart';
import 'package:flutter_running_app/screens/navigation/navigation.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    // return either home or authenticate widget
    if (user == null) {
      return const Authenticate();
    } else {
      return const Navigation();
    }
  }
}
