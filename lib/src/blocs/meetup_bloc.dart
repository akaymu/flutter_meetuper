import 'dart:async';

import '../models/meetup.dart';
import '../services/meetup_api_service.dart';
import 'bloc_provider.dart';

class MeetupBloc implements BlocBase {
  final MeetupApiService _api = MeetupApiService();

  final StreamController<List<Meetup>> _meetupController =
      StreamController<List<Meetup>>.broadcast();

  // Getters
  Stream<List<Meetup>> get meetups => _meetupController.stream;
  StreamSink<List<Meetup>> get _inMeetups => _meetupController.sink;

  void fetchMeetups() async {
    final List<Meetup> meetups = await _api.fetchMeetups();
    _inMeetups.add(meetups);
  }

  @override
  void dispose() {
    _meetupController.close();
  }
}
