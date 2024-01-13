import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class scrPersonViewScreen extends StatefulWidget {
   final String id;
  scrPersonViewScreen(this.id);

  @override
  State<scrPersonViewScreen> createState() => _scrPersonViewScreenState();
}

class _scrPersonViewScreenState extends State<scrPersonViewScreen> {
  bool success = false;
  var resp;
  String name = '';
  String last_name = '';
  String second_name = '';
  String phone = '';
  String email = '';
  bool confirmed_email = false;
  String gender = '';
  DateTime birthday = DateTime(2024);
  bool notify_email = false;
  bool notify_sms = false;
  bool notify_push = false;
  int level = 0;
  bool blocked = false;

  Future httpGetObject() async {
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/user/${widget.id}', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      print('Запуск');
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        if (success=true) {
          resp = notesJson['response'] ?? '';
          name = resp['name'];
          last_name = resp['last_name'];
          second_name = resp['second_name'];
          phone = resp['phone'];
          email = resp['email'];
          confirmed_email = resp['confirmed_email'];
          gender = resp['gender'];
          //birthday = DateTime.tryParse(resp['birthday']));
          birthday = DateTime.tryParse(resp['birthday']) ?? DateTime(2023);
          notify_email = resp['notify_email'];
          notify_sms = resp['notify_sms'];
          level = resp['level'];
        }
      }
    } catch (error) {
      print("Ошибка при формировании данных пользователя: $error");
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
        title: Text('Персональные данные'),
        centerTitle: true,
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
        child: ListView(
            children: [
              _CustomHeader(title: 'ФИО'),
              ListTile(leading: Icon(Icons.manage_accounts_rounded), title: _CustomText(title: '$last_name $name $second_name'), trailing: IconButton(icon: Icon(Icons.edit), onPressed: ()=>_tripEditModalBottomSheet(context, _tripEditWidgets(1)),)),
              Divider(color: Colors.white, thickness: 2, ),
              //SizedBox(height: 10,),
              _CustomHeader(title: 'Телефон'),
              ListTile(leading: Icon(Icons.phone, color: Colors.green), title: _CustomText(title: '$phone'), trailing: IconButton(icon: Icon(Icons.edit), onPressed: ()=>_tripEditModalBottomSheet(context, _tripEditWidgets(2)),)),
              Divider(color: Colors.white, thickness: 2),
              //SizedBox(height: 10,),
              _CustomHeader(title: 'E-mail'),
              ListTile(leading: (confirmed_email ? Icon(Icons.mark_email_read, color: Colors.green) : Icon(Icons.mark_email_unread_rounded, color: Colors.red)), title: _CustomText(title: '$email'), trailing: IconButton(icon: Icon(Icons.edit), onPressed: ()=>_tripEditModalBottomSheet(context, _tripEditWidgets(3)),)),
              Divider(color: Colors.white, thickness: 2),
              //SizedBox(height: 10,),
              _CustomHeader(title: 'День рождения'),
              ListTile(leading: Icon(Icons.calendar_month), title: _CustomText(title: DateFormat('dd.MM.yyyy').format(birthday).toString()), trailing: IconButton(icon: Icon(Icons.edit), onPressed: () async { //_tripEditModalBottomSheet(context, _tripEditWidgets(4))
                DateTime? pickeddate = await showDatePicker(context: context, initialDate: birthday, firstDate: DateTime(1940), lastDate: DateTime(2015));
                if (pickeddate != null) {
                  setState(() {
                    birthday = pickeddate;
                  });
                }
              },)),
              Divider(color: Colors.white, thickness: 2),
              //SizedBox(height: 10,),
              _CustomHeader(title: 'Пол'),
              ListTile(leading: (gender=='F') ? Icon(Icons.female, color: Colors.pinkAccent,) : Icon(Icons.male, color: Colors.lightBlue), title: _CustomText(title: (gender=='F') ? 'Женский' : 'Мужской'), trailing: IconButton(icon: Icon(Icons.edit), onPressed: ()=>_tripEditModalBottomSheet(context, _tripEditWidgets(5)),)),
              Divider(color: Colors.white, thickness: 2),
              //SizedBox(height: 10,),
              _CustomHeader(title: 'Разрешить рассылку'),
              ListTile(enabled: confirmed_email, leading: Icon(Icons.email_outlined), title: Text('E-mail рассылка'), trailing: CupertinoSwitch(value: notify_email, onChanged: (value) {
                setState(() {
                  if (confirmed_email)
                    notify_email = value;
                });
              },)),
              ListTile(leading: Icon(Icons.sms), title: Text('SMS рассылка'), trailing: CupertinoSwitch(value: notify_sms, onChanged: (value) {
                setState(() {
                  notify_sms = value;
                });
              },)),
              ListTile(enabled: false, leading: Icon(Icons.message), title: Text('Push в приложении'), trailing: CupertinoSwitch( value: notify_push, onChanged: (value) {

              },)),
              Divider(color: Colors.white, thickness: 2),
              //SizedBox(height: 10,),
            ],
        ),
      ),
    );
  }

  void _tripEditModalBottomSheet(BuildContext context, Widget type) {
    showModalBottomSheet(isScrollControlled: true, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), context: context, builder: (BuildContext bc) {
      return Container(
        height: 600,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: type,
        ),
      );

    });
  }

  Widget _tripEditWidgets(int i) {
    GlobalKey _formKey= new GlobalKey<FormState>();
    TextEditingController _nameController = TextEditingController(text: name);
    TextEditingController _last_nameController = TextEditingController(text: last_name);
    TextEditingController _second_nameController = TextEditingController(text: second_name);

    TextEditingController _phoneController = TextEditingController(text: phone);

    TextEditingController _emailController = TextEditingController(text: email);

    final _style = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.grey),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      minimumSize: MaterialStateProperty.all(Size(250, 40))
    );

    void _SaveDataFIO() {
      setState(() {
        if (_nameController.text.length<2)
          print('Имя не заполнено');
        if (_last_nameController.text.length<2)
          print('Фамилия не заполнено');
        if (_second_nameController.text.length<2)
          print('Отчество не заполнено');

        last_name = _last_nameController.text;
        name = _nameController.text;
        second_name = _second_nameController.text;
      });
      Navigator.pop(context);
    }

    void _SaveDataPhone() {
      setState(() {
        if (_phoneController.text.length<2)
          print('Почта не заполнена');

        phone = _phoneController.text;
      });
      Navigator.pop(context);
    }

    void _SaveDataEmail() {
      setState(() {
        if (_emailController.text.length<2)
          print('Почта не заполнена');

        email = _emailController.text;
      });
      Navigator.pop(context);
    }

    void _SaveDataBirday() {
      setState(() {

      });
      Navigator.pop(context);
    }

    if (i==1) { //фио
      return Form(
        key: _formKey,
        //autovalidateMode: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              autofocus: true,
              controller: _last_nameController,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), labelText: 'Фамилия'),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) => valid(value),
              controller: _nameController,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), labelText: 'Имя'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _second_nameController,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), labelText: 'Отчество'),
            ),
            SizedBox(height: 20),
            Container(alignment: Alignment.center,child: ElevatedButton(onPressed: _SaveDataFIO, child: Text('Сохранить'), style: _style, )),
          ],
        ),
      );
    };
    if (i==2) {
      return Column(
        children: [
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), labelText: 'Телефон'),
          ),
          SizedBox(height: 20),
          Container(alignment: Alignment.center,child: ElevatedButton(onPressed: _SaveDataPhone, child: Text('Сохранить'), style: _style, )),
        ],
      );
    };
    if (i==3) {
      return Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), labelText: 'E-Mail'),
          ),
          SizedBox(height: 20),
          Container(alignment: Alignment.center,child: ElevatedButton(onPressed: _SaveDataEmail, child: Text('Сохранить'), style: _style, )),
        ],
      );
    };
    if (i==4) {
      return Column(
        children: [
          TextFormField(
            initialValue: birthday.toString(),
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), labelText: 'E-Mail'),
          ),
          SizedBox(height: 20),
          Container(alignment: Alignment.center,child: ElevatedButton(onPressed: _SaveDataBirday, child: Text('Сохранить'), style: _style, )),
        ],
      );
    };
    if (i==5) {
      return Column(
        children: [
          //ListTile(leading: Icon(Icons.female, color: Colors.pinkAccent,), title: Text('Женский')),
          //ListTile(leading: Icon(Icons.male, color: Colors.lightBlue), title: Text('Мужской')),
          RadioListTile(secondary: Icon(Icons.female, color: Colors.pinkAccent,), title: Text('Женский'), value: 'F', groupValue: gender, onChanged: (value){
            setState(() {
              gender = value!;
              Navigator.pop(context);
            });
          }
          ),
          RadioListTile(secondary: Icon(Icons.male, color: Colors.lightBlue,), title: Text('Мужской'), value: 'M', groupValue: gender, onChanged: (value) {
            setState(() {
              gender = value!;
              Navigator.pop(context);
            });
          }),
        ],
      );
    };
    return Text('Ошибочные данные');
  }
}

valid(String? value) {
  return value
      !.trim()
      .length > 0 ? null : 'Имя пользователя не может быть пустым';
}





class _CustomHeader extends StatelessWidget {
  final String title;
  const _CustomHeader(
      {Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
    );
  }
}
