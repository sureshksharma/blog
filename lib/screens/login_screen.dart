import 'package:blogapp/screens/widgets/dialog_box.dart';
import 'package:blogapp/services/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.auth, required this.onSignedIn})
      : super(key: key);
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  DialogBox dialogBox = DialogBox();
  final _formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = '';
  String _password = '';

  bool validateAndSave() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.signIn(_email, _password);
        } else {
          String userId = await widget.auth.signUp(_email, _password);
        }
        widget.onSignedIn();
      } catch (e) {
        dialogBox.information(context, 'Authentication Error', e.toString());
      }
    }
  }

  void moveToLogin() {
    _formKey.currentState!.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  void moveToRegister() {
    _formKey.currentState!.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void logout() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Authentication'),
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButton(),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    return [
      logo(),
      const SizedBox(height: 10.0),
      TextFormField(
        validator: (value) {
          if (value!.isEmpty && value.contains('@')) {
            return 'Email not valid';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          _email = value!;
        },
        decoration:
            const InputDecoration(labelText: 'Email', hintText: 'Enter Email'),
      ),
      TextFormField(
        obscureText: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Password required';
          } else if (value.length < 6) {
            return 'Password lenght shold be greater than 6';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          _password = value!;
        },
        decoration: const InputDecoration(
          hintText: 'Enter Password',
          labelText: 'Password',
        ),
      ),
      const SizedBox(height: 10.0),
    ];
  }

  List<Widget> createButton() {
    if (_formType == FormType.login) {
      return [
        ElevatedButton(
          onPressed: validateAndSubmit,
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 20.0),
          ),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(10.0)),
          ),
        ),
        TextButton(
          onPressed: moveToRegister,
          child: const Text(
            "Don't have an account?",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ];
    } else {
      return [
        ElevatedButton(
          onPressed: validateAndSubmit,
          child: const Text(
            'Register',
            style: TextStyle(fontSize: 20.0),
          ),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(10.0)),
          ),
        ),
        TextButton(
          onPressed: moveToLogin,
          child: const Text(
            'Already have an account?',
            style: TextStyle(fontSize: 12.0),
          ),
        ),
      ];
    }
  }

  Widget logo() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 160,
        maxWidth: 160,
      ),
      child: FittedBox(
        child: Hero(
          tag: const Text('appLogo'),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 110.0,
            child: Image.asset('assets/blog-logo.png'),
          ),
        ),
      ),
    );
  }
}
