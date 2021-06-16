import 'dart:developer';

import 'package:fantastic_note/components/already_have_an_account_acheck.dart';
import 'package:fantastic_note/components/rounded_button.dart';
import 'package:fantastic_note/components/rounded_input_field.dart';
import 'package:fantastic_note/components/rounded_password_field.dart';
import 'package:fantastic_note/models/user.dart' as UserModel;
import 'package:fantastic_note/screens/signup/components/background.dart';
import 'package:fantastic_note/screens/signup/components/or_divider.dart';
import 'package:fantastic_note/screens/signup/components/social_icon.dart';
import 'package:fantastic_note/services/auth/authentication.dart';
import 'package:fantastic_note/services/custom/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignUpScreen extends StatefulWidget {
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final BaseAuthentication _authentication = Authentication();
  final UserService _userService = UserService();
  final _formKeySignUp = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  _signUpAction() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;

    try {
      log("Signuping....");
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      log("Signup Success");
      String uid = userCredential.user!.uid;
      log("message $uid");

      _userService.create(UserModel.User(email, firstName, lastName, uid));
      Modular.to.navigate('/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            message: "The password provided is too weak.",
            backgroundColor: Colors.amberAccent,
            textStyle: TextStyle(color: Colors.black),
          ),
        );
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            message: "The account already exists for that email.",
            backgroundColor: Colors.redAccent,
          ),
        );
        print('The account already exists for that email.');
      }
    } catch (e) {
      print("Unable to sign up $e");
    }
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
                "SIGNUP",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              // SvgPicture.asset(
              //   "assets/icons/signup.svg",
              //   height: size.height * 0.35,
              // ),
              RoundedInputField(
                  hintText: "First Name",
                  controller: _lastNameController,
                  onChanged: (value) {}),
              RoundedInputField(
                  hintText: "First Name",
                  controller: _firstNameController,
                  onChanged: (value) {}),
              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {},
                controller: _emailController,
              ),
              RoundedPasswordField(
                controller: _passwordController,
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "SIGNUP",
                press: () => _signUpAction(),
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Modular.to.navigate('/home');
                },
              ),
              OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/twitter.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
