import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/bloc_provider.dart';
import 'package:flutter_meetuper/src/blocs/counter_bloc.dart';
import 'package:flutter_meetuper/src/blocs/meetup_bloc.dart';
import 'package:flutter_meetuper/src/models/arguments.dart';
import 'package:flutter_meetuper/src/screens/counter_home_screen.dart';

import 'src/screens/login_screen.dart';
import 'src/screens/meetup_detail_screen.dart';
import 'src/screens/meetup_home_screen.dart';
import 'src/screens/register_screen.dart';

void main() {
  runApp(MeetuperApp());
}

class MeetuperApp extends StatelessWidget {
  final String appTitle = 'Meetuper App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: LoginScreen.route,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case MeetupHomeScreen.route:
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return BlocProvider<MeetupBloc>(
                  child: MeetupHomeScreen(),
                  bloc: MeetupBloc(),
                );
              },
            );
            break;

          case MeetupDetailScreen.route:
            final MeetupDetailArguments arguments = settings.arguments;
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return MeetupDetailScreen(meetupId: arguments.id);
              },
            );
            break;

          case RegisterScreen.route:
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return RegisterScreen();
              },
            );
            break;

          case LoginScreen.route:
            final LoginScreenArguments arguments = settings.arguments;
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return LoginScreen(message: arguments?.message);
              },
            );
            break;

          // Daha sonra kaldırılacak...
          case CounterHomeScreen.route:
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return BlocProvider<CounterBloc>(
                  bloc: CounterBloc(),
                  child: CounterHomeScreen(title: 'Counter'),
                );
              },
            );
            break;

          default:
            return null;
            break;
        }
      },
    );
  }
}
