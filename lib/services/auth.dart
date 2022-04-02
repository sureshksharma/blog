import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplementation {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> getCurrentUser();
  Future<void> singOut();
}

class Auth implements AuthImplementation {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signIn(String email, String password) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user!.uid;
  }

  @override
  Future<String> signUp(String email, String password) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.user!.uid;
  }

  @override
  Future<String> getCurrentUser() async {
    var user = _firebaseAuth.currentUser;
    if (user != null) return user.uid;
    return 'null';
  }

  @override
  Future<void> singOut() async {
    _firebaseAuth.signOut();
  }
}
