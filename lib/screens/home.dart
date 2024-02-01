import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:beletag/components/CarsView.dart';
import 'package:beletag/screens/PurchaseList.dart';
import 'package:beletag/screens/ShopsList.dart';
import 'package:beletag/screens/about.dart';
import 'package:beletag/screens/PersonView.dart';
import 'package:beletag/screens/logon.dart';
import 'package:beletag/screens/Settings.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
//import 'package:intl/intl.dart';

class scrHomeScreen extends StatefulWidget {
  final String id;
  scrHomeScreen(this.id);

  @override
  State<scrHomeScreen> createState() => _scrHomeScreenState();
}

class _scrHomeScreenState extends State<scrHomeScreen> {
  bool front = true;

  bool success = false;
  String message = '';
  String cardNumber = '';
  String name = '';
  String secondName = '';
  String barcode = '';
  String phone = '';
  String email = '';
  String gender = 'F';
  DateTime birthday = DateTime.now();
  int level = 1;
  bool blocked = false;
  bool notify_email = false;
  bool notify_sms = false;

  int bonus = 0;
  int bonusTotal = 0;
  int bonusPromo = 0;

  var resp;

  Future httpGetUserData() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/user/${widget.id}/', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        message = notesJson['message'] ?? '';
        resp = notesJson['response'] ?? '';
        cardNumber = resp['card_number'];
        name = resp['name'];
        secondName = resp['second_name'];
        barcode = resp['ean'];
        phone = resp['phone'];
        email = resp['email'];
        level = resp['level'];
        gender = resp['gender'];

        blocked = resp['blocked'];
        notify_email = resp['notify_email'];
        notify_sms = resp['notify_sms'];

        birthday = DateTime.parse(resp['birthday'].toString()) as DateTime;

        print('ответ от сервера: ' + birthday.toString());

      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  Future httpGetUserBonusBalance() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/balanceall/${widget.id}/', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        message = notesJson['message'] ?? '';
        resp = notesJson['response'] ?? '';
        bonusTotal = resp['Total'];
        bonusPromo = resp['OfThemPromo'];
        print('Баланс' + bonusTotal.toString());
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }


  @override
  void initState() {
    httpGetUserData().then((value) {
      httpGetUserBonusBalance().then((value) {
        setState(() {
        });
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    print('cardNumber: $cardNumber, name: $name, secondName: $secondName, bonusTotal: $bonusTotal, bonusPromo: $bonusPromo, barcode: $barcode');
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.transparent,
          title: Text('CleverWear'),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: _ProfileIcon(), backgroundColor: Colors.black,)
            )
          ],
          centerTitle: true,
          //backgroundColor: Colors.grey[900],
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: ListView(
          children: [Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    Image.network('https://img.acewear.ru/CleverWearImg/banner.jpg'),
                    InkWell(
                      child: CreditCardsPage(cardNumber: cardNumber, name: name, secondName: secondName, bonusTotal: bonusTotal, bonusPromo: bonusPromo, barcode: barcode, front: front),
                      onTap: () {
                        setState(() {
                          front = !front;
                        });
                      },
                    ),
                    Card(
                        child: ListTile(
                            title: Text('История покупок', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                            subtitle: Text('Чеки, возвраты, начисления бонусов'),
                            leading: Icon(Icons.currency_ruble_rounded),
                          //trailing: Text('100', style: TextStyle(fontSize: 18, color: Colors.green),),
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => scrPurchaseListScreen(cardNumber)));
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Мои данные', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                    subtitle: Text('Персональные данные'),
                    leading: Icon(Icons.account_circle),
                    //trailing: Text('100', style: TextStyle(fontSize: 18, color: Colors.green),),
                    onTap: () async {
                      //_tripEditModalBottomSheet(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => scrPersonViewScreen('${widget.id}')));
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Магазины', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                    subtitle: Text('Адреса магазинов'),
                    leading: Icon(Icons.maps_home_work_sharp),
                    //trailing: Text('100', style: TextStyle(fontSize: 18, color: Colors.green),),
                    onTap: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => scrShopsListScreen()));
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('О нас', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                    subtitle: Text('Информация'),
                    leading: Icon(Icons.info_outlined),
                    //trailing: Text('100', style: TextStyle(fontSize: 18, color: Colors.green),),
                    onTap: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => scrAboutScreen()));
                    },
                  ),
                )
              ],
            ),
          ),
    ]
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Text('+'),
        // )
        //backgroundColor: Colors.grey[900]),
        );
  }

}


enum Menu { itemInfo, itemSettings, itemOut }

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({Key? key}) : super(key: key);

  static const userInfoKey = 'userInfoKey';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.person, ),
        iconColor: Colors.grey,
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          if (item == Menu.itemOut) {
            var prefs = await SharedPreferences.getInstance();
            prefs.remove(userInfoKey);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => scrLogonScreen()), (route) => false,);
          }
          if (item == Menu.itemSettings) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => scrSettingsScreen()));
          }
          if (item == Menu.itemInfo) {
            showAboutDialog(
              context: context,
              applicationVersion: 'Роганов Владимир',
              applicationIcon: Image.asset('assets/images/logo.png', width: 60),
              //applicationLegalese: 'Разработчик: Роганов Владимир',
              children: <Widget>[
                Text('Приложение для бонусной системы магазинов Бельетаж, Beleta, Clever. '),
                Text('Правила бонусной программы :'),
                InkWell(child: Text('https://cleverwear.ru/#rules', style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),), onTap: () => launchUrlString('https://cleverwear.ru/#rules',mode: LaunchMode.inAppBrowserView),)
              ]
            );
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          const PopupMenuItem<Menu>(
            value: Menu.itemInfo,
            child: Text('О приложении'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.itemSettings,
            child: Text('Настройки'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.itemOut,
            child: Text('Выход из учетной записи'),
          ),
        ]);
  }
}