import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beletag/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'home.dart';


class scrAccountNewScreen extends StatefulWidget {
  final String phone;
  scrAccountNewScreen(this.phone);

  @override
  State<scrAccountNewScreen> createState() => _scrAccountNewScreenState();
}

class _scrAccountNewScreenState extends State<scrAccountNewScreen> {
  //var objectList = [];
  List <AboutList> objectList = [];
  bool success = false;
  String logoPath = 'https://beletag.com/upload/CMax/35c/tw0i3dku7v12n29mwofzdnj5b90k9kn7/logo_aspro.png';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String header = '';
  String gender = 'F';
  bool _notify_email = true;
  bool _notify_sms = true;
  bool _notify_push = true;
  bool _notify_system = true;
  bool _agreement = true;
  DateTime birthday = DateTime(1990);
  var resp;
  var items = [];

  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController _last_nameController = TextEditingController(text: '');
  TextEditingController _second_nameController = TextEditingController(text: '');
  TextEditingController _emailController = TextEditingController(text: '');


  Future httpCreateCard() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/user/add/', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    var _body = <String, String> {
      "name": _nameController.text,
      "last_name": _last_nameController.text,
      "second_name": _second_nameController.text,
      "phone": widget.phone,
      "active": true.toString(),
      "electron": true.toString(),
      "email": _emailController.text,
      "gender": gender,
      "birthday": birthday.toString(),
      "notify_email": _notify_email.toString(),
      "notify_sms": _notify_sms.toString(),
      "notify_systempush": _notify_system.toString(),
      "notify_push": _notify_push.toString()
    };
    try {
      var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
      if (response.statusCode == 200 || response.statusCode == 400) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        String _message = notesJson['message'] ?? '';
        print(_message);
        print(notesJson.toString());
        if (success==true) {

        }
        else {
          print(resp.toString());
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_message), backgroundColor: Colors.red,));
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка магазинов: $error");
    }
  }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
        centerTitle: true,
      ),
      body: ListView(
          children: [Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(image: NetworkImage(logoPath)),
              Container(
                padding: EdgeInsets.only(left: 8, top: 8,right: 8, bottom: 26),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(decoration: InputDecoration(label: Text(widget.phone), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: Icon(Icons.phone)), enabled: false,),
                        SizedBox(height: 8,),
                        TextFormField(controller: _last_nameController,decoration: InputDecoration(label: Text('Фамилия'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: Icon(Icons.person)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Фамилия не должна быть пустой';
                              }
                              return null;
                            }),
                        SizedBox(height: 8,),
                        TextFormField(controller: _nameController, decoration: InputDecoration(label: Text('Имя'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: Icon(Icons.person)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Имя не должна быть пустым';
                              }
                              return null;
                            }),
                        SizedBox(height: 8,),
                        TextFormField(controller: _second_nameController,  decoration: InputDecoration(label: Text('Отчество'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: Icon(Icons.person)),),
                        SizedBox(height: 8,),
                        ListTile(leading: Icon(Icons.calendar_month), title: Text(DateFormat('dd.MM.yyyy').format(birthday).toString()),
                        onTap: () async {
                          DateTime? pickeddate = await showDatePicker(locale: Locale("ru", "RU"), context: context, initialDate: birthday, firstDate: DateTime(1950), lastDate: DateTime(2015));
                          if (pickeddate != null) {
                            setState(() {
                              birthday = pickeddate;
                            });
                          }
                        },
                        ),
                        TextFormField(controller: _emailController, decoration: InputDecoration(label: Text('E-mail'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: Icon(Icons.person)),),
                        SizedBox(height: 8,),
                        //Text('Пол'),
                        Row(
                          children: [
                            Flexible(
                              child: RadioListTile(title: Text('Женский'), value: 'F', groupValue: gender, onChanged: (value){
                                setState(() {
                                  gender = value!;
                                });
                              }
                              ),
                            ),
                            Flexible(
                              child: RadioListTile(title: Text('Мужской'), value: 'M', groupValue: gender, onChanged: (value) {
                                setState(() {
                                  gender = value!;
                                });
                              }
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        ListTile(title: Text('Разрешить Push уведомления с иформацией о бонусах, сроках действия, дополнительных начислениях.'), trailing: CupertinoSwitch(value: _notify_system, onChanged: (bool val) => setState(() => _notify_system = val))),
                        Divider(),
                        Text('Подписка на рассылку о скидках и акциях', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                        ListTile(title: Text('E-mail рассылка'), trailing: CupertinoSwitch(value: _notify_email, onChanged: (bool val) => setState(() => _notify_email = val))),
                        ListTile(title: Text('SMS рассылка'), trailing: CupertinoSwitch(value: _notify_sms, onChanged: (bool val) => setState(() => _notify_sms = val))),
                        ListTile(title: Text('Push уведомления'), trailing: CupertinoSwitch(value: _notify_push, onChanged: (bool val) => setState(() => _notify_push = val))),
                        Divider(),
                        ListTile(title: Text('Подписываясь на рассылку, вы соглашаетесь с Политикой конфиденциальности.'), trailing: Icon(Icons.navigate_next_outlined),
                        onTap: () => launchUrlString('https://cleverwear.ru/privacy_policy.html',mode: LaunchMode.inAppBrowserView),),
                        // CheckboxListTile(
                        //     value: _agreement,
                        //     title: new Text('Даю согласие на обработку и хранение моих персональных данных.'),
                        //     onChanged: (value) {setState(() => _agreement = value!);}
                        // ),
                        ListTile(title: Text('Нажимая на кнопку "Зарегистрироваться", вы даете согласие на обработку и хранение своих персональных данных и подтверждаете, что ознакомлены с Политикой конфиденциальности'),),
                        ElevatedButton(
                          child: Text('Зарегистрироваться', style: TextStyle(fontSize: 20)),
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow)),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (birthday.compareTo(DateTime(1950)) == -1)
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Не верно указана дата рождения'), backgroundColor: Colors.red,));
                                else {
                                  if (_agreement == false)
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Нужно разрешение на обработку персональных данных'), backgroundColor: Colors.red,));
                                  else {
                                    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Данные сохраняются'), backgroundColor: Colors.green,));
                                    print('Данные введены правильно');
                                    httpCreateCard().then((value) {
                                      if (success==true)
                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => scrHomeScreen(widget.phone)), (route) => false,);
                                    });
                                  }
                                }
                              }
                            }
                        ),
                      ],
                    )
                ),
              )
            ],
          ),
          ]
      ),
    );
  }
}

