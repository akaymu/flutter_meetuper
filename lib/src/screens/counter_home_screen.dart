import 'package:flutter/material.dart';

class CounterHomeScreen extends StatefulWidget {
  final String _title;
  CounterHomeScreen({String title}) : _title = title;

  @override
  _CounterHomeScreenState createState() => _CounterHomeScreenState();
}

class _CounterHomeScreenState extends State<CounterHomeScreen> {
  int _counter = 0;

  _increment() {
    setState(() {
      _counter++;
    });
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Increment',
        onPressed: _increment,
      ),
      bottomNavigationBar: _BottomNavigation(),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
