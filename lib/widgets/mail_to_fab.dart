import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class MailToFab extends StatelessWidget {
  const MailToFab({Key? key}) : super(key: key);

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        heroTag: "msg",
        child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                gradient: LinearGradient(colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Icon(Icons.message, color: Colors.white)),
        onPressed: () => _launchURL(Uri(
            scheme: "mailto",
            path: "deslandes.alexis1@gmail.com",
            query: encodeQueryParameters(<String, String>{
              "subject": "Mon idée de nouvelle case ou de nouvelle partie"
            })).toString()));
  }
}
