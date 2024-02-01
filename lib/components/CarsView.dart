//import 'dart:js';

import 'package:beletag/screens/BonusPromo.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import '../screens/BonusTransaction.dart';

class CreditCardsPage extends StatefulWidget {
  const CreditCardsPage({super.key, required this.cardNumber, required this.name, required this.secondName, required this.bonusTotal, required this.bonusPromo, required this.barcode, required this.front});
  final String cardNumber;
  final String name;
  final String secondName;
  final int bonusTotal;
  final int bonusPromo;
  final String barcode;
  final bool front;

  @override
  State<CreditCardsPage> createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {
  //final double heightCard = 210;
  @override
  Widget build(BuildContext context) {
    // if (bonusPromo>0)
    //   heightCard = 230;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.front==true)
              _buildCreditCard(
                color: Colors.black,//Colors.grey,//Colors.black,
                cardNumber: widget.cardNumber,
                cardHolder: '${widget.name} ${widget.secondName}',
                bonusTotal: "${widget.bonusTotal}",
                bonusPromo: "${widget.bonusPromo}",
                barcode: widget.barcode,
            )
            else
              _buildCreditBackCard(color: Colors.black, barcode: widget.barcode)
            ,
          ],
        ),
      ),
    );
  }

  // Build the title section
  Column _buildTitleSection({@required title, @required subTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 16.0),
          child: Text(
            '$title',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            '$subTitle',
            style: TextStyle(fontSize: 21, color: Colors.black45),
          ),
        )
      ],
    );
  }

  // Build the credit card widget
  Card _buildCreditCard(
      {required Color color,
      required String bonusTotal,
      required String cardHolder,
      required String cardNumber,
      required String bonusPromo,
      required String barcode}) {
    return Card(
      elevation: 4.0,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        height: 235,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //_buildLogosBlock(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child:
              Column(
                children: [
                  Container(
                    height: 26,
                    child: Row(
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(text: 'Доступно бонусов: ', style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'CourrierPrime')),
                          TextSpan(text: bonusTotal, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
                        ],
                        )
                        ),
                        IconButton(
                          iconSize: 26,
                          padding: EdgeInsets.only(top: 3),
                          icon: Icon(Icons.info_outlined),
                          style: ButtonStyle(iconColor: MaterialStatePropertyAll(Colors.yellowAccent)),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => scrBonusTransactionScreen(cardNumber, bonusTotal)));
                        },
                        )
                      ],
                    ),
                  ),
                  bonusPromoWidget(bonusPromo, cardNumber),
                ],
              ),
            ),
            Center(
              child: (barcode.length<13)
              ? Container(height: 60, width: 250, child: Text(''))
              : Container(height: (bonusPromo==0 || bonusPromo==null) ? 120 : 110, width: 300, child: SfBarcodeGenerator(value: barcode, symbology: QRCode(), showValue: false, barColor: Colors.white, textStyle: TextStyle(color: Colors.white), )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildDetailsBlock(label: 'Владелец', value: cardHolder),
                _buildDetailsBlock(label: 'Номер карты', value: cardNumber),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card _buildCreditBackCard(
      {required Color color,
        required String barcode}) {
    return Card(
      elevation: 4.0,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        height: 235,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0, top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: (barcode.length<13)
                  ? Container(height: 190, width: 300, child: Text(''))
                  : Container(height: 190, width: 300, child: SfBarcodeGenerator(value: barcode, symbology: QRCode(), showValue: false, barColor: Colors.white, textStyle: TextStyle(color: Colors.white), )),
            ),
          ],
        ),
      ),
    );
  }


  // Build the top row containing logos
  Row _buildLogosBlock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(
          "assets/images/contact_less.png",
          height: 20,
          width: 18,
        ),
        Image.asset(
          "assets/images/mastercard.png",
          height: 50,
          width: 50,
        ),
      ],
    );
  }

// Build Column containing the cardholder and expiration information
  Column _buildDetailsBlock({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label',
          style: TextStyle(
              color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        Text(
          '$value',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

// Build the FloatingActionButton
  Container _buildAddCardButton({
    required Icon icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 24.0),
      alignment: Alignment.center,
      child: FloatingActionButton(
        elevation: 2.0,
        onPressed: () {
          print("Add a credit card");
        },
        backgroundColor: color,
        mini: false,
        child: icon,
      ),
    );
  }

  bonusPromoWidget(bonusPromo, cardNumber) {
      if (bonusPromo != '0') {
      return Container(
        height: 28,
        padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
        child: Row(
          children: [
            Text.rich(TextSpan(children: [
              TextSpan(text: 'Скоро сгорят: ', style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'CourrierPrime')),
              TextSpan(text: bonusPromo, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
            ],
            )
            ),
            IconButton(
              iconSize: 26,
              padding: EdgeInsets.only(top: 1),
              icon: Icon(Icons.info_outlined), style: ButtonStyle(iconColor: MaterialStatePropertyAll(Colors.red)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => scrBonusPromoScreen(cardNumber, bonusPromo)));
              },
            )
          ],
        ),
      );
      } else return SizedBox(height: 1,);
  }
}
