import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Firebase_Basic extends StatefulWidget {
  @override
  _Firebase_BasicState createState() => _Firebase_BasicState();
}

class _Firebase_BasicState extends State<Firebase_Basic> {

  final databaseref=FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(50.0),
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text("Bir Data ekleyin"),
                onPressed: () {
                  databaseref.child("1").set({
                    "title":"Deneme",
                    "body":"Bu Bir deneme firebase  Database projesidir"
                  });databaseref.child("2").set({
                    "title":"Deneme 2",
                    "body":"Bu Bir deneme firebase  Database projesidir 2"
                  });
                },
              ),RaisedButton(
                child: Text("Bir Data çekin"),
                onPressed: () {
                  databaseref.once().then((DataSnapshot snapshot){
                    print(snapshot.value.toString());
                  });
                },
              ),RaisedButton(
                child: Text("Bir Data Güncelleyin"),
                onPressed: () {
                  databaseref.child("1").update({
                    "body":"bu veriyi güncelledik"
                  });
                },
              ),RaisedButton(
                child: Text("Bir Data silin ve kaldırın"),
                onPressed: () {
                  databaseref.child("1").remove();
                },
              ),
            ],
          ), 
        ),
      ),
    );
  }
}