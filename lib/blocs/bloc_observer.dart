import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if(kDebugMode) {
      print('onEvent -- ${bloc.runtimeType}, event: $event');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if(kDebugMode) {
      print('onChange -- ${bloc.runtimeType}, change: $change');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if(kDebugMode) {
      print('onTransition -- ${bloc.runtimeType}, transition: $transition');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if(kDebugMode) {
      print('onError -- ${bloc.runtimeType}, error: $error');
    }
    super.onError(bloc, error, stackTrace);
  }
}