Some utilities to make work with a neat_state package in Flutter more convenient

## Usage

Place NeatProvider somewhere at the top of a widget tree of your app (onChangeCallback is 
optional, can be useful to log state transitions):
```dart
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
```

Update your widget (with optional buildWhen condition) on state change with 
BlocBuilder from flutter_bloc package:
```dart
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
```

Update your state anywhere in the widget tree using context extensions:
```dart
void _incrementCounterByContextExtension(BuildContext context) {
  // A state update function, takes an old state as an argument and must return the new state
  context.neatUpdate<AppState>(
        (AppState state) => state.copyWith(
      // return the new state that is copy of an old state..
      counter: state.counter + 1, // ..with incremented counter
    ),
  );
}
```
Or by using reference to NeatState:
```dart
// Get NeatState reference from context with Provider
final NeatState<AppState> neatState = context.read<NeatState<AppState>>();

// ...

// A state update function, takes an old state as an argument and must return the new state
neatState.update(
  (AppState state) => state.copyWith(
    // return the new state that is copy of an old state..
    counter: state.counter + 1, // ..with incremented counter
  ),
);
```

Subscribe to the app state or some sub-state of the state (of course you can use 
map() on neatStream() to get an sub-state):
```dart
// Subscribe only to a counter substate of the whole app state
final StreamSubscription<int> _subscription = context
    .neatSubStream(
      (AppState state) => state.counter,
    )
    .listen(
      (int counter) => print('counter=$counter'),
    );
```

## Additional information

- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [Single source of truth](https://en.wikipedia.org/wiki/Single_source_of_truth)
