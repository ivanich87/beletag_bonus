import 'package:beletag/models/Lists.dart';
import 'package:beletag/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:beletag/screens/home.dart';
import 'package:beletag/screens/logon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class ThemeNotifier extends ChangeNotifier {
  // Define your default thememode here
  ThemeMode themeMode = ThemeMode.light;

  ThemeNotifier() {
    _init();
  }

  _init() async {
    int themeIndex = 0;

    var prefs = await SharedPreferences.getInstance();
    final String? Inf = prefs.getString('userInfoKey');
    if (Inf == null) {
      themeIndex = 0;
    } else {
      var str = json.decode(Inf);
      UserInfo dt = UserInfo.fromJson(str);
      themeIndex = dt.themeIndex;
    }

    // prefs = await SharedPreferences.getInstance();
    //
    // int _theme = prefs?.getInt("theme") ?? themeMode.index;
    themeMode = ThemeMode.values[themeIndex];
    print('Запустили смену темы $themeIndex $themeMode');
    notifyListeners();
  }

  setTheme(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
    // Save the selected theme using shared preferences
    //prefs?.setInt("theme", mode.index);
  }
}

final themeNotifierProvider = ChangeNotifierProvider<ThemeNotifier>((_) => ThemeNotifier());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const userInfoKey = 'userInfoKey';

  bool _load = false;
  String _login = '';
  String _password = '';

  bool success = false;
  String message = '';
  bool logIn = false;

  int themeIndex = 0;


  Future httpGetUserData() async {
    var prefs = await SharedPreferences.getInstance();
    final String? Inf = prefs.getString(userInfoKey);
    if (Inf == null) {
      _login = '';
      _password = '';
      _load = true;
      themeIndex = 0;
      print('не нашли данных по ключу $userInfoKey');
    } else {
      var str = json.decode(Inf);
      UserInfo dt = UserInfo.fromJson(str);
      _login = dt.login;
      _password = dt.password;
      themeIndex = dt.themeIndex;
      print('Нашли данные по ключу $userInfoKey Логин: $_login Пароль: $_password');
    }

    print('logon......');
    print('Логин: $_login');
    print('Пароль: $_password');
    print('Тема: $themeIndex');

    if (themeIndex==null)
      themeIndex = 0;

    Globals.setThemeIndex(themeIndex);
    Globals.setLogin(_login);
    Globals.setPasswodr(_password);

    var _url=Uri(path: '/c/beletag_bonus/hs/v1/logon/', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    var _body = <String, String> {
      "login": _login,
      "password": _password
    };
    try {
      var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        message = notesJson['message'] ?? '';
        logIn = notesJson['response'] ?? false;
        print('Ответ авторизации: $logIn Текст ответа: $message');
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }


  @override
  void initState() {
    httpGetUserData().then((value) {
      print('111111111111');
      _load = true;
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ChangeNotifierProvider((ref) {
      final _themeNotifier = ref.watch(themeNotifierProvider);
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData.light().copyWith(cardColor: Colors.black12),
      darkTheme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.grey[400]), //grey[850]
      themeMode: ThemeMode.values[themeIndex],
      title: 'Бельетаж>',

      home: (logIn == true) ? scrHomeScreen(_login) : (_load == true) ? scrLogonScreen() : scrLoadingScreen(),
    );
  }
}
