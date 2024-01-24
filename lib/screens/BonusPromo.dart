import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:beletag/models/Lists.dart';
import 'package:beletag/components/Cards.dart';
import 'package:http/http.dart' as http;


class scrBonusPromoScreen extends StatefulWidget {
  final String id;
  final String sums;
  scrBonusPromoScreen(this.id, this.sums);

  @override
  State<scrBonusPromoScreen> createState() => _scrBonusPromoScreenState();
}

class _scrBonusPromoScreenState extends State<scrBonusPromoScreen> {
  List <BonusPromoBalanceList> objectList = [];
  bool success = false;
  var resp = [];

  Future httpGetPromoList() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/balancedetail/${widget.id}/', host: 's4.rntx.ru', scheme: 'https');
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
          resp = notesJson['response'] ?? '';
          for (var noteJson in resp) {
            objectList.add(BonusPromoBalanceList.fromJson(noteJson));
          }
          objectList.sort((a, b) => a.dt.compareTo(b.dt));
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  @override
  void initState() {
    httpGetPromoList().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детализация бонусов'),
        centerTitle: true,
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Скоро сгорят: ', style: TextStyle(fontSize: 24)),
                Text('${widget.sums} руб', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Остатки бонусов, начисляемых по промо-акциям, автоматически списываются после истечения их срока действия', style: TextStyle(fontSize: 16)),
          ),
          Divider(),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              padding: EdgeInsets.all(10),
              physics: BouncingScrollPhysics(),
              reverse: false,
              itemCount: objectList.length,
              itemBuilder: (_, index) => CardBonusPromoList(event: objectList[index],),
            ),
          ),
        ],
      ),
    );
  }
}

