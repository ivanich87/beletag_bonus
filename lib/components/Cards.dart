import 'package:beletag/models/Lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../screens/PurchaseView.dart';

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

              title: Text(widget.event.actionName, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
              subtitle: Text('Дата сгорания: ${widget.event.dtEnd}'),
              trailing: Text('${widget.event.bonus} руб', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green)),
              onTap: () {},
              onLongPress: () {}),
        )
    );
  }
}