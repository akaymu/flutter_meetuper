import 'package:flutter/material.dart';

class AppStore extends StatefulWidget {
  final Widget child;
  AppStore({@required this.child});

  @override
  _AppStoreState createState() => _AppStoreState();

  static _AppStoreState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedAppState>()
        .data;
  }
}

class _AppStoreState extends State<AppStore> {
  String testingData = 'Testing Data';
  String testingData2 = 'Testing Data 2';
  String testingData3 = 'Testing Data 3';

  @override
  Widget build(BuildContext context) {
    return _InheritedAppState(child: widget.child, data: this);
  }
}

class _InheritedAppState extends InheritedWidget {
  final Widget child;
  final _AppStoreState data;

  _InheritedAppState({@required this.child, @required this.data})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
