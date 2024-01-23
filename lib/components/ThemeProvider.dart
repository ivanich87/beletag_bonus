import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  int isThemeIndex = 0;

   // int get isThemeIndex {
   //   if (themeMode == ThemeMode.system) {
   //     return 0;
   //   }
   //   if (themeMode == ThemeMode.light) {
   //     return 1;
   //   }
   //   if (themeMode == ThemeMode.dark) {
   //     return 2;
   //   }
   // }

  void toggleTheme(int themeIndex) {
    if (themeIndex==0)
      themeMode = ThemeMode.system;
    if (themeIndex==1)
      themeMode = ThemeMode.light;
    if (themeIndex==2)
      themeMode = ThemeMode.dark;

    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade300,
  );

  static final lightTheme = ThemeData(

  );
}