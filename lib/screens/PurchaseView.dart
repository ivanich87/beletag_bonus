import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:beletag/models/Lists.dart';
import 'package:beletag/components/Cards.dart';
import 'package:http/http.dart' as http;


class scrPurchaseListScreen extends StatefulWidget {
  final String id;
  scrPurchaseListScreen(this.id);

  @override
  State<scrPurchaseListScreen> createState() => _scrPurchaseListScreenState();
}

class _scrPurchaseListScreenState extends State<scrPurchaseListScreen> {
  var resp;
  var itemTovar;
  var itemBonus;
  var itemTovarList = [];
  var itemBonusList = [];

  bool success = false;
  String number = '';
  DateTime dt = DateTime(2024);
  num summaMax = 0;
  num summa = 0;
  num summaSale = 0;
  String comment = '';
  int shopId = 0;
  String shopName = '';
  String shopAddress = '';
  num bonusDec = 0;
  num bonusAdd = 0;
  num bonus = 0;

  Future httpGetListObject() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/check/?id=${widget.id}/', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        if (success=true) {
          resp = notesJson['response'] ?? [];
          number = resp['number'];
          dt = DateTime.parse(resp['dt']);
          summaMax = resp['summaMax'];
          summa = resp['summa'];
          summaSale = resp['summaSale'];
          comment = resp['comment'];
          shopId = resp['shopId'];
          shopName = resp['shopName'];
          shopAddress = resp['shopAddress'];
          bonusDec = resp['bonusDec'];
          bonusAdd = resp['bonusAdd'];
          bonus = resp['bonus'];

          itemTovar = resp['itemTovar'];
          for (var noteJson in itemTovar) {
            itemTovarList.add(ItemTovarList.fromJson(noteJson));
          }
          itemBonus = resp['itemBonus'];
          for (var noteJson in itemBonus) {
            itemBonusList.add(ItemBonusList.fromJson(noteJson));
          }
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка1: $error");
    }
  }

  @override
  void initState() {
    httpGetListObject().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: itemBonusList.length>0 ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Чек № $number'),
          bottom: TabBar(tabs: itemBonusList.length>0 ? _tabs3 : _tabs2),
          centerTitle: true,
        ),
        body: TabBarView(children: <Widget> [
          _PageTitle(number: number, dt: dt, summaMax: summaMax, summa: summa, summaSale: summaSale, comment: comment, shopId: shopId, shopName: shopName, shopAddress: shopAddress, bonusDec: bonusDec, bonusAdd: bonusAdd, bonus: bonus),
          _PageItemTovar(itemList: itemTovarList,),
          if (itemBonusList.length>0)
            _PageItemBonus(itemList: itemBonusList,),
        ]
        ),
      ),
    );
  }
}


const _tabs3 = [
  Tab(icon: Icon(Icons.home_rounded), text: "Основное"),
  Tab(icon: Icon(Icons.shopping_bag_rounded), text: "Состав"),
  Tab(icon: Icon(Icons.percent), text: "Промо-бонусы"),
];

const _tabs2 = [
  Tab(icon: Icon(Icons.home_rounded), text: "Основное"),
  Tab(icon: Icon(Icons.shopping_bag_rounded), text: "Состав"),
];

class _PageTitle extends StatelessWidget {
  final String number;
  final DateTime dt;
  final num summaMax;
  final num summa;
  final num summaSale;
  final String comment;
  final int shopId;
  final String shopName;
  final String shopAddress;
  final num bonusDec;
  final num bonusAdd;
  final num bonus;

  const _PageTitle(
      {Key? key, required this.number, required this.dt, required this.summaMax, required this.summa, required this.summaSale, required this.comment, required this.shopId, required this.shopName, required this.shopAddress, required this.bonusDec, required this.bonusAdd, required this.bonus})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.white60),
        _TitleRowText(caption: 'Номер чека', value: number),
        _TitleRowText(caption: 'Дата чека', value: DateFormat('dd.MM.yyyy').format(dt)),
        Divider(color: Colors.white60, thickness: 2),
        _TitleRowText(caption: 'Магазин', value: shopName),
        SizedBox(height: 5),
        Text('$shopAddress', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, color: Colors.white60)),
        Divider(color: Colors.white60, thickness: 2),
        _TitleRowText(caption: 'Бонусов списано', value: bonusDec.toString()),
        _TitleRowText(caption: 'Бонусов начислено', value: bonusAdd.toString()),
        Divider(color: Colors.white60, thickness: 2),
        _TitleRowText(caption: 'Сумма (без скидки)', value: NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(summaMax)),
        _TitleRowText(caption: 'Cкидка', value: NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(summaSale)),
        SizedBox(height: 20),
        Padding(padding: const EdgeInsets.only(top: 10.0, left: 20.0),
          child: Text.rich(TextSpan(children: [
            TextSpan(text: 'Итого: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, fontFamily: 'CourrierPrime')),
            TextSpan(text: NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(summa), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          ],
          )
          ),
        )
      ],
    );
  }
}

class _TitleRowText extends StatelessWidget {
  final String caption;
  final String value;

  const _TitleRowText(
      {Key? key, required this.caption, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 8.0),
      child:
      Text.rich(TextSpan(children: [
        TextSpan(text: '$caption: ', style: TextStyle(fontSize: 22, fontFamily: 'CourrierPrime')),
        TextSpan(text: '$value', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white60)),
      ],
      )
      ),
    );
  }
}

class _PageItemTovar extends StatelessWidget {
  final List itemList;
  const _PageItemTovar(
      {Key? key, required this.itemList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      reverse: false,
      itemCount: itemList.length,
      itemBuilder: (_, index) => CardItemTovarList(event: itemList[index],),
    );
  }
}

class _PageItemBonus extends StatelessWidget {
  final List itemList;
  const _PageItemBonus(
      {Key? key, required this.itemList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      reverse: false,
      itemCount: itemList.length,
      itemBuilder: (_, index) => CardItemBonusList(event: itemList[index],),
    );
  }
}