import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/ui/firebase_database/firebase_database_basic/ffirabase_basic.dart';

import 'ui/firebase_database/firebase_database_normal/firebase_database_login.dart';
import 'ui/firebase_mlkit/firebase_mlkit.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //initialRoute: "/",
      routes: {
        //"/firebase_login":(context)=>Firebase_Login(),
      },
      home:FirebaseMLKitExample_Basic() ,
    );
  }
}
