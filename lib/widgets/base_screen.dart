import 'package:flutter/cupertino.dart';

abstract class BaseScreenState<W extends StatefulWidget> extends State<W> {
  Widget title(BuildContext context);

  Widget body(BuildContext context);

  bool hasBackElement();

  Widget backElement(BuildContext context);
}
