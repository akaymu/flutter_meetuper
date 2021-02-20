import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/user_bloc/user_bloc.dart';

class BottomNavigation extends StatefulWidget {
  final Function(int) onChange;
  final UserState userState;
  BottomNavigation({
    @required this.onChange,
    @required this.userState,
  });

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  void _handleTap(int tappedIndex) {
    widget.onChange(tappedIndex);
    setState(() => _currentIndex = tappedIndex);
  }

  Color _renderColor() {
    return (widget.userState is UserIsMember ||
            widget.userState is UserIsMeetupOwner)
        ? null
        : Colors.black12;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: _handleTap,
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Detail',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.note,
            color: _renderColor(),
          ),
          label: 'Threads',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.people,
            color: _renderColor(),
          ),
          label: 'People',
        ),
      ],
    );
  }
}
