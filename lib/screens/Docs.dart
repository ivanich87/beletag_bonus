import 'package:flutter/material.dart';
import 'package:beletag/models/Lists.dart';
import 'package:url_launcher/url_launcher_string.dart';



class scrDocsScreen extends StatefulWidget {
  // final String id;
  scrDocsScreen(); //this.id

  @override
  State<scrDocsScreen> createState() => _scrDocsScreenState();
}

class _scrDocsScreenState extends State<scrDocsScreen> {
  String logoPath = 'https://img.acewear.ru/CleverWearImg/logo_aspro.png';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Документы'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image(image: NetworkImage(logoPath)),
            SizedBox(height: 20,),
            Divider(),
            ListTile(
              title: Text('Политика конфиденциальности'),
              trailing: Icon(Icons.outbond),
              onTap: () => launchUrlString('https://cleverwear.ru/privacy_policy.html', mode: LaunchMode.inAppBrowserView),
            ),
          Divider(),
          ListTile(
            title: Text('Правила Бонусной Системы'),
            trailing: Icon(Icons.outbond),
            onTap: () => launchUrlString('https://cleverwear.ru/', mode: LaunchMode.inAppBrowserView),
          ),
          Divider(),
        ],
      ),
    );
  }
}

