import 'package:flutter/cupertino.dart';
import 'package:studrink/pages/my_custom_page.dart';
import 'package:studrink/widgets/base_screen.dart';
import 'package:studrink/widgets/sd_qr_code_scanner_widget.dart';

class QRCodePage extends MyCustomPage {
  const QRCodePage()
      : super(child: const QRCodeScreen(), key: const ValueKey("/qr_code"));
}

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends BaseScreenState {
  @override
  Widget body(BuildContext context) => Padding(
      padding: const EdgeInsets.all(30), child: const SDQrCodeScannerWidget());

  @override
  String get subTitle => "Scanner un QR code";

  @override
  String get title => "Nouveau jeu";
}
