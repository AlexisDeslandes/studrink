import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studrink/blocs/bloc_emitter.dart';

///
/// Class to use as mixin on a state class of a stateful widget.
/// It permits to subscribe to a snackbar stream
/// from a snackbar bloc and display appropriate alerts.
///
mixin SnackBarStateHandler<W extends StatefulWidget> on State<W> {
  late final StreamSubscription _snackBarStream;

  @override
  void initState() {
    super.initState();
    _snackBarStream = SnackBarEmitter().stream.listen((event) {
      final snackBar = SnackBar(
        content: event.richText ?? Text(event.content),
        action: SnackBarAction(
          label: event.buttonContent,
          textColor: Theme.of(context).primaryColor,
          onPressed: () {
            event.callback();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  void dispose() async {
    await _snackBarStream.cancel();
    super.dispose();
  }
}
