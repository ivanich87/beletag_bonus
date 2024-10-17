import 'dart:math' as math;

import 'package:beletag/screens/Docs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

import '../models/Lists.dart';
import 'package:screen_brightness/screen_brightness.dart';
//import 'package:intl/intl.dart';

class scrHomeScreen extends StatefulWidget {
  final String id;
  scrHomeScreen(this.id);

  @override
  State<scrHomeScreen> createState() => _scrHomeScreenState();
}

class _scrHomeScreenState extends State<scrHomeScreen> with SingleTickerProviderStateMixin {
  bool _isFront = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  double _currentBrightness = 0;
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

  Future httpSetUserData() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/userproperty/', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var _body = <String, String> {
        "login": Globals.anLogin,
        "fcm": Globals.anFCM,
        "platform": Globals.anPlatform
      };

      var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        message = notesJson['message'] ?? '';
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  Future httpGetUserData() async {
    _currentBrightness = await currentBrightness;
    setBrightness(0.9);

    var _url=Uri(path: '/c/beletag_bonus/hs/v1/user/${widget.id}/', host: 's4.rntx.ru', scheme: 'https');
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
      if (Theme.of(context).brightness == Brightness.dark)
        Globals.anIsDarkTheme=true;
      else
        Globals.anIsDarkTheme=false;
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  Future httpGetUserBonusBalance() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/balanceall/${widget.id}/', host: 's4.rntx.ru', scheme: 'https');
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
        resp = notesJson['response'] ?? '';
        bonusTotal = resp['Total'];
        bonusPromo = resp['OfThemPromo'];
        print('Баланс' + bonusTotal.toString());

      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  Future<double> get currentBrightness async {
    try {
      return await ScreenBrightness().current;
    } catch (e) {
      print(e);
      throw 'Failed to get current brightness';
    }
  }
  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      print(e);
      throw 'Failed to set brightness';
    }
  }

  @override
  void initState() {
    httpGetUserData().then((value) {
      httpGetUserBonusBalance().then((value) {
        httpSetUserData();
        setState(() {
        });
      });
    });
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    setupInteractedMessage();
  }

  @override
  void dispose() {
    _controller.dispose();
    setBrightness(_currentBrightness);
    super.dispose();
  }

  void _flipCard() {
    if (_controller.status != AnimationStatus.forward) {
      if (_isFront) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      _isFront = !_isFront;
    }
    httpGetUserBonusBalance();
  }

  Widget build(BuildContext context) {
    print(barcode);
    print('Текущая яркость: ${_currentBrightness}');
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.transparent,
          title: Text('Clever Wear'),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: _ProfileIcon(), backgroundColor: Colors.black26)
            )
          ],
          centerTitle: true,
          //backgroundColor: Colors.grey[900],
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        backgroundColor: Colors.grey[200],

        body: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                      Image.network('https://img.acewear.ru/CleverWearImg/banner.jpg'),
                      InkWell(
                        child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(_animation.value * math.pi),
                            child: CreditCardsPage(cardNumber: cardNumber, name: name, secondName: secondName, bonusTotal: bonusTotal, bonusPromo: bonusPromo, barcode: getBarcode(barcode, widget.id), front: _isFront),
                        ),
                        onTap: () {
                          _flipCard();
                        },
                      ),
                      Card(color: Colors.white60,
                          child: ListTile(
                              title: Text('История покупок', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),),
                              subtitle: Text('Чеки, возвраты, бонусы', style: TextStyle(color: Colors.black)),
                              leading: Icon(Icons.currency_ruble_rounded, color: Colors.black),
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => scrPurchaseListScreen(cardNumber)));
                      },
                    ),
                  ),
                  Card(color: Colors.white60,
                    child: ListTile(
                      title: Text('Акции и новости', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),),
                      subtitle: Text('Посмотреть все акции', style: TextStyle(color: Colors.black)),
                      leading: Icon(Icons.discount, color: Colors.black),
                      onTap: () async {
                        launchUrlString('https://beletag.com/sale/', mode: LaunchMode.inAppBrowserView);
                      },
                    ),
                  ),
                  Card(color: Colors.white60,
                    child: ListTile(
                      title: Text('Мои данные', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),),
                      subtitle: Text('Персональные данные', style: TextStyle(color: Colors.black)),
                      leading: Icon(Icons.account_circle, color: Colors.black),
                      onTap: () async {
                        //_tripEditModalBottomSheet(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => scrPersonViewScreen('${widget.id}')));
                      },
                    ),
                  ),
                  Card(color: Colors.white60,
                    child: ListTile(
                      title: Text('Магазины', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),),
                      subtitle: Text('Адреса магазинов', style: TextStyle(color: Colors.black)),
                      leading: Icon(Icons.maps_home_work_sharp, color: Colors.black),
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => scrShopsListScreen()));
                      },
                    ),
                  ),
                  Card(color: Colors.white60,
                    child: ListTile(
                      title: Text('Покупателю', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),),
                      subtitle: Text('Правила и информация', style: TextStyle(color: Colors.black)),
                      leading: Icon(Icons.list_alt, color: Colors.black),
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => scrDocsScreen()));
                      },
                    ),
                  ),
                  Card(color: Colors.white60,
                    child: ListTile(
                      title: Text('О нас', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),),
                      subtitle: Text('Информация', style: TextStyle(color: Colors.black)),
                      leading: Icon(Icons.info_outlined, color: Colors.black),
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => scrAboutScreen()));
                      },
                    ),
                  ),
                  SizedBox(height: 30,),
                  Divider(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              //color: Colors.deepPurpleAccent,
                            ),
                            child:
                              Column(
                                children: [
                                  IconButton(onPressed: () => _makingPhoneCall('88006001185', 1), icon: Icon(Icons.phone_enabled, color: Colors.black),),
                                  Text('8 800 600 11 85', style: TextStyle(color: Colors.black)),
                                  Text('8:00 - 17:00 мск', style: TextStyle(color: Colors.black)),
                                  Text('сб, вск - выходной', style: TextStyle(color: Colors.black)),
                                ],
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          width: 20,
                          thickness: 1,
                          indent: 20,
                          endIndent: 0,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              //color: Colors.deepOrangeAccent,
                            ),
                            child:
                              Column(
                                children: [
                                  IconButton(onPressed: () => _makingPhoneCall('info@cleverwear.ru', 3), icon: Icon(Icons.email, color: Colors.black,),),
                                  Text('info@cleverwear.ru', style: TextStyle(color: Colors.black)),
                                ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: () => _makingPhoneCall('https://vk.com/clewear', 4), icon: Image.asset('assets/images/VK.png', height: 48,)),
                      IconButton(onPressed: () => _makingPhoneCall('https://beletag.com/', 4), icon: Image.asset('assets/images/Site.png', height: 48,)),
                      IconButton(onPressed: () => _makingPhoneCall('https://t.me/cleverwear', 4), icon: Image.asset('assets/images/Telegram.png', height: 48,))
                    ],
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

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    print('Шаг1');
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    print('Шаг2');
    if (initialMessage != null) {
      print('Шаг3');
      _handleMessage(initialMessage);
    }
    print('Шаг4');
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print('Заходим и проверяем было ли какое то действие зашитов в сообщение');
    String _urlMessage = message.data['url'] ?? '';
    if (_urlMessage != '') {
      launchUrlString(_urlMessage, mode: LaunchMode.inAppBrowserView);
      // Navigator.pushNamed(context, '/chat',
      //   arguments: ChatArguments(message),
      // );
    }
  }
}

getBarcode(String ean, String phone) {
  String time = DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);
  String bar = 'ean=' + ean + '&time=' + time + '&phone=' + phone;
  print(bar);
  return bar;
}


enum Menu { itemInfo, itemSettings, itemOut }

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({Key? key}) : super(key: key);

  static const userInfoKey = 'userInfoKey';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.person, ),
        iconColor: Colors.white,
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

_makingPhoneCall(phone, tip) async {
  var url = Uri.parse("tel:$phone");
  if (tip==1) {

  }
  if (tip==2) {
    url = Uri.parse("sms:$phone");
  };
  if (tip==3) {
    url = Uri.parse("mailto:$phone?subject=News&body=New%20plugin");
  };
  if (tip==4) {
    launchUrlString(phone);
  }
  else
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    };
}