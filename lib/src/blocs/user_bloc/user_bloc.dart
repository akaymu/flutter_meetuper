import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

import '../../models/meetup.dart';
import '../../models/user.dart';
import '../../services/auth_api_service.dart';
import '../bloc_provider.dart';
import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class UserBloc extends BlocBase {
  final AuthApiService auth;
  UserBloc({@required this.auth}) : assert(auth != null);

  // Controller and getters
  final BehaviorSubject<UserState> _userSubject = BehaviorSubject<UserState>();
  Stream<UserState> get userState => _userSubject.stream;
  StreamSink<UserState> get _inUserState => _userSubject.sink;

  void dispatch(UserEvent event) async {
    await for (var state in _userStream(event)) {
      _inUserState.add(state);
    }
  }

  Stream<UserState> _userStream(UserEvent event) async* {
    if (event is CheckUserPermissionsOnMeetup) {
      final bool isAuth = await auth.isAuthenticated();

      if (isAuth) {
        final User user = auth.authUser;
        final meetup = event.meetup;

        if (_isUserMeetupOwner(meetup, user)) {
          yield UserIsMeetupOwner();
          return;
        }

        if (_isUserJoinedInMeetup(meetup, user)) {
          yield UserIsMember();
        } else {
          yield UserIsNotMember();
        }
      } else {
        yield UserIsNotAuth();
      }
    }

    // Remove it after testing
    // if (event is JoinMeetup) {
    //   yield UserIsMember();
    // }

    // if (event is LeaveMeetup) {
    //   yield UserIsNotMember();
    // }
  }

  bool _isUserMeetupOwner(Meetup meetup, User user) {
    return user != null && meetup.meetupCreator.id == user.id;
  }

  bool _isUserJoinedInMeetup(Meetup meetup, User user) {
    return user != null &&
        user.joinedMeetups.isNotEmpty &&
        user.joinedMeetups.contains(meetup.id);
  }

  @override
  void dispose() {
    _userSubject.close();
  }
}
