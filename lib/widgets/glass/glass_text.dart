import 'package:flutter/material.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';

class GlassText extends StatelessWidget {
  const GlassText({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return GlassWidget(
        opacity: 0.52,
        radius: 13.0,
        padding: EdgeInsets.all(12.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 16.0),
        ));
  }
}
