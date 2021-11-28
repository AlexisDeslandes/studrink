import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:studrink/blocs/board_game/board_game_bloc.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';
import 'package:studrink/models/board_game.dart';

class SDQrCodeScannerWidget extends StatefulWidget {
  const SDQrCodeScannerWidget({Key? key}) : super(key: key);

  @override
  _SDQrCodeScannerWidgetState createState() => _SDQrCodeScannerWidgetState();
}

class _SDQrCodeScannerWidgetState extends State<SDQrCodeScannerWidget> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late final QRViewController _controller;
  late final StreamSubscription _subscription;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller.pauseCamera();
    } else if (Platform.isIOS) {
      _controller.resumeCamera();
    }
  }

  @override
  Future dispose() async {
    _controller.dispose();
    await _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QRView(
        key: _qrKey,
        onQRViewCreated: (ctrl) {
          _controller = ctrl;
          _subscription = _controller.scannedDataStream.listen((event) {
            final code = event.code;
            if (code != null && code.startsWith("SD_APP")) {
              final boardGame = BoardGame.fromCode(code);
              if (boardGame != null) {
                _subscription.pause();
                context.read<BoardGameBloc>().add(AddBoardGame(boardGame));
                context.read<NavBloc>().add(const PopNav());
              }
            }
          });
        });
  }
}
