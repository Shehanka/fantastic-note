// import 'package:ctse_flutter/services/auth/authentication.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  // BaseAuthentication _authentication;
  // User _firebaseUser;

  @override
  initState(){
    super.initState();



    // _authentication = Authentication();
    // _firebaseUser = FirebaseAuth.instance.currentUser;
    //
    // _authentication.getCurrentUser();
    Modular.to.navigate('/welcome');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.deepPurple,
              radius: 65.0,
              child: Icon(
                Icons.school,
                color: Colors.white70,
                size: 70.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Text(
              'Fantastic Notes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 70.0),
            ),
            CircularProgressIndicator(),
          ],
        )
      ],
    ));
  }
}
