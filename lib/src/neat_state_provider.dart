import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neat_state/neat_state.dart';

/// NeatProvider global app state provider. Place it as high as possible in a widget tree
///
/// initialState - an initial state app starts with
/// lazy - see lazy field of BlocProvider
/// onChangeCallback - an optional callback to log transitions of the state
class NeatProvider<S> extends BlocProvider<NeatState<S>> {
  NeatProvider({
    Key? key,
    required S initialState,
    bool? lazy,
    void Function(Change<S> change)? onChangeCallback,
    Widget? child,
  }) : super(
          key: key,
          lazy: lazy,
          create: (_) => NeatState<S>(
            initialState: initialState,
            onChangeCallback: onChangeCallback,
          ),
          child: child,
        );
}
