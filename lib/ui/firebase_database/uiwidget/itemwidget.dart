import 'package:flutter/material.dart';

class ItemWidget extends StatefulWidget {
  final String id;
  final String isim;
  final String soyisim;
  final String sinif;
  final void itemguncelle;
  final void itemsil;

  const ItemWidget({Key key, this.id, this.isim, this.soyisim, this.sinif, this.itemguncelle, this.itemsil}) : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        margin: EdgeInsets.all(5.0),
        color: Colors.blueAccent,
        width: double.infinity,
        height: 100,
        child: Text(this.widget.isim),
      )
    );
  }
}