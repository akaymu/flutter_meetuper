import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/bottom_navigation.dart';
import 'meetup_detail_screen.dart';

class CounterHomeScreen extends StatefulWidget {
  static const String route = '/counter';

  final String _title;
  CounterHomeScreen({String title}) : _title = title;

  @override
  _CounterHomeScreenState createState() => _CounterHomeScreenState();
}

class _CounterHomeScreenState extends State<CounterHomeScreen> {
  final StreamController<int> _streamController =
      StreamController<int>.broadcast();
  int _counter = 0;

  @override
  initState() {
    super.initState();
    _streamController.stream
        .where((data) => data < 15)
        .skip(2) // 2 kere işlem yapmadı. sonra başladı.
        .map((data) => data * 2)
        .map((data) => data - 4)
        .map((data) => data * data)
        .listen((data) {
      print('FROM INITSTATE FUNCTION');
      print(data);
    });
  }

  _increment() {
    _streamController.sink.add(10);
    // setState(() {
    //   _counter++;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome in ${widget._title}, lets increment numbers!',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 15.0),
            ),
            Text(
              'Click Counter: $_counter',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 30.0),
            ),
            RaisedButton(
              child: Text('Go To Detail'),
              onPressed: () {
                Navigator.pushNamed(context, MeetupDetailScreen.route);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Increment',
        onPressed: _increment,
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
