import 'package:blogapp/screens/home_screen.dart';
import 'package:blogapp/screens/login_screen.dart';
import 'package:blogapp/services/auth.dart';
import 'package:flutter/material.dart';

class MappingPage extends StatefulWidget {
  const MappingPage({Key? key, required this.auth}) : super(key: key);
  final AuthImplementation auth;

  @override
  State<MappingPage> createState() => _MappingPageState();
}

enum AuthStates { notSignedIn, signedIn }

class _MappingPageState extends State<MappingPage> {
  AuthStates authStates = AuthStates.notSignedIn;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.auth.getCurrentUser().then((userId) {
      setState(() {
        authStates =
            userId == 'null' ? AuthStates.notSignedIn : AuthStates.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStates = AuthStates.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStates = AuthStates.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStates) {
      case AuthStates.notSignedIn:
        return LoginPage(auth: widget.auth, onSignedIn: _signedIn);
      case AuthStates.signedIn:
        return HomePage(auth: widget.auth, onSignedOut: _signedOut);
    }
  }
}
