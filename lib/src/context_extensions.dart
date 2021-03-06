import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neat_state/neat_state.dart';

/// Neat state context extensions
extension NeatStateExtension on BuildContext {
  /// bloc getter
  NeatState<S> neatState<S>() => read<NeatState<S>>();

  /// Neat state global state getter
  S neatValue<S>() => neatState<S>().state;

  /// Neat state global state stream getter
  Stream<S> neatStream<S>() => neatState<S>().stream;

  /// Neat state getter for a substate stream of global state stream with a help of a mapper
  Stream<SubS> neatSubStream<S, SubS>(SubS Function(S state) mapper) => neatState<S>().subState(mapper);

  /// Replace global state with state from parameter
  void neatReplace<S>(S appState) => neatState<S>().replace(appState);

  /// Update global state with stateUpdater function - most time it's more convenient
  void neatUpdate<S>(S Function(S appState) stateUpdater) => neatState<S>().update(stateUpdater);
}
