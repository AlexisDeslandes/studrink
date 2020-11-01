import 'package:flutter/cupertino.dart';

abstract class BaseScreen extends StatelessWidget {
  const BaseScreen();

  Widget title(BuildContext context);

  Widget body(BuildContext context);

  bool hasBackElement();

  Widget backElement(BuildContext context);
}
