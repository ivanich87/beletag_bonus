import 'dart:convert';

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
  var objectList = [];
  bool success = false;
  var resp = [];

  Future httpGetListObject() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/checks/${widget.id}/', host: 's4.rntx.ru', scheme: 'https');
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
            objectList.add(PurchaseList.fromJson(noteJson));
          }
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Покупки'),
          centerTitle: true,
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: objectList.length,
          itemBuilder: (_, index) => CardObjectList(event: objectList[index],),
        ),
    );
  }
}

