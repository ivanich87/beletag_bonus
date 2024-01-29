import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:beletag/models/Lists.dart';
import 'package:beletag/components/Cards.dart';
import 'package:http/http.dart' as http;


class scrShopsListScreen extends StatefulWidget {
  // final String id;
  scrShopsListScreen(); //this.id

  @override
  State<scrShopsListScreen> createState() => _scrShopsListScreenState();
}

class _scrShopsListScreenState extends State<scrShopsListScreen> {
  //var objectList = [];
  List <ShopsList> objectList = [];
  List <ShopsList> objectListFiltered = [];
  bool _isActive = false;
  bool success = false;
  var resp = [];

  Future httpGetListObject() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/shops/', host: 's4.rntx.ru', scheme: 'https');
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
            objectList.add(ShopsList.fromJson(noteJson));
          }
          objectList.sort((a, b) => a.address.compareTo(b.address));
          objectListFiltered = objectList;
          }
      }
    } catch (error) {
      print("Ошибка при формировании списка магазинов: $error");
    }
  }

  void _findList(value) {
    setState(() {
      objectListFiltered = objectList.where((element) => element.address.toLowerCase().contains(value.toLowerCase())).toList();
    });
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
          title: SearchBar(),
          //centerTitle: true,
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: objectListFiltered.length,
          itemBuilder: (_, index) => CardShopsList(event: objectListFiltered[index],),
        ),
    );
  }

  SearchBar() {
    return Row(
      children: [
        if (!_isActive)
          Text("Магазины",
              style: Theme.of(context).appBarTheme.titleTextStyle),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: (_isActive==true)
                  ? Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(4.0)),
                   child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Введите строку для поиска',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isActive = false;
                              objectListFiltered = objectList;
                              print('Сбросили фильтр');
                            });
                          },
                          icon: const Icon(Icons.close))),
                  onChanged: (value) {
                    _findList(value);
                  },
                ),
              )
                  : IconButton(
                    onPressed: () {
                      setState(() {
                        _isActive = true;
                      });
                    },
                    icon: const Icon(Icons.search)),
            ),
          ),
        ),
      ],
    );
  }
}

