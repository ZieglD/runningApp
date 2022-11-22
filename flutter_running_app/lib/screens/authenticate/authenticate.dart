import 'package:flutter/material.dart';
import 'package:flutter_running_app/screens/authenticate/sign_in.dart';
import 'package:flutter_running_app/screens/authenticate/sign_up.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  toggleAuthenticationForms() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: const SignIn(),
    // );
    if (showSignIn) {
      return SignIn(toggleAuthenticationForms: toggleAuthenticationForms);
    } else {
      return SignUp(toggleAuthenticationForms: toggleAuthenticationForms);
    }
  }
}
