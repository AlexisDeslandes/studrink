import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///
/// Model for snackbar element that
/// use a specific callback for the button.
///
class CallbackSnackBarElement extends Equatable {
  final String content;
  final String extra;
  final String buttonContent;
  final VoidCallback callback;

  const CallbackSnackBarElement(this.content, this.buttonContent, this.callback,
      {this.extra = ""});

  CallbackSnackBarElement.closable(String content)
      : this(content, "CLOSE", () {});

  @override
  String toString() {
    return 'CallbackSnackBarElement{key: $content, extraKey: $extra, buttonKey: $buttonContent, callback: $callback}';
  }

  @override
  List<Object?> get props => [content, extra, buttonContent];
}

///
/// Exception that occurs on blocs.
///
class BlocException extends Equatable implements Exception {
  final String className;
  final String methodName;
  final String text;
  final Object e;

  BlocException({
    required this.className,
    required this.methodName,
    required this.e,
    String? text,
  }) : text = text ?? "";

  @override
  List<Object?> get props => [className, methodName, e];
}

///
/// Alert error are used to display
/// custom messages with alert utils.
///
class DialogErrorModel extends Equatable {
  final String content;

  const DialogErrorModel(this.content);

  bool get canErrorBeSent => false;

  @override
  List<Object?> get props => [content];
}

///
/// Bloc wrapper to deal with error thrown in blocs.
/// It uses an error subject that is used to
/// add alert error to sink.
/// Widgets can subscribe to error bloc to display alerts.
///
abstract class BlocEmitter<E, S> extends Bloc<E, S> {
  final ErrorEmitter _errorEmitter;
  final SnackBarEmitter _snackBarEmitter;
  final BottomSheetEmitter _bottomSheetEmitter;

  BlocEmitter(S initialState,
      {ErrorEmitter? errorEmitter,
      SnackBarEmitter? snackBarEmitter,
      BottomSheetEmitter? bottomSheetEmitter})
      : _errorEmitter = errorEmitter ?? ErrorEmitter(),
        _snackBarEmitter = snackBarEmitter ?? SnackBarEmitter(),
        _bottomSheetEmitter = bottomSheetEmitter ?? BottomSheetEmitter(),
        super(initialState);
}

///
/// Bloc wrapper to deal with error message to display with alert utils.
///
mixin ErrorBloc<E, S> on BlocEmitter<E, S> {
  Stream<DialogErrorModel> get errorStream => _errorEmitter.errorStream;

  void emitError(String content) {
    _errorEmitter.treatError(content);
  }

  void treatError(
      {required BlocException blocException, required StackTrace stackTrace}) {
    //_errorEmitter.treatError(blocException.e);
    addError(blocException, stackTrace);
  }
}

///
/// Bloc wrapper to deal with snackBar message send in blocs.
/// Widget can subscribe to snackBar bloc to display snackbar messages.
///
mixin SnackBarBloc<E, S> on BlocEmitter<E, S> {
  Stream<CallbackSnackBarElement> get snackBarStream => _snackBarEmitter.stream;

  void emitSnackBarAction(CallbackSnackBarElement callbackSnackBarElement) =>
      _snackBarEmitter.add(callbackSnackBarElement);

  void emitSnackBar(String content) =>
      _snackBarEmitter.add(CallbackSnackBarElement.closable(content));
}

class SnackBarEmitter {
  SnackBarEmitter._();

  factory SnackBarEmitter(
      {StreamController<CallbackSnackBarElement>? controller}) {
    if (_instance == null) {
      _instance = SnackBarEmitter._();
      _instance!._controller =
          controller ?? StreamController<CallbackSnackBarElement>.broadcast();
    }
    return _instance!;
  }

  static SnackBarEmitter? _instance;
  late StreamController<CallbackSnackBarElement> _controller;

  Stream<CallbackSnackBarElement> get stream => _controller.stream;

  void close() {
    _controller.close();
  }

  void add(CallbackSnackBarElement element) => _controller.add(element);
}

class BottomSheetElement {
  BottomSheetElement({required this.build, this.scrollable = false});

  final BottomSheetBuildCallback build;
  final bool scrollable;
}

class BottomSheetEmitter {
  BottomSheetEmitter._();

  factory BottomSheetEmitter(
      {StreamController<BottomSheetElement>? controller}) {
    if (_instance == null) {
      _instance = BottomSheetEmitter._();
      _instance!._controller =
          controller ?? StreamController<BottomSheetElement>.broadcast();
    }
    return _instance!;
  }

  static BottomSheetEmitter? _instance;
  late StreamController<BottomSheetElement> _controller;

  Stream<BottomSheetElement> get stream => _controller.stream;

  void close() {
    _controller.close();
  }

  void add(BottomSheetElement bottomSheetElt) =>
      _controller.add(bottomSheetElt);
}

typedef BottomSheetBuildCallback = Widget Function(ScrollController? ctrl);

///
/// Bloc wrapper to deal with bottom sheet message send in blocs.
/// Widget can subscribe to [BottomSheetBloc] to display bottom sheet messages.
///
mixin BottomSheetBloc<E, S> on BlocEmitter<E, S> {
  void emitBottomSheet(BottomSheetBuildCallback callback,
          {bool scrollable = false}) =>
      _bottomSheetEmitter
          .add(BottomSheetElement(build: callback, scrollable: scrollable));
}

class ErrorEmitter {
  ErrorEmitter._();

  factory ErrorEmitter({StreamController<DialogErrorModel>? errorSubject}) {
    if (_instance == null) {
      _instance = ErrorEmitter._();
      _instance!.errorSubject =
          errorSubject ?? StreamController<DialogErrorModel>.broadcast();
    }
    return _instance!;
  }

  static ErrorEmitter? _instance;
  late StreamController<DialogErrorModel> errorSubject;

  StreamSink<DialogErrorModel> get errorSink => errorSubject.sink;

  Stream<DialogErrorModel> get errorStream => errorSubject.stream;

  Future<void> close() => errorSubject.close();

  void treatError(String errMsg) {
    errorSink.add(DialogErrorModel(errMsg));
  }
}
