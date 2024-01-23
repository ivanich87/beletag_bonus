import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:beletag/models/Lists.dart';
import 'package:beletag/components/Cards.dart';
import 'package:http/http.dart' as http;


class scrBonusTransactionScreen extends StatefulWidget {
  final String id;
  scrBonusTransactionScreen(this.id);

  @override
  State<scrBonusTransactionScreen> createState() => _scrBonusTransactionScreenState();
}

class _scrBonusTransactionScreenState extends State<scrBonusTransactionScreen> {
  var objectList = [];
  bool success = false;
  var resp = [];

  Future httpGetTransactionsList() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/transactions/${widget.id}/', host: 's4.rntx.ru', scheme: 'https');
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
            objectList.add(TransactionList.fromJson(noteJson));
          }
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  @override
  void initState() {
    httpGetTransactionsList().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Бонусы'),
        centerTitle: true,
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        physics: BouncingScrollPhysics(),
        reverse: false,
        itemCount: objectList.length,
        itemBuilder: (_, index) => CardTransactionList(event: objectList[index],),
      ),
    );
  }
}

