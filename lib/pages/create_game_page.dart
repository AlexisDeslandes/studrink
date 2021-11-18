import 'package:flutter/cupertino.dart';
import 'package:studrink/pages/my_custom_page.dart';
import 'package:studrink/widgets/base_screen.dart';

class CreateGamePage extends MyCustomPage {
  const CreateGamePage()
      : super(
            key: const ValueKey<String>("/create_game"),
            child: const CreateGameScreen());
}

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({Key? key}) : super(key: key);

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends BaseScreenState {
  @override
  Widget body(BuildContext context) => const SizedBox();

  @override
  String get subTitle => "XXX";

  @override
  String get title => "xxx";
}
