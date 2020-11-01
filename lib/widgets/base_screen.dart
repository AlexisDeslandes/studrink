import 'package:flutter/cupertino.dart';

abstract class BaseScreen extends StatelessWidget {
  const BaseScreen();

  String title();

  Widget body(BuildContext context);

  bool hasBackElement();

  Widget backElement(BuildContext context);
}
