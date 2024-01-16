import 'dart:convert';

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
    const String logoPath = 'https://beletag.com/upload/CMax/35c/tw0i3dku7v12n29mwofzdnj5b90k9kn7/logo_aspro.png';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //FlutterLogo(size: isSmallScreen ? 100 : 200),
        Image(image: NetworkImage(logoPath)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Введите номер телефона",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headline6
                : Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.black),
          ),
        )
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
  //TextEditingController _loginController = TextEditingController(text: '');
  //TextEditingController _passwordController = TextEditingController(text: '');
  static const userInfoKey = 'userInfoKey';
  String login = '';
  String password = '';

  bool _isPasswordVisible = false;
  String _smskod = '111';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future _setUserInfo() async {
    var prefs = await SharedPreferences.getInstance();
    final _userInfo = UserInfo(login: login, password: password);
    prefs.setString(userInfoKey, json.encode(_userInfo));

    print('Сохранили в ключ $userInfoKey строку: ${json.encode(_userInfo)}');
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
            TextFormField(
              enabled: !_isPasswordVisible,
              //controller: _loginController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Телефон',
                hintText: 'Введите ваш номер телефона',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_tel_value) {
                print('Введено значение телефона : ${_tel_value}');
                setState(() {
                  _isPasswordVisible = true;
                  _smskod = '4565';
                  login = _tel_value;
                });
              },
            ),
            _gap(),
            if (_isPasswordVisible == true)
                TextFormField(
                  //controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }

                    if (value != _smskod) {
                      return 'Не совпадает код из смс $value <> $_smskod';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                  labelText: 'Код',
                  hintText: 'Введите код из смс',
                  prefixIcon: const Icon(Icons.sms_failed_outlined),
                  border: const OutlineInputBorder(),
                  ),
                    onFieldSubmitted: (_value_kod) {
                      print('Введено код из смс : ${_value_kod}');
                      if (_formKey.currentState?.validate() ?? false) {
                        password = _value_kod;
                        _setUserInfo();
                        print('Аутентификация пройдена успешно');
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => scrHomeScreen(login)), (route) => false,);
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
