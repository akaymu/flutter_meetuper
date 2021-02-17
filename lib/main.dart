import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/user_bloc/user_bloc.dart';

import 'src/blocs/auth_bloc/auth_bloc.dart';
import 'src/blocs/bloc_provider.dart';
import 'src/blocs/counter_bloc.dart';
import 'src/blocs/meetup_bloc.dart';
import 'src/models/arguments.dart';
import 'src/screens/counter_home_screen.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/meetup_detail_screen.dart';
import 'src/screens/meetup_home_screen.dart';
import 'src/screens/register_screen.dart';
import 'src/services/auth_api_service.dart';

void main() {
  runApp(App());
}
/*
 * RXDART NOT:
 * Behaviour Subject: listen etmeye başlandığı anda en son geleni
 * ve daha sonra tekrar gelenleri gösterir.

 * Publish Subject: listen etmeye başlandığı andan sonra gelenleri
 * gösterir önceki değerle ilgilenmez.

 * Örnek: 
 * subject.stream.listen(...); -> Listen 1
 * subject.add(1);
 * subject.add(2);
 * subject.stream.listen(...); -> Listen 2
 * subject.add(3);
 * subject.close();
 * 
 * Örneğe göre subject Behaivour Subject ise ikinci listen'e gelen veriler
 * sırasıyla: 2 ve 3'tür.
 * 
 * Örneğe göre subject Publish Subject ise ikinci listen'e gelen veri 3'tür.
 */

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      child: MeetuperApp(),
      bloc: AuthBloc(auth: AuthApiService()),
    );
  }
}

class MeetuperApp extends StatefulWidget {
  @override
  _MeetuperAppState createState() => _MeetuperAppState();
}

class _MeetuperAppState extends State<MeetuperApp> {
  final String appTitle = 'Meetuper App';

  AuthBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // initialRoute: LoginScreen.route,
      home: StreamBuilder<AuthenticationState>(
        stream: authBloc.authState,
        initialData: AuthenticationUninitialized(),
        builder: (BuildContext context,
            AsyncSnapshot<AuthenticationState> snapshot) {
          final state = snapshot.data;

          if (state is AuthenticationUninitialized) {
            return SplashScreen();
          }

          if (state is AuthenticationAuthenticated) {
            return BlocProvider<MeetupBloc>(
              child: MeetupHomeScreen(),
              bloc: MeetupBloc(),
            );
          }

          if (state is AuthenticationUnauthenticated) {
            final LoginScreenArguments arguments =
                ModalRoute.of(context).settings.arguments;
            final message = state.message ?? arguments?.message;
            state.message = null;
            return LoginScreen(message: message);
          }

          if (state is AuthenticationLoading) {
            return LoadingScreen();
          }
        },
      ),
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
                return BlocProvider<MeetupBloc>(
                  bloc: MeetupBloc(),
                  child: BlocProvider<UserBloc>(
                    bloc: UserBloc(auth: AuthApiService()),
                    child: MeetupDetailScreen(meetupId: arguments.id),
                  ),
                );
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

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
