import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:beletag/models/Lists.dart';
import 'package:beletag/components/Cards.dart';
import 'package:http/http.dart' as http;


class scrAboutScreen extends StatefulWidget {
  // final String id;
  scrAboutScreen(); //this.id

  @override
  State<scrAboutScreen> createState() => _scrAboutScreenState();
}

class _scrAboutScreenState extends State<scrAboutScreen> {
  //var objectList = [];
  List <AboutList> objectList = [];
  bool success = false;
  String logoPath = 'https://img.acewear.ru/CleverWearImg/logo_aspro.png';
  String header = '';
  var resp;
  var items = [];

  Future httpGetAbout() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/about/', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        if (success=true) {
          resp = notesJson['response'] ?? '';
          logoPath = resp['logo'];
          header = resp['header'];
          items = resp['items'];
          for (var noteJson in items) {
            objectList.add(AboutList.fromJson(noteJson));
          }
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка магазинов: $error");
    }
  }

  @override
  void initState() {
    httpGetAbout().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('О нас'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image(image: NetworkImage(logoPath)),
          if (header.length>0)
            Text(header,textAlign: TextAlign.center , style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
          Expanded(child:
            ListView.builder(
              padding: EdgeInsets.all(10),
              physics: BouncingScrollPhysics(),
              reverse: false,
              itemCount: objectList.length,
              itemBuilder: (_, index) => CardAboutList(event: objectList[index],),
          )
          ),
        ],
      ),
    );
  }
}

