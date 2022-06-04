import 'package:flutter/cupertino.dart';

bool isTablet(BuildContext context) => MediaQuery.of(context).size.width > 600;

int gridIndex(int index) => (index + 3) % 6 == 0
    ? index + 2
    : (index + 1) % 6 == 0
        ? index - 2
        : index;
