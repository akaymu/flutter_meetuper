import 'package:flutter/material.dart';

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
                return MeetupHomeScreen();
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
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return LoginScreen();
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
