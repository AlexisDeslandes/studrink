import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studrink/blocs/provider/app_provider.dart';
import 'package:studrink/storage/local_storage.dart';
import 'package:studrink/theme/app_theme.dart';
import 'package:studrink/widgets/paints/app_background_paint.dart';

import 'navigators/main_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  LocalStorage(sharedPreferences: await SharedPreferences.getInstance());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Studrink",
        theme: AppTheme().lightTheme,
        home: AppProvider(child: Scaffold(body: const MainNavigator())));
  }
}
