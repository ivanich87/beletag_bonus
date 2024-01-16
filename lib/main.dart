import 'package:beletag/models/Lists.dart';
import 'package:beletag/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:beletag/screens/home.dart';
import 'package:beletag/screens/logon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

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


  Future httpGetUserData() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(userInfoKey);
    final String? Inf = prefs.getString(userInfoKey);
    //if (Inf == null) return null;
    if (Inf == null) {
      _login = '';
      _password = '';
      _load = true;
      print('не нашли данных по ключу $userInfoKey');
    } else {
      var str = json.decode(Inf);
      UserInfo dt = UserInfo.fromJson(str);
      _login = dt.login;
      _password = dt.password;
      print('Нашли данные по ключу $userInfoKey Логин: $_login Пароль: $_password');
    }

    print('logon......');
    print('Логин: $_login');
    print('Пароль: $_password');
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
  Widget build(BuildContext context) {
    print('LogIn $logIn');
    //httpGetUserData();
    //print('LogIn $logIn');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // darkTheme: ThemeData(
      //   colorSchemeSeed: Colors.black12,
      //   brightness: Brightness.dark,
      //   useMaterial3: true
      // ),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      //   useMaterial3: true,
      // ),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      title: 'Бельетаж>',
        //initialRoute: (logIn == true) ? '/' : '/logon',
        //routes: {
        //  '/': (context, {arguments}) => scrHomeScreen(),
        //  '/logon': (context, {arguments}) => scrLogonScreen(),
        //}
      home: (logIn == true) ? scrHomeScreen(_login) : (_load == true) ? scrLogonScreen() : scrLoadingScreen(),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
