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
      home: CounterHomeScreen(
        title: appTitle,
      ),
    );
  }
}

class CounterHomeScreen extends StatelessWidget {
  final String _title;
  CounterHomeScreen({String title}) : _title = title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome in $_title, lets increment numbers!',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 15.0),
            ),
            Text(
              'Click Counter: 0',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 30.0),
            ),
          ],
        ),
      ),
    );
  }
}
