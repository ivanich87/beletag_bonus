import 'dart:io';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class scrLoadingScreen extends StatefulWidget {
  // final String id;
  scrLoadingScreen(); //this.id

  @override
  State<scrLoadingScreen> createState() => _scrLoadingScreenState();
}

class _scrLoadingScreenState extends State<scrLoadingScreen> {
  final connectivityResult = (Connectivity().checkConnectivity());
  bool isOnline = true;

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    hasNetwork().then((value) {
      print(value.toString());
      isOnline = value;
      setState(() {

      });
    });
    super.initState();
  }
@override
  @override
  Widget build(BuildContext context) {
    print(connectivityResult.toString());
    print('Связь через мобильные данные:');
    print(connectivityResult == ConnectivityResult.mobile);

    print('Связь через wifi:');
    print(connectivityResult == ConnectivityResult.wifi);

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           //if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi)
          if (isOnline!=true)
            Column(
              children: [
                Text('Ошибка 404. Нет интернета на устройстве или вы не предоставили разрешение на использование интернета. Предоставьте доступ к интернету и перезапустите приложение', style: TextStyle(fontSize: 24, color: Colors.white, decorationThickness: 0), ),
                IconButton(onPressed: () {
                  //initState();
                  Navigator.pop(context);
                  }, icon: Icon(Icons.refresh))
              ],
            )

          else
             Image.asset('assets/images/cleverwear.png', width: 250, color: Colors.white),
          //Text('Загрузка данных'),
        ],
      ),
    );
  }
}
