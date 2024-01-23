import 'dart:convert';

//import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beletag/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Lists.dart';


class scrSettingsScreen extends StatefulWidget {
  // final String id;
  scrSettingsScreen(); //this.id

  @override
  State<scrSettingsScreen> createState() => _scrSettingsScreenState();
}



class _scrSettingsScreenState extends State<scrSettingsScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  int _themeIndex = Globals.anThemeIndex;
  bool userDataEdit = false;
  static const userInfoKey = 'userInfoKey';

  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (bool didPop) async {
        if (userDataEdit==true) {
          print('Выход с сохранением: ${Globals.anLogin}, ${Globals.anPassword}, ${Globals.anThemeIndex}');
          //сохраняем в локальную БД параметры
          var prefs = await SharedPreferences.getInstance();
          final _userInfo = UserInfo(login: Globals.anLogin, password: Globals.anPassword, themeIndex: _themeIndex);
          prefs.setString(userInfoKey, json.encode(_userInfo));
        }
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Настройки'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _singleTile("Dark Theme", _themeIndex, 2),
            _singleTile("Light Theme", _themeIndex, 1),
            _singleTile("System Theme", _themeIndex, 0),
          ],
        ),
      )
    );
  }
  Widget _singleTile(String title, int themeModeIndex, int mode) {
    return RadioListTile(
        value: mode,
        title: Text(title),
        groupValue: themeModeIndex,
        onChanged: (val) {
          if (val != null) {
            print(val.toString());
            _themeIndex = mode;
            _themeMode = ThemeMode.values[_themeIndex];
            userDataEdit = true;
            print(_themeMode.toString());
            //notifyL
            setState(() {

            });
          };
        });
  }
}

