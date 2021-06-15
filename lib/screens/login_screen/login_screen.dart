import 'dart:developer';

import 'package:fantastic_note/services/auth/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late BaseAuthentication _authentication;
  final _formKeyLogin = GlobalKey<FormState>();
  late TextFormField _emailField;
  late TextField _passwordField = TextField();
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _authentication = Authentication();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailField = TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
          icon: Icon(Icons.email),
          labelText: 'Email',
          hintText: 'Enter your email address'),
      cursorColor: Colors.deepPurpleAccent,
    );
    _passwordField = TextField(
      controller: _passwordController,
      decoration: InputDecoration(
          icon: Icon(Icons.password),
          labelText: 'Password',
          hintText: 'Enter password'),
    );
  }

  Future _userLogin() async {
    if (_formKeyLogin.currentState!.validate()) {
      _formKeyLogin.currentState!.save();

      Future<User?> firebaseUser = _authentication.signIn(
          _emailController.text, _passwordController.text);

      log('email: $_emailController.text , password: $_passwordController.text');

      firebaseUser
          .then((user) => {
                user!.getIdToken().then((value) {
                  print('Login Success');
                  Modular.to.navigate('/home');
                })
              })
          .catchError((e) {
        print('Sign U in Failed $e');
      }).catchError((e) {
        print('Sign in Failed $e');
      });
    }
  }

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
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
                  child: _emailField,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
                  child: _passwordField,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                  child: MaterialButton(
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          backgroundColor: Colors.deepPurpleAccent),
                    ),
                    onPressed: _userLogin,
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
