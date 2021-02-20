import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/user_bloc/user_bloc.dart';

class BottomNavigation extends StatelessWidget {
  final Function(int) onChange;
  final UserState userState;
  final int currentIndex;
  BottomNavigation({
    @required this.onChange,
    @required this.userState,
    @required this.currentIndex,
  });

  void _handleTap(BuildContext context, int tappedIndex) {
    if (tappedIndex != currentIndex) {
      if (_canAccess() || tappedIndex == 0) {
        onChange(tappedIndex);
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('You need to login and to be member of this meetup'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Color _renderColor() {
    return _canAccess() ? null : Colors.black12;
  }

  bool _canAccess() {
    return userState is UserIsMember || userState is UserIsMeetupOwner;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int i) => _handleTap(context, i),
      currentIndex: currentIndex,
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
