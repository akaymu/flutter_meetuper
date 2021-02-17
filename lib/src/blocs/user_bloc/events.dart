import 'package:meta/meta.dart';

import '../../models/meetup.dart';

abstract class UserEvent {}

class CheckUserPermissionsOnMeetup extends UserEvent {
  Meetup meetup;
  CheckUserPermissionsOnMeetup({@required this.meetup});

  @override
  String toString() => 'CheckUserPermissionsOnMeetup';
}
