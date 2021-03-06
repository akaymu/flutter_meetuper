import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_meetuper/src/blocs/bloc_provider.dart';
import 'package:flutter_meetuper/src/services/auth_api_service.dart';

import '../models/forms.dart';
import '../utils/validators.dart';
import 'meetup_home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';

  final String message;
  LoginScreen({this.message});

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

  AuthBloc _authBloc;

  LoginFormData _loginData = LoginFormData();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  BuildContext _scaffoldContext;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    // NOT: initState, build fonksiyonundan önce çalıştığı için
    // _scaffoldContext null olarak gelmektedir. Bu sebeple
    // _checkForMessageAndShowIfExists içindeki _scaffoldContext
    // hataya sebep olur. Çözüm: WidgetsBinding kullanmaktır.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForMessageAndShowIfExists();
    });

    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkForMessageAndShowIfExists() {
    if (widget.message != null && widget.message.isNotEmpty) {
      Scaffold.of(_scaffoldContext)
          .showSnackBar(SnackBar(content: Text(widget.message)));
    }
  }

  void _login() {
    _authBloc.dispatch(InitLogging());
    widget.authApi.login(_loginData).then((_) {
      // Navigator.pushNamed(context, MeetupHomeScreen.route);
      _authBloc.dispatch(LoggedIn());
    }).catchError((res) {
      _authBloc.dispatch(LoggedOut(message: res['errors']['message']));
    });
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save(); // Triggers onSaved functions
      _login();
    } else {
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Builder(
        builder: (BuildContext context) {
          _scaffoldContext = context;
          return Padding(
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
                    obscureText: true,
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
          );
        },
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
