import 'dart:developer';

import 'package:fantastic_note/components/already_have_an_account_acheck.dart';
import 'package:fantastic_note/components/rounded_button.dart';
import 'package:fantastic_note/components/rounded_input_field.dart';
import 'package:fantastic_note/components/rounded_password_field.dart';
import 'package:fantastic_note/screens/login_screen/components/background.dart';
import 'package:fantastic_note/screens/signup_screen/signup_screen.dart';
import 'package:fantastic_note/services/auth/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late BaseAuthentication _authentication;
  final _formKeyLogin = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _authentication = Authentication();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future _userLogin() async {
    try {
      // if (_formKeyLogin.currentState!.validate()) {
      // _formKeyLogin.currentState!.save();

      UserCredential userCredential = await _authentication.signIn(
          _emailController.text, _passwordController.text);
      log('email: $_emailController.text , password: $_passwordController.text');
      print(userCredential.user);

      _resetFormFields();
      Modular.to.navigate('/home');
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            message: "No user found for that email.",
            backgroundColor: Colors.amberAccent,
            textStyle: TextStyle(color: Colors.black),
          ),
        );
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            message: "Wrong password provided for that user.",
            backgroundColor: Colors.redAccent,
          ),
        );
        log('Wrong password provided for that user.');
      }
    } catch (e) {
      log('login failed: $e');
    }
  }

  _resetFormFields() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your Email",
                controller: _emailController,
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                controller: _passwordController,
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "LOGIN",
                press: () {
                  _userLogin();
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
