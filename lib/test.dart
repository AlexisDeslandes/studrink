import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/theme/app_theme.dart';
import 'package:ptit_godet/widgets/player_overlay.dart';

void main() {
  runApp(MaterialApp(home: MyApp(), theme: AppTheme().lightTheme));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PlayerOverlay(
        player: Player(id: 0, color: Colors.orange, name: "Alexis"),
        size: MediaQuery.of(context).size.width / 2,
      ),
    );
  }
}
