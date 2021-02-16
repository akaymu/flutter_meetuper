import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/services/auth_api_service.dart';

import '../models/forms.dart';
import '../utils/validators.dart';
import 'login_screen.dart';
import 'meetup_home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String route = '/register';
  final AuthApiService authApiService = AuthApiService();

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  RegisterFormData _registerData = RegisterFormData();

  void _handleSuccess(data) {
    print('Yeey!!');
  }

  void _handleError(error) {
    print(error);
  }

  void _register() {
    widget.authApiService
        .register(_registerData)
        .then(_handleSuccess)
        .catchError(_handleError);
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      _register();
    } else {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                children: [
                  _buildTitle(),
                  TextFormField(
                    style: Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(hintText: 'Name'),
                    onSaved: (value) => _registerData.name = value,
                    validator: composeValidators(
                      'name',
                      [requiredValidator],
                    ),
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(hintText: 'Username'),
                    onSaved: (value) => _registerData.username = value,
                    validator: composeValidators(
                      'username',
                      [requiredValidator],
                    ),
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(hintText: 'Email Address'),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) => _registerData.email = value,
                    validator: composeValidators(
                      'email',
                      [
                        requiredValidator,
                        emailValidator,
                      ],
                    ),
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(hintText: 'Avatar Url'),
                    keyboardType: TextInputType.url,
                    onSaved: (value) => _registerData.avatar = value,
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(hintText: 'Password'),
                    obscureText: true,
                    onSaved: (value) => _registerData.password = value,
                    validator: composeValidators(
                      'password',
                      [
                        requiredValidator,
                        minLengthValidator,
                      ],
                    ),
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.headline6,
                    decoration:
                        InputDecoration(hintText: 'Password Confirmation'),
                    obscureText: true,
                    onSaved: (value) =>
                        _registerData.passwordConfirmation = value,
                    validator: composeValidators(
                      'password confirmation',
                      [requiredValidator],
                    ),
                  ),
                  _buildLinksSection(),
                  _buildSubmitBtn()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Text(
        'Register Today',
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLinksSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LoginScreen.route);
            },
            child: Text(
              'Already Registered? Login Now.',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          GestureDetector(
              onTap: () => Navigator.pushNamed(context, MeetupHomeScreen.route),
              child: Text(
                'Continue to Home Page',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
      alignment: Alignment(-1.0, 0.0),
      child: RaisedButton(
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
        child: const Text('Submit'),
        onPressed: _submit,
      ),
    );
  }
}
