import 'package:flutter/material.dart';

void main() {
  runApp(MeetuperApp());
}

class MeetuperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome in Meetuper App!',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
