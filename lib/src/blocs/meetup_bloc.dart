import 'dart:async';

import '../models/meetup.dart';
import '../models/user.dart';
import '../services/auth_api_service.dart';
import '../services/meetup_api_service.dart';
import 'bloc_provider.dart';

class MeetupBloc implements BlocBase {
  // Better idea would be to inject service in constructor
  final MeetupApiService _api = MeetupApiService();
  final AuthApiService _auth = AuthApiService();

  final StreamController<List<Meetup>> _meetupController =
      StreamController.broadcast();
  Stream<List<Meetup>> get meetups => _meetupController.stream;
  StreamSink<List<Meetup>> get _inMeetups => _meetupController.sink;

  final StreamController<Meetup> _meetupDetailController =
      StreamController.broadcast();
  Stream<Meetup> get meetupDetail => _meetupDetailController.stream;
  StreamSink<Meetup> get _inMeetupDetail => _meetupDetailController.sink;

  void fetchMeetups() async {
    final List<Meetup> meetups = await _api.fetchMeetups();
    _inMeetups.add(meetups);
  }

  void fetchMeetupDetail(String meetupId) async {
    final meetup = await _api.fetchMeetupById(meetupId);
    _inMeetupDetail.add(meetup);
  }

  void joinMeetup(Meetup meetup) {
    _api.joinMeetup(meetup.id).then((_) {
      User user = _auth.authUser;

      // Add meetup to joined meetups of user
      user.joinedMeetups.add(meetup.id);

      // Add user to joined people of meetup and increment count
      meetup.joinedPeople.add(user);
      meetup.joinedPeopleCount++;

      // Send it to listeners
      _inMeetupDetail.add(meetup);
    }).catchError((err) => print(err));
  }

  void leaveMeetup(Meetup meetup) {
    _api.leaveMeetup(meetup.id).then((_) {
      User user = _auth.authUser;

      // Remove meetup from joined meetups of user
      user.joinedMeetups.removeWhere((jMeetupId) => jMeetupId == meetup.id);

      // Remove user from joined people of meetup and decrement count
      meetup.joinedPeople.removeWhere((jUser) => jUser.id == user.id);
      meetup.joinedPeopleCount--;

      // Send it to listeners
      _inMeetupDetail.add(meetup);
    }).catchError((err) => print(err));
  }

  @override
  void dispose() {
    _meetupController.close();
    _meetupDetailController.close();
  }
}
