import 'package:fantastic_note/services/auth/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late BaseAuthentication _authentication;
  final _formKeyLogin = GlobalKey<FormState>();
  late TextField _emailField;
  late TextField _passwordField = TextField();
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _authentication = Authentication();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailField = TextField(
      controller: _emailController,
    );
  }

  VoidCallback onBackPressed = () async {};

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Modular.to.navigate('/welcome');
        return true;
      },
      child: Scaffold(
          body: Form(
        key: _formKeyLogin,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 70.0, bottom: 10.0, left: 10.0, right: 10.0),
                  child: Text(
                    "Sign In",
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      decoration: TextDecoration.none,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: "OpenSans",
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
