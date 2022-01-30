import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(30),
      child: LayoutBuilder(
          builder: (context, constraints) => Center(
                  child: FadeTransition(
                opacity: controller,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(13)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth,
                        child: const SDQrCodeScannerWidget()),
                  ),
                ),
              ))));

  @override
  String get subTitle => "Scanner un QR code de jeu Studrink";

  @override
  String get title => "Nouveau jeu";
}
