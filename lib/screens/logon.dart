import 'dart:convert';
import 'dart:io';

import 'package:beletag/screens/NewAccount.dart';
import 'package:beletag/screens/about.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:http/http.dart' as http;

import 'package:beletag/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Lists.dart';

class scrLogonScreen extends StatelessWidget {
  const scrLogonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        body: Center(
            child: isSmallScreen
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                  _Logo(),
                  _FormContent(),
              ],
            )
                : Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Row(
                    children: const [
                    Expanded(child: _Logo()),
                    Expanded(
                      child: Center(child: _FormContent()),
                  ),
                ],
              ),
            )));
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    //const String logoPath = 'https://beletag.com/upload/CMax/35c/tw0i3dku7v12n29mwofzdnj5b90k9kn7/logo_aspro.png';
    const String logoPath = 'https://img.acewear.ru/CleverWearImg/logo_aspro.png';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //FlutterLogo(size: isSmallScreen ? 100 : 200),
        Image(image: NetworkImage(logoPath)),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Авторизация по номеру телефона",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  String login = '';
  String password = '';
  bool accountNew = false;

  bool _isPasswordVisible = false;
  String _smskod = '1111';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future httpGetPhoneValidate() async {
    print('Запустилась процедура отправки смс на $login');
    var resp;
    bool success = false;
    bool result = false;
    String message = '';
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/phonevalidate/${login}/', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        message = notesJson['message'] ?? '';
        if (success==true) {
          resp = notesJson['response'] ?? '';
          result = resp['result'];
          _smskod = resp['code'];
          accountNew = resp['new'];
          if (result == false)
            print('Ошибка отправки смс: $message');
        }
        else
          print('Ошибка отправки смс $message');
        print('Присвоен проверочный код $_smskod');
      }
    } catch (error) {
      print("Ошибка при получении смс кода: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhoneFormField(
              key: Key('phone-field'),
              defaultCountry: IsoCode.RU,
              validator: PhoneValidator.validMobile(),
              enabled: !_isPasswordVisible,
              autofocus: !_isPasswordVisible,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Телефон',
                hintText: 'Введите ваш номер телефона',
                //prefixIcon: Icon(Icons.phone),
                icon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              onChanged: (_tel_value) async {
                if (_tel_value!.isValid()) {
                  print('Введено значение телефона : ${_tel_value}');
                  _isPasswordVisible = true;
                  login = '${_tel_value!.countryCode}${_tel_value.nsn}';
                  print(login);
                  ValidatePhone _res = await httpGetPhoneValidateGlobal(login);
                  if (_res !=null) {
                    _smskod = _res.code;
                    accountNew = _res.accountNew;
                    if (_res.result==false)
                      print('Была ошибка при отправке кода');
                    setState(() {
                    });
                  }
                }
              },
            ),
            _gap(),
            if (_isPasswordVisible == true)
                TextFormField(
                  autofocus: _isPasswordVisible,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (login != '79991111111') {
                      if (value != _smskod) {
                        return 'Не совпадает код из смс';
                      }
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                  labelText: 'Код',
                  hintText: 'Введите код из смс',
                  prefixIcon: const Icon(Icons.sms_failed_outlined),
                  border: const OutlineInputBorder(),
                  ),
                    onChanged: (_value_kod) {
                      if (_value_kod.length==4) {
                        print('Введено код из смс : ${_value_kod}');
                        if (_formKey.currentState?.validate() ?? false) {
                          password = _value_kod;
                          setUserInfo(login, password);
                          print('Аутентификация пройдена успешно');
                          //accountNew=true;
                          if (accountNew==true)
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => scrAccountNewScreen(login)), (route) => false,);
                          else
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => scrHomeScreen(login)), (route) => false,);
                        }
                      }
                    },
                  ),
            _gap(),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}

Future<ValidatePhone> httpGetPhoneValidateGlobal(String login) async {
  print('Запустилась процедура отправки смс на $login');
  var resp;
  ValidatePhone res = ValidatePhone(code: '', accountNew: false, result: false);
  bool success = false;
  String message = '';
  var _url=Uri(path: '/c/beletag_bonus/hs/v1/phonevalidate/${login}/', host: 's4.rntx.ru', scheme: 'https');
  var _headers = <String, String> {
    'Accept': 'application/json',
    'Authorization': Globals.anAuthorization
  };
  try {
    var response = await http.get(_url, headers: _headers);
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      success = notesJson['success'] ?? false;
      message = notesJson['message'] ?? '';
      if (success==true) {
        resp = notesJson['response'] ?? '';
        res = ValidatePhone.fromJson(resp);
        // result = resp['result'];
        // _smskod = resp['code'];
        // accountNew = resp['new'];
        if (res.result == false)
          print('Ошибка отправки смс: $message');
      }
      else
        print('Ошибка отправки смс $message');
    }
  } catch (error) {
    print("Ошибка при получении смс кода: $error");
  }
  return res;
}

Future setUserInfo(String name, String pas) async {
  const userInfoKey = 'userInfoKey';

  int themeIndex = Globals.anThemeIndex;

  //сохраняем в глобальные переменные логин и пароль
  Globals.setLogin(name);
  Globals.setPasswodr(pas);

  //сохраняем в локальную БД параметры
  var prefs = await SharedPreferences.getInstance();
  final _userInfo = UserInfo(login: name, password: pas, themeIndex: themeIndex);
  prefs.setString(userInfoKey, json.encode(_userInfo));

  print('Сохранили в ключ $userInfoKey строку: ${json.encode(_userInfo)}');
}