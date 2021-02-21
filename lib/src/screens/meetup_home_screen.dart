import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/screens/login_screen.dart';
import 'package:flutter_meetuper/src/screens/register_screen.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/bloc_provider.dart';
import '../blocs/meetup_bloc.dart';
import '../models/meetup.dart';
import '../services/auth_api_service.dart';
import 'meetup_create_screen.dart';
import 'meetup_detail_screen.dart';

class MeetupDetailArguments {
  final String id;
  MeetupDetailArguments({this.id});
}

class MeetupHomeScreen extends StatefulWidget {
  // Navigation route name
  static const String route = '/meetupHome';

  @override
  _MeetupHomeScreenState createState() => _MeetupHomeScreenState();
}

class _MeetupHomeScreenState extends State<MeetupHomeScreen> {
  List<Meetup> meetups = [];

  AuthBloc authBloc;

  @override
  void initState() {
    BlocProvider.of<MeetupBloc>(context).fetchMeetups();
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return _ModalBottomSheet(authBloc: authBloc);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _showBottomMenu(context),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _MeetupTitle(authBloc: authBloc),
          _MeetupList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, MeetupCreateScreen.route);
        },
      ),
    );
  }
}

class _MeetupTitle extends StatelessWidget {
  final AuthBloc authBloc;
  _MeetupTitle({@required this.authBloc});

  final AuthApiService authApiService = AuthApiService();

  Widget _buildUserWelcome() {
    return FutureBuilder<bool>(
      initialData: false,
      future: authApiService.isAuthenticated(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data) {
          final user = authApiService.authUser;
          return Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                // List içinde ternary operation kullanırken null kullanamazsın.
                // Bu sebeple aşağıdaki gibi süslü parantezsiz if kullanabilirsin.
                if (user.avatar != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar)),
                  ),
                Text('Welcome ${user.username}'),
                Spacer(), // Olabildiğince büyük yer kaplar...
                GestureDetector(
                  onTap: () {
                    authApiService.logout().then(
                      (isLogout) {
                        authBloc.dispatch(
                          LoggedOut(
                              message:
                                  'You have been successfully logged out!'),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(width: 0, height: 0);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Meetups',
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildUserWelcome(),
        ],
      ),
    );
  }
}

class _MeetupCard extends StatelessWidget {
  final Meetup meetup;
  _MeetupCard({@required this.meetup});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(meetup.image),
            ),
            title: Text(meetup.title),
            subtitle: Text(meetup.description),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('Visit Meetup'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    MeetupDetailScreen.route,
                    arguments: MeetupDetailArguments(id: meetup.id),
                  );
                },
              ),
              FlatButton(
                onPressed: () {},
                child: Text('Favorite'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeetupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Meetup>>(
        initialData: [],
        stream: BlocProvider.of<MeetupBloc>(context).meetups,
        builder: (BuildContext context, AsyncSnapshot<List<Meetup>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length * 2,
              itemBuilder: (BuildContext context, int i) {
                if (i.isOdd) {
                  return Divider();
                }
                final int index = i ~/ 2;

                return _MeetupCard(meetup: snapshot.data[index]);
              },
            );
          }

          return null;
        },
      ),
    );
  }
}

class _ModalBottomSheet extends StatelessWidget {
  final AuthBloc authBloc;
  _ModalBottomSheet({@required this.authBloc}) : assert(authBloc != null);

  final AuthApiService authApiService = AuthApiService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthenticationState>(
      stream: authBloc.authState,
      initialData: AuthenticationUninitialized(),
      builder:
          (BuildContext context, AsyncSnapshot<AuthenticationState> snapshot) {
        final state = snapshot.data;

        if (state is AuthenticationUninitialized) {
          return Container(width: 0, height: 0);
        }

        if (state is AuthenticationAuthenticated) {
          return Container(
            height: 150.0,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Create Meetup'),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      MeetupCreateScreen.route,
                      ModalRoute.withName('/'),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    authApiService.logout().then(
                      (isLogout) {
                        // Bu sayede bottom modal kapanır.
                        Navigator.pop(context);

                        authBloc.dispatch(
                          LoggedOut(
                              message:
                                  'You have been successfully logged out!'),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        }

        if (state is AuthenticationUnauthenticated) {
          return Container(
            height: 150.0,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.login),
                  title: Text('Login'),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginScreen.route,
                      ModalRoute.withName(MeetupHomeScreen.route),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Register'),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RegisterScreen.route,
                      ModalRoute.withName(MeetupHomeScreen.route),
                    );
                  },
                ),
              ],
            ),
          );
        }

        return Container(width: 0, height: 0);
      },
    );
  }
}
