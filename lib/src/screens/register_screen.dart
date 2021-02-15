import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String route = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register Screen')),
      body: Center(
        child: RaisedButton(
          child: Text('Go to Login Screen'),
          onPressed: () => Navigator.pushNamed(context, LoginScreen.route),
        ),
      ),
    );
  }
}
