import 'dart:async';

import 'package:flutter/material.dart';

class CounterBloc {
  final StreamController<int> _streamController =
      StreamController<int>.broadcast();
  final StreamController<int> _counterController =
      StreamController<int>.broadcast();
  int _counter = 0;

  CounterBloc() {
    _streamController.stream.listen(_handleIncrement);
  }

  // Getters for stream and sink
  Stream<int> get counterStream => _counterController.stream;
  StreamSink<int> get counterSink => _counterController.sink;

  _handleIncrement(int number) {
    _counter += number;
    counterSink.add(_counter);
  }

  increment(int incrementer) {
    _streamController.sink.add(incrementer);
  }

  dispose() {
    _counterController.close();
    _streamController.close();
  }
}

class _CounterBlocProviderInherited extends InheritedWidget {
  final CounterBloc bloc;

  _CounterBlocProviderInherited({
    @required Widget child,
    Key key,
    @required this.bloc,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class CounterBlocProvider extends StatefulWidget {
  final CounterBloc bloc;
  final Widget child;

  CounterBlocProvider({Key key, @required this.child})
      : bloc = CounterBloc(),
        super(key: key);

  @override
  _CounterBlocProviderState createState() => _CounterBlocProviderState();

  static CounterBloc of(BuildContext context) {
    _CounterBlocProviderInherited provider = context
        .dependOnInheritedWidgetOfExactType<_CounterBlocProviderInherited>();
    return provider.bloc;
  }
}

class _CounterBlocProviderState extends State<CounterBlocProvider> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CounterBlocProviderInherited(
      child: widget.child,
      bloc: widget.bloc,
    );
  }
}
