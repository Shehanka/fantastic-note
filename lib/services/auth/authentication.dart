import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthentication {
  Future<User?> signIn(String email, String password);

  Future<String?> signUp(
      String email, String password, String userType, Object userObject);

  User? getCurrentUser();

  Future<void> signOut();

  Future<String> forgotPasswordEmail(String email);
}

class Authentication implements BaseAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> forgotPasswordEmail(String email) {
    throw UnimplementedError();
  }

  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<User?> signIn(String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String?> signUp(
      String email, String password, String userType, Object userObject) async {
    return (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user!
        .uid;
  }
}
