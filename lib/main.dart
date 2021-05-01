import 'package:flutter/material.dart';
import 'package:ptit_godet/blocs/provider/app_provider.dart';
import 'package:ptit_godet/storage/local_storage.dart';
import 'package:ptit_godet/theme/app_theme.dart';
import 'package:ptit_godet/widgets/paints/app_background_paint.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigators/main_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalStorage(sharedPreferences: await SharedPreferences.getInstance());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "P'tit Godet",
        theme: AppTheme().lightTheme,
        home: AppProvider(
            child: AppBackgroundPaint(
                child: Scaffold(
                    body: const MainNavigator(),
                    backgroundColor: Colors.transparent))));
  }
}
