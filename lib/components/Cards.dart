import 'package:beletag/models/Lists.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:beletag/screens/ShopsView.dart'; 
import 'package:beletag/screens/PurchaseView.dart';



//--//Список чеков--------------------------------------------------------------
class CardObjectList extends StatefulWidget {
  const CardObjectList({
    super.key,
    required this.event
  });

  final PurchaseList event;

  @override
  State<CardObjectList> createState() => _CardObjectListState();
}

class _CardObjectListState extends State<CardObjectList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: ListTile(

              title: Text('№${widget.event.number} от ${DateFormat('dd.MM.yyyy').format(widget.event.dt)}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
              subtitle: Text(widget.event.shopAddress),
              trailing: Text('${widget.event.summa} руб', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green)),
              onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => scrPurchaseListScreen(widget.event.id)));
              },
              onLongPress: () {}),
        )
    );
  }
}
//--\\Список чеков--------------------------------------------------------------


//--//Список товаров в чеке-----------------------------------------------------
class CardItemTovarList extends StatefulWidget {
  const CardItemTovarList({
    super.key,
    required this.event
  });

  final ItemTovarList event;

  @override
  State<CardItemTovarList> createState() => _CardItemTovarListState();
}

class _CardItemTovarListState extends State<CardItemTovarList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 6.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: ListTile(

              title: Text(widget.event.name, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
              subtitle: Text(widget.event.subName),
              trailing: Text('${widget.event.summa} руб', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green)),
              onTap: () {},
              onLongPress: () {}),
        )
    );
  }
}
//--\\Список товаров в чеке-----------------------------------------------------

//--//Список бонусов в чеке-----------------------------------------------------
class CardItemBonusList extends StatefulWidget {
  const CardItemBonusList({
    super.key,
    required this.event
  });

  final ItemBonusList event;

  @override
  State<CardItemBonusList> createState() => _CardItemBonusListState();
}

class _CardItemBonusListState extends State<CardItemBonusList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 6.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: ListTile(

              title: Text(widget.event.actionComment, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
              subtitle: Text('Дата сгорания: ${DateFormat('dd.MM.yyyy').format(widget.event.dtEnd)}'),
              trailing: Text('${widget.event.bonus} руб', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green)),
              onTap: () {},
              onLongPress: () {}),
        )
    );
  }
}
//--\\Список бонусов в чеке-----------------------------------------------------

//--//Список магазинов----------------------------------------------------------
class CardShopsList extends StatefulWidget {
  const CardShopsList({
    super.key,
    required this.event
  });

  final ShopsList event;

  @override
  State<CardShopsList> createState() => _CardShopsListState();
}

class _CardShopsListState extends State<CardShopsList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 6.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: ListTile(
              title: Text(widget.event.name + '', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
              subtitle: Text(widget.event.address),
              //trailing: Image.asset(BrandIconPath(widget.event.brand_id), color: Colors.black, width: 70),
              trailing: widget.event.brand_logo.length==0 ? Text('') : Image.network(widget.event.brand_logo, width: 70),
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => scrShopsViewScreen(widget.event.id.toString())));
              },
              onLongPress: () {}),
        )
    );
  }
}

String BrandIconPath(int id) {
  if (id==1)
    return 'assets/images/beleta.png';
  if (id==2)
    return 'assets/images/beletag.png';

  //if (id==5)
    return 'assets/images/cleverwear.png';

}
//--\\Список магазинов----------------------------------------------------------


//--//Список преимуществ--------------------------------------------------------
class CardAboutList extends StatefulWidget {
  const CardAboutList({
    super.key,
    required this.event
  });

  final AboutList event;

  @override
  State<CardAboutList> createState() => _CardAboutListState();
}

class _CardAboutListState extends State<CardAboutList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15,),
        Text(widget.event.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber),),
        Text(widget.event.txt, style: TextStyle(fontSize: 18),),
      ],
    );
  }
}
//--\\Список преимуществ--------------------------------------------------------