import 'package:flutter/material.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:flutter_running_app/shared/loading.dart';

class SignUp extends StatefulWidget {
  //const SignUp({super.key});

  final Function toggleAuthenticationForms;
  const SignUp({super.key, required this.toggleAuthenticationForms});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color(0xFFFFCA1C),
            appBar: AppBar(
                backgroundColor: const Color(0xFF393939),
                elevation: 0.0,
                title: const Text('Sign up to start running'),
                foregroundColor: const Color(0xFFF2F2F2),
                actions: <Widget>[
                  TextButton.icon(
                      onPressed: () {
                        //Navigator.pop(context);
                        widget.toggleAuthenticationForms();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFF2F2F2),
                      ),
                      icon: const Icon(Icons.person),
                      label: const Text('Sign In'))
                ]),
            body: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: authenticationInputDecoration.copyWith(
                            hintText: 'Email'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (emailValue) {
                          setState(() => email = emailValue);
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: authenticationInputDecoration.copyWith(
                            hintText: 'Password'),
                        obscureText: true,
                        validator: (val) => val!.length < 3
                            ? 'Enter a password with at least 3 characters'
                            : null,
                        onChanged: (passwordValue) {
                          setState(() => password = passwordValue);
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            textStyle: MaterialStateProperty.all(
                                const TextStyle(color: Colors.white))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);

                            dynamic result = await _auth
                                .signUpWithEmailAndPassword(email, password);

                            if (result == null) {
                              setState(() {
                                error = 'Please enter a valid email';
                                loading = false;
                              });
                            }
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                )),
          );
  }
}
