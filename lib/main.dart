import 'package:flutter/material.dart';

void main() {
  runApp(MeetuperApp());
}

class MeetuperApp extends StatelessWidget {
  final String appTitle = 'Meetuper App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: Center(
          child: Text(
            'Welcome in $appTitle!',
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
  }
}
