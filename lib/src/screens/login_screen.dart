import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/';
  // static const String route = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Screen')),
      body: Center(
        child: RaisedButton(
          child: Text('Go to Register Screen'),
          onPressed: () {
            Navigator.pushNamed(context, RegisterScreen.route);
          },
        ),
      ),
    );
  }
}
