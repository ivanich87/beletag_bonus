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
          }
      }
    } catch (error) {
      print("Ошибка при формировании списка магазинов: $error");
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
          title: const SearchBar(),
          //centerTitle: true,
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: objectList.length,
          itemBuilder: (_, index) => CardShopsList(event: objectList[index],),
        ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
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
              child: _isActive
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
                            });
                          },
                          icon: const Icon(Icons.close))),
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