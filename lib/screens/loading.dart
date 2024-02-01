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

@override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi)
             Text('Ошибка 404. Проверьте интернет на устройстве и перезапустите приложение', style: TextStyle(fontSize: 24, color: Colors.white, decorationThickness: 0), )
          else
             Image.asset('assets/images/beletag.png', width: 250, color: Colors.amber),
          //Text('Загрузка данных'),
        ],
      ),
    );
  }
}
