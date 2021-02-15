import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/services/auth_api_service.dart';

import '../models/forms.dart';
import '../utils/validators.dart';
import 'meetup_home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';

  final authApi = AuthApiService();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();

  LoginFormData _loginData = LoginFormData();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // final String password = _passwordController.text;
      // final String email = _emailController.text;
      // // final String email = _emailKey.currentState.value;

      form.save(); // Triggers onSaved functions

      widget.authApi
          .login(_loginData)
          .then((data) => print(data))
          .catchError((err) {
        print(err);
      });

      print(
          'Email is ${_loginData.email} and password is ${_loginData.password}');
    } else {
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          // HERE is important
          autovalidateMode: _autoValidateMode,
          // Column u ListView'e değiştirdik çünkü scrollable olsun ve
          // Landscape mode'da patlamasın diye
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: Text(
                  'Login And Explore',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                key: _emailKey,
                // controller: _emailController,
                onSaved: (value) => _loginData.email = value,
                style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(hintText: 'Email Address'),
                validator: composeValidators(
                  'email',
                  [
                    requiredValidator,
                    minLengthValidator,
                    emailValidator,
                  ],
                ),
              ),
              TextFormField(
                key: _passwordKey,
                // controller: _passwordController,
                onSaved: (value) => _loginData.password = value,
                style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(hintText: 'Password'),
                validator: composeValidators(
                  'password',
                  [
                    requiredValidator,
                    minLengthValidator,
                  ],
                ),
              ),
              _buildLinks(),
              Container(
                alignment: Alignment(-1.0, 0.0),
                margin: EdgeInsets.only(top: 10.0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  child: const Text('Submit'),
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinks() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, RegisterScreen.route),
            child: Text(
              'Not registered yet? Register Now!',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, MeetupHomeScreen.route),
            child: Text(
              'Continue to Home Screen',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}