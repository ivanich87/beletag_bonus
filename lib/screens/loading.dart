import 'package:flutter/material.dart';

class scrLoadingScreen extends StatefulWidget {
  // final String id;
  scrLoadingScreen(); //this.id

  @override
  State<scrLoadingScreen> createState() => _scrLoadingScreenState();
}

class _scrLoadingScreenState extends State<scrLoadingScreen> {
  String logoPath = 'https://beletag.com/upload/CMax/35c/tw0i3dku7v12n29mwofzdnj5b90k9kn7/logo_aspro.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Image(image: NetworkImage(logoPath),width: 250),
          Image.asset('assets/images/beletag.png', width: 250, color: Colors.amber),

          //Text('Загрузка данных'),
        ],
      ),
    );
  }
}
