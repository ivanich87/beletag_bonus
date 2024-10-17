//import 'dart:html';
import 'dart:async';
import 'dart:io' as IO;
import 'package:beletag/components/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:beletag/models/Lists.dart';
import 'package:flutter/material.dart';
import 'package:beletag/screens/home.dart';
import 'package:beletag/screens/logon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_api_availability/google_api_availability.dart';
//import 'package:beletag/components/firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GooglePlayServicesAvailability availability = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
  if (IO.Platform.isAndroid) {
    //print('availability = ${availability.value}');
    if (availability.value==0)
      await Firebase.initializeApp(options: FirebaseOptions(apiKey: 'AIzaSyAB5uYf1fmyAJF4yLBRL3UJ4AA6-O8Gc_M', appId: '1:84640627710:android:b1934e3f8ed9c6959e1eaf', messagingSenderId: '84640627710', projectId: 'cleverwear-ec068'));
  }
  else
    await Firebase.initializeApp();

  if (IO.Platform.isAndroid && availability.value==0) {
    try {
      await FirebaseApi().initNotification().timeout(Duration(seconds: 5));
    } on TimeoutException catch (_) {
      print('Timed out');
    }
  }

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
  bool _requireConsent = false;
  bool _enableConsentButton = false;
  String _debugLabelString = "";
  //final connectivityResult = (Connectivity().checkConnectivity());
  bool isOnline = true;

  bool _load = false;
  String _login = '';
  String _password = '';

  bool success = false;
  String message = '';
  bool logIn = false;

  int themeIndex = 0;


  Future httpGetUserData() async {
    _load = false;
    var prefs = await SharedPreferences.getInstance();
    final String? Inf = prefs.getString(userInfoKey);
    if (Inf == null) {
      _login = '';
      _password = '';
      //_load = true;
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

    String _platform = '';
    if (IO.Platform.isAndroid)
      _platform = 'android';
    if (IO.Platform.isIOS)
      _platform = 'ios';

    Globals.setPlatform(_platform);

    var _url=Uri(path: '/c/beletag_bonus/hs/v1/logon/', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    var _body = <String, String> {
      "login": _login,
      "password": _password
    };

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      isOnline = true;
      try {
        var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
        if (response.statusCode == 200) {
          var notesJson = json.decode(response.body);
          success = notesJson['success'] ?? false;
          message = notesJson['message'] ?? '';
          logIn = notesJson['response'] ?? false;
          _load = true;
          print('Ответ авторизации: $logIn Текст ответа: $message');
        }
      } catch (error) {
        print("Ошибка при формировании списка: $error");
        _load = false;
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ошибка подключения к серверу: $error"), backgroundColor: Colors.red,));
      }
    }
    else {
      print('Нет инета');
      _load = false;
      isOnline = false;
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Нет подключения к интернету"), backgroundColor: Colors.red,));
    }
  }

  @override
  void initState() {
    httpGetUserData().then((value) {
      print('111111111111');
      //_load = true;
      setState(() {
      });
    });
    // TODO: implement initState
    //super.initState();
    //initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    ChangeNotifierProvider((ref) {
      final _themeNotifier = ref.watch(themeNotifierProvider);
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),  //code
        Locale('ru', ''), // arabic, no country code
      ],

      theme: ThemeData.light().copyWith( cardTheme: CardTheme(color: Colors.grey[200]), dividerColor: Colors.black, textTheme: Typography().black.apply(fontFamily: 'Montserrat')),
      darkTheme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.grey[500], dividerColor: Colors.white, textTheme: Typography().white.apply(fontFamily: 'Montserrat')), //grey[850]
      themeMode: ThemeMode.values[themeIndex],
      title: 'Бельетаж',

      home: (logIn == true) ? scrHomeScreen(_login) : (_load == true) ? scrLogonScreen() : _scrLoadingScreen(),
    );
  }

  _scrLoadingScreen() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi)
          if (isOnline!=true)
            Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Ошибка 404.', style: TextStyle(fontSize: 24, color: Colors.white, decorationThickness: 0), ),
                Text('Нет интернета на устройстве или вы не предоставили разрешение на использование интернета. Предоставьте доступ к интернету и перезапустите приложение', style: TextStyle(fontSize: 24, color: Colors.white, decorationThickness: 0), ),
                SizedBox(height: 20,),
                Container(color: Colors.white30,
                  child: IconButton(color: Colors.red, onPressed: () {
                    initState();
                    }, icon: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.refresh, size: 36, color: Colors.white, ),
                      Text(' Обновить', style: TextStyle(color: Colors.white, fontSize: 24),),

                  ],)),
                )
              ],
            )

          else
            Image.asset('assets/images/cleverwear.png', width: 250, color: Colors.white),
          //Text('Загрузка данных'),
        ],
      ),
    );
  }

}

