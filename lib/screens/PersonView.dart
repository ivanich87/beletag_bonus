import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phone_form_field/phone_form_field.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/Lists.dart';
import 'logon.dart';


class scrPersonViewScreen extends StatefulWidget {
  String id;
  scrPersonViewScreen(this.id);

  @override
  State<scrPersonViewScreen> createState() => _scrPersonViewScreenState();
}

class _scrPersonViewScreenState extends State<scrPersonViewScreen> {
  String _phoneNewNumber='';
  String _smskod = '-1';
  bool _isUserNew = true;
  bool accountNew = false;
  bool _isEmailValid = true;

  bool userDataEdit = false;
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
  DateTime birthday_modify = DateTime(2022);
  bool notify_email = false;
  bool notify_sms = false;
  bool notify_push = false;
  bool notify_systempush = false;
  int level = 0;
  bool blocked = false;
  bool _isPasswordVisible = false;

  Future<bool> httpGetUserNew(newPhone) async {
    bool _res = false;
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/user/${newPhone}/', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200)
        _res = false;
      else
        _res = true;


    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
    return _res;
  }

  Future httpGetObject() async {
    print(widget.id);
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/user/${widget.id}', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    print(_url.path);
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
          _phoneNewNumber = phone;
          email = resp['email'];
          confirmed_email = resp['confirmed_email'];
          gender = resp['gender'];
          birthday = DateTime.tryParse(resp['birthday']) ?? DateTime(2023);
          birthday_modify = DateTime.tryParse(resp['birthday_modify']) ?? DateTime(2023);
          if (birthday==null || birthday.compareTo(DateTime(1950))==-1)
            birthday=DateTime(1950);
          if (birthday_modify==null || birthday_modify.compareTo(DateTime(1950))==-1)
            birthday_modify=DateTime(1950);
          notify_email = resp['notify_email'];
          notify_sms = resp['notify_sms'];
          notify_push = resp['notify_push'];
          notify_systempush = resp['notify_systempush'];
          level = resp['level'];
        }
      }
    } catch (error) {
      print("Ошибка при формировании данных пользователя: $error");
    }
  }

  Future<bool> httpDeleteUser() async {
    bool result = true;
    bool success = false;
    String message = '';
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/user/${widget.id}/', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.delete(_url, headers: _headers);
      if (response.statusCode != 200) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        message = notesJson['message'] ?? '';
        result = notesJson['response'] ?? false;
        throw message;
      }
    } catch (error) {
      result = false;
      final snackBar = SnackBar(content: Text('$error'),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return result;
  }

  Future httpPutUserChange() async {
    bool result = false;
    bool success = false;
    String message = '';
    var _url=Uri(path: '/c/beletag_bonus/hs/v1/user/${widget.id}/', host: 's4.rntx.ru', scheme: 'https');
    //var _url=Uri(path: '/BonusSystem/hs/v1/user/${widget.id}/', host: 'ut.acewear.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var _body = <String, String> {
        "name": name,
        "last_name": last_name,
        "second_name": second_name,
        "phone": phone,
        "email": email,
        "gender": gender,
        "birthday": birthday.toString(),
        "notify_email": notify_email.toString(),
        "notify_sms": notify_sms.toString(),
        "notify_systempush": notify_systempush.toString(),
        "notify_push": notify_push.toString()
      };
      print(_body);
      var response = await http.put(_url, headers: _headers, body: json.encode(_body));
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        message = notesJson['message'] ?? '';
        result = notesJson['response'] ?? false;
        print('Данные сохранены $result ($message)');
      }
      else
        print(response.body);
    } catch (error) {
      print("Ошибка при сохранении данных: $error");
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
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {
        if (userDataEdit==true) {
          print('Выход с сохранением');
          httpPutUserChange();
          widget.id=_phoneNewNumber;
        }
        return;
      },
      child: Scaffold(
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
                ListTile(leading: Icon(Icons.manage_accounts_rounded), title: _CustomText(title: '$last_name $name $second_name'), trailing: IconButton(icon: Icon(Icons.edit), onPressed: ()=>_tripEditModalBottomSheet(context, 1),)),
                Divider(thickness: 2, ),
                //SizedBox(height: 10,),
                _CustomHeader(title: 'Телефон'),
                ListTile(enabled: true, leading: Icon(Icons.phone, color: Colors.green), title: _CustomText(title: '$phone'), trailing: IconButton(icon: Icon(Icons.edit), onPressed: ()=>_tripEditModalBottomSheet(context, 2),)), //=>_tripEditModalBottomSheet(context, _tripEditWidgets(2))
                Divider(thickness: 2),
                //SizedBox(height: 10,),
                _CustomHeader(title: 'E-mail'),
                ListTile(leading: (confirmed_email ? Icon(Icons.mark_email_read, color: Colors.green) : Icon(Icons.mark_email_unread_rounded, color: Colors.red)), title: _CustomText(title: '$email'), trailing: IconButton(icon: Icon(Icons.edit), onPressed: ()=>_tripEditModalBottomSheet(context, 3),)),
                Divider(thickness: 2),
                //SizedBox(height: 10,),
                _CustomHeader(title: 'День рождения'),
                ListTile(leading: Icon(Icons.calendar_month), title: _CustomText(title: DateFormat('dd.MM.yyyy').format(birthday).toString()), trailing: IconButton(icon: Icon(Icons.edit), onPressed: () async { //_tripEditModalBottomSheet(context, _tripEditWidgets(4))
                if (birthday_modify.isBefore(DateTime.now().subtract(Duration(days: 360))))
                {
                  DateTime? pickeddate = await showDatePicker(locale: Locale("ru", "RU"), context: context, initialDate: birthday, firstDate: DateTime(1940), lastDate: DateTime(2015));
                  if (pickeddate != null) {
                    setState(() {
                      birthday = pickeddate;
                      userDataEdit = true;
                    });
                  }
                }
                else
                  {
                    final snackBar = SnackBar(
                      content: Text('Дату рождения можно менять только раз в году! Вы сможете ее изменить не раньше ' + DateFormat('dd.MM.yyyy').format(birthday_modify.add(Duration(days: 361))).toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },)),
                Divider(thickness: 2),
                //SizedBox(height: 10,),
                _CustomHeader(title: 'Пол'),
                ListTile(leading: (gender=='F') ? Icon(Icons.female, color: Colors.pinkAccent,) : Icon(Icons.male, color: Colors.lightBlue), title: _CustomText(title: (gender=='F') ? 'Женский' : 'Мужской'), trailing: IconButton(icon: Icon(Icons.edit), onPressed: ()=>_tripEditModalBottomSheet(context, 5),)),
                Divider(thickness: 2),
                //SizedBox(height: 10,),
                _CustomHeader(title: 'Разрешить рассылку'),
                ListTile(enabled: true, leading: Icon(Icons.email_outlined), title: Text('E-mail рассылка'), trailing: CupertinoSwitch(value: notify_email, onChanged: (value) {
                  setState(() {
                    //if (confirmed_email)
                    notify_email = value;
                    userDataEdit = true;
                  });
                },)),
                ListTile(leading: Icon(Icons.sms), title: Text('SMS рассылка'), trailing: CupertinoSwitch(value: notify_sms, onChanged: (value) {
                  setState(() {
                    notify_sms = value;
                    userDataEdit=true;
                  });
                },)),
              ListTile(leading: Icon(Icons.message), title: Text('Push рассылка'), trailing: CupertinoSwitch(value: notify_push, onChanged: (value) {
                      setState(() {
                        notify_push = value;
                        userDataEdit = true;
                      });
                    },)),
                ListTile(leading: Icon(Icons.message), title: Text('Системный Push'), trailing: CupertinoSwitch(value: notify_systempush, onChanged: (value) {
                  setState(() {
                    notify_systempush = value;
                    userDataEdit = true;
                  });
                },)),
                ListTile(title: Text('Изменяя условия подписки, вы соглашаетесь с Политикой конфиденциальности.', style: TextStyle(fontSize: 12),), trailing: Icon(Icons.navigate_next_outlined),
                  onTap: () => launchUrlString('https://cleverwear.ru/privacy_policy.html',mode: LaunchMode.inAppBrowserView),),
                Divider(thickness: 2),
                SizedBox(height: 30,),
                Card(
                  child: ListTile(
                    title: Text('Удалить аккаунт', style: TextStyle(color: Colors.red)),
                    leading: Icon(Icons.delete),
                    onTap: () async {
                      final _res = await showAlertDialog(context, 'Удалить аккаунт?', 'Вы больше не сможете пользоваться бонусами при покупках. Все ваши персональные данные будут удалены!');
                      if (_res==true) {
                        httpDeleteUser().then((value) {
                          if (value==true)
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => scrLogonScreen()), (Route<dynamic> route) => false);
                        });
                      }
                    },
                  ),
                )
              ],
          ),
        ),
      ),
    );
  }

  void _tripEditModalBottomSheet(BuildContext context, int type) {
    showModalBottomSheet(isScrollControlled: true, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), context: context, builder: (BuildContext bc) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter mystate)
      {
        return Container(
          height: 600,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _tripEditWidgets(type, mystate), //type,
          ),
        );
      });
    }
    );
  }

  Widget _tripEditWidgets(int i, mystate) {
    //GlobalKey _formKey= new GlobalKey<FormState>();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _nameController = TextEditingController(text: name);
    TextEditingController _last_nameController = TextEditingController(text: last_name);
    TextEditingController _second_nameController = TextEditingController(text: second_name);

    TextEditingController _phoneController = TextEditingController(text: phone);
    //PhoneController _phoneController2 = PhoneController(phone as PhoneNumber);
    

    TextEditingController _emailController = TextEditingController(text: email);

    final _style = ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.grey),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      minimumSize: WidgetStateProperty.all(Size(250, 40))
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

        userDataEdit = true;
      });
      Navigator.pop(context);
    }

    void _SaveDataPhone() {
      setState(() {
        if (_phoneController.text.length<2)
          print('Телефон не заполнена');

        phone = _phoneController.text;
        userDataEdit = true;
      });
      Navigator.pop(context);
    }

    void _SaveDataEmail() {
      if (RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(_emailController.text) || _emailController.text=='') {
            setState(() {
            email = _emailController.text;
            userDataEdit = true;
            _isEmailValid = true;
            Navigator.pop(context);
          });
      }
      else {
        mystate((){
          email = _emailController.text;
          _isEmailValid = false;
        });
        print('Есть спец символы');
      }
    }

    void _SaveDataBirday() {
      setState(() {
        userDataEdit = true;
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
      return Form(
        key: _formKey,
        child: Column(
          children: [
            PhoneFormField(
              key: Key('phone-field'),
              //controller: _phoneController2,
              initialValue: PhoneNumber(isoCode: IsoCode.RU, nsn: _phoneNewNumber.substring(1, 11)),
              defaultCountry: IsoCode.RU,
              validator: PhoneValidator.validMobile(),
              enabled: !_isPasswordVisible,
              autofocus: !_isPasswordVisible,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Телефон',
                hintText: 'Введите ваш номер телефона',
                //prefixIcon: Icon(Icons.phone),
                icon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              onChanged: (_tel_value) async {
                if (_tel_value!.isValid()) {
                  print('Введено значение телефона : ${_tel_value}');
                  //проверяем, зарегистрирован ли такой номер в базе
                  _phoneNewNumber = '${_tel_value!.countryCode}${_tel_value.nsn}';
                  _isUserNew = await httpGetUserNew(_phoneNewNumber);
                  if (_isUserNew) {
                    _isPasswordVisible = true;
                    ValidatePhone _res = await httpGetPhoneValidateGlobal(_phoneNewNumber);
                    print(_res);
                    _smskod = _res.code;
                    accountNew = _res.accountNew;
                    if (_res.result==false)
                      print('Была ошибка при отправке кода');
                  }
                  else {
                    _isPasswordVisible = false;
                  }
                  mystate(() {
                  });
                }
              },
            ),
            SizedBox(height: 12,),
            if (_isUserNew==false)
              Text('Номер $_phoneNewNumber уже зарегистрирован в базе.', style: TextStyle(color: Colors.red),),
            if (_isPasswordVisible == true)
              TextFormField(
                autofocus: _isPasswordVisible,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (value != _smskod) {
                    return 'Не совпадает код из смс';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Код',
                  hintText: 'Введите код из смс',
                  prefixIcon: const Icon(Icons.sms_failed_outlined),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_value_kod) {
                  if (_value_kod.length==4) {
                    print('Введено код из смс : ${_value_kod}');
                    if (_formKey.currentState?.validate() ?? false) {
                      //password = _value_kod;
                      //_setUserInfo();
                      print('Аутентификация пройдена успешно');
                      //accountNew=true;
                      if (accountNew==true) {
                        print('Запускаем процедуру смены номера на сервере');
                        _phoneController.text = _phoneNewNumber;
                        //_phoneController2.value=PhoneNumber(isoCode: IsoCode.RU, nsn: _phoneNewNumber);
                        setUserInfo(_phoneNewNumber, _value_kod);
                        _SaveDataPhone();
                      }
                      else {
                          final snackBar = SnackBar(
                            content: Text('Номер телефона уже есть в базе. Вы можете выйти из учетной записи и войти под этим номером'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          //print('Ошибка, номер, который ввел пользователь - занят (уже есть карта с таким номером)');
                        }
                    }
                  }
                },
              ),
            //SizedBox(height: 20),
            //Container(alignment: Alignment.center,child: ElevatedButton(onPressed: _SaveDataPhone, child: Text('Сохранить'), style: _style, )),
          ],
        ),
      );
    };
    if (i==3) {
      return Column(
        children: [
          TextFormField(
            key: Key('email-field'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), labelText: 'E-Mail'),
          ),
          if (_isEmailValid==false)
            Text('В E-mail указан не корректно, есть недопустимы символы', style: TextStyle(color: Colors.red),),
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
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), labelText: 'Birthday'),
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
              userDataEdit = true;
              Navigator.pop(context);
            });
          }
          ),
          RadioListTile(secondary: Icon(Icons.male, color: Colors.lightBlue,), title: Text('Мужской'), value: 'M', groupValue: gender, onChanged: (value) {
            setState(() {
              gender = value!;
              userDataEdit = true;
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


Future<bool> showAlertDialog(BuildContext context, String title, String message) async {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    child: Text('Отмена'),
    onPressed: () {
      // returnValue = false;
      Navigator.of(context).pop(false);
    },
  );
  Widget continueButton = ElevatedButton(
    child: Text('Удалить', style: TextStyle(color: Colors.red)),
    onPressed: () {
      // returnValue = true;
      Navigator.of(context).pop(true);
    },
  ); // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      cancelButton,
      continueButton,
    ],
  ); // show the dialog
  final result = await showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return result ?? false;
}