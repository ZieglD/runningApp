import 'package:flutter/material.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:flutter_running_app/shared/loading.dart';

class SignIn extends StatefulWidget {
  //const SignIn({super.key});

  final Function toggleAuthenticationForms;
  const SignIn({super.key, required this.toggleAuthenticationForms});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
                title: const Text('Sign in to start running'),
                foregroundColor: const Color(0xFFF2F2F2),
                actions: <Widget>[
                  TextButton.icon(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const SignUp())
                        // );
                        //Navigator.of(context).push(_createRoute());
                        widget.toggleAuthenticationForms();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFF2F2F2),
                      ),
                      icon: const Icon(Icons.person),
                      label: const Text('Sign Up'))
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
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error =
                                    'Could not sign in with given credentials';
                                loading = false;
                              });
                            }
                          }
                        },
                        child: const Text('Sign In'),
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

//   Route _createRoute() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => const SignUp(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(-1.0, 0.0);
//       const end = Offset.zero;
//       const curve = Curves.ease;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }

}