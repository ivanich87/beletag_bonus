import 'dart:convert';

import 'package:beletag/models/Lists.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/GeneralFunction.dart';


class scrShopsViewScreen extends StatefulWidget {
   final String id;
  scrShopsViewScreen(this.id);

  @override
  State<scrShopsViewScreen> createState() => _scrShopsViewScreenState();
}

class _scrShopsViewScreenState extends State<scrShopsViewScreen> {
  //var objectList = [];
  //List <ShopsList> objectList = [];
  bool success = false;
  var resp;
  String name = '';
  String address = '';
  String level = '';
  String name_tc = '';
  int brand_id = 0;
  String brand_name = '';
  String phone = '';
  String comment = '';
  int region_id = 0;
  String region_name = '';

  Future httpGetObject() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/shop/${widget.id}', host: 's4.rntx.ru', scheme: 'https');
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
          name = resp['name'];
          address = resp['address'];
          level = resp['level'].toString();
          name_tc = resp['name_tc'];
          brand_name = resp['brand_name'];
          brand_id = resp['brand_id'];
          phone = resp['phone'];
          comment = resp['comment'];
          region_id = resp['region_id'];
          region_name = resp['region_name'];
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка магазинов: $error");
    }
  }

  @override
  void initState() {
    httpGetObject().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация по магазину'),
        centerTitle: true,
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
          children: [
            _CustomHeader(title: name),
            //Text(address, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
              child: _CustomText(title: address),
            ),
            if (name_tc.length>0)
              ListTile(title: _CustomText(title: 'Торговой центр: $name_tc'),),
            if (level!='0')
              ListTile(title: _CustomText(title: 'Этаж: $level'),),
            ListTile(title: _CustomText(title: 'Вывеска: $brand_name'),),
            if (phone.length>0)
              ListTile(title: _CustomText(title: 'Телефон: $phone'), trailing: IconButton(onPressed: () => makingPhoneCall(phone, 1), icon: Icon(Icons.phone_enabled))),
            SizedBox(height: 10,),
            Center(child: _CustomText(title: comment)),
          ],
      ),
    );
  }
}

class _CustomHeader extends StatelessWidget {
  final String title;
  const _CustomHeader(
      {Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _CustomText extends StatelessWidget {
  final String title;
  const _CustomText(
      {Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
    );
  }
}
