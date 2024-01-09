import 'dart:convert';
import 'package:beletag/components/CarsView.dart';
import 'package:beletag/screens/PurchaseList.dart';
import 'package:beletag/screens/ShopsList.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';

class scrHomeScreen extends StatefulWidget {
  scrHomeScreen();

  @override
  State<scrHomeScreen> createState() => _scrHomeScreenState();
}

class _scrHomeScreenState extends State<scrHomeScreen> {

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
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/user/89229220315/', host: 's4.rntx.ru', scheme: 'https');
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
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/balanceall/89229220315/', host: 's4.rntx.ru', scheme: 'https');
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
    httpGetUserBonusBalance();
    httpGetUserData().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CleverWear'),
          centerTitle: true,
          //backgroundColor: Colors.grey[900],
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          //actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CreditCardsPage(cardNumber: cardNumber, name: name, secondName: secondName, bonusTotal: bonusTotal, bonusPromo: bonusPromo, barcode: barcode),
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
                    //final result =
                    //    await Navigator.pushNamed(context, '/cashHome', arguments: {'summa': 100});
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
                    //final result =
                    //    await Navigator.pushNamed(context, '/cashHome', arguments: {'summa': 100});
                  },
                ),
              )
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Text('+'),
        // )
        //backgroundColor: Colors.grey[900]),
        );
  }
}
