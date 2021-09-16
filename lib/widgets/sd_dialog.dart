import 'package:flutter/material.dart';

class SdDialog extends StatelessWidget {
  const SdDialog(
      {Key? key, required this.title, required this.content, this.actions})
      : super(key: key);

  final String title;
  final String content;
  final List<TextButton>? actions;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 14)),
            Align(
                alignment: Alignment.centerRight,
                child: Wrap(children: actions ?? const []))
          ]),
    ));
  }
}
