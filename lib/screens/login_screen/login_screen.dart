// import 'package:ctse_flutter/services/auth/authentication.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // BaseAuthentication _authentication;

  @override
  void initState() {
    super.initState();

    // _authentication = Authentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Text("Login Page Test"),
    );
  }
}
