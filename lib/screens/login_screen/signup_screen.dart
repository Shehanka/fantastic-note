import 'package:fantastic_note/services/auth/authentication.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final _formKeySignUp = GlobalKey<FormState>();
  late TextFormField _firstNameField;
  late TextFormField _lastNameField;
  late TextFormField _emailField;
  late TextFormField _passwordField;
  late TextFormField _passwordReField;
  final BaseAuthentication _authentication = Authentication();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordReController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _firstNameField = TextFormField(
      controller: _firstNameController,
    );
    _lastNameField = TextFormField(
      controller: _lastNameController,
    );
    // _emailField
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topLeft,
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 70.0, bottom: 10.0, left: 10.0, right: 10.0),
                  child: Text(
                    "Create new account",
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
