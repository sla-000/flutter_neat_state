import 'dart:async';

import 'package:example/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neat_state/flutter_neat_state.dart';
import 'package:neat_state/neat_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeatProvider<AppState>(
      initialState: const AppState(),
      onChangeCallback: (Change<AppState> change) {
        debugPrint('NeatState: ${change.currentState} => ${change.nextState}');
      },
      child: MaterialApp(
        title: 'Flutter Neat State Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage(title: 'Flutter Neat State Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  void _incrementCounterByContextExtension(BuildContext context) {
    // A state update function, takes an old state as an argument and must return the new state
    context.neatUpdate<AppState>(
      (AppState state) => state.copyWith(
        // return the new state that is copy of an old state..
        counter: state.counter + 1, // ..with incremented counter
      ),
    );
  }

  // Example
  void _incrementCounterByReference(BuildContext context) {
    // Get NeatState reference from context with Provider
    final NeatState<AppState> neatState = context.read<NeatState<AppState>>();

    //..

    // A state update function, takes an old state as an argument and must return the new state
    neatState.update(
      (AppState state) => state.copyWith(
        // return the new state that is copy of an old state..
        counter: state.counter + 1, // ..with incremented counter
      ),
    );
  }

  // Example
  void _subscribeToStateChanges(BuildContext context) {
    // Subscribe only to a counter substate of the whole app state
    final StreamSubscription<int> _subscription = context
        .neatSubStream(
          (AppState state) => state.counter,
        )
        .listen(
          (int counter) => print('counter=$counter'),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text('You have pushed the button this many times:'),
            CounterValueSimple(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounterByContextExtension(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CounterValueSimple extends StatelessWidget {
  const CounterValueSimple({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NeatState<AppState>, AppState>(
      buildWhen: (AppState previous, AppState current) => current.counter != previous.counter,
      builder: (BuildContext context, AppState state) {
        return Text(
          '${state.counter}',
          style: Theme.of(context).textTheme.headline4,
        );
      },
    );
  }
}
