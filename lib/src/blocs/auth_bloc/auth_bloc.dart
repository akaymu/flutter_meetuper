import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../services/auth_api_service.dart';
import '../bloc_provider.dart';
import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class AuthBloc extends BlocBase {
  final AuthApiService auth;
  AuthBloc({@required this.auth}) : assert(auth != null);

  final BehaviorSubject<AuthenticationState> _authController =
      BehaviorSubject<AuthenticationState>();
  Stream<AuthenticationState> get authState => _authController.stream;
  StreamSink<AuthenticationState> get _inAuth => _authController.sink;

  void dispatch(AuthenticationEvent event) async {
    await for (var state in _authStream(event)) {
      _inAuth.add(state);
    }
  }

  Stream<AuthenticationState> _authStream(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool isAuth = await auth.isAuthenticated();

      if (isAuth) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is InitLogging) {
      yield AuthenticationLoading();
    }

    if (event is LoggedIn) {
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationUnauthenticated(logout: true);
    }
  }

  @override
  void dispose() {
    _authController.close();
  }
}
