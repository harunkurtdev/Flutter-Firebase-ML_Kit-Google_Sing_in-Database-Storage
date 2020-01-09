import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/ui/firebase_database/firebase_database_normal/model/model.dart';

class Firebase_Database_Api {
  
  DatabaseReference firebaseDatabaseRef;
  StreamSubscription<Event> veritabaniakisi;
  FirebaseDatabase firebaseDatabase=new FirebaseDatabase();
  DatabaseError databaseError;

  static final firebase_Database_Api=new Firebase_Database_Api.consturcutr();
  
  
    Firebase_Database_Api.consturcutr();
  factory Firebase_Database_Api(){
    return firebase_Database_Api;
  }

  void initState(){
    firebaseDatabaseRef=firebaseDatabase.reference().child("ogrenciler");//database Referans
  }

  verilerigetir(){//
    return firebaseDatabaseRef;//FirebaseList e qery olarak geri dönüş yapar
  }

  //Farklı iki şekilde veri kayıt ederiz 1 . map türü ikincisi 
  //model ile kayıt etme
  ogrenciKaydet({FirebaseDatabaseModel model})async{
    // firebaseDatabaseRef.push().set(<String,String>{
    //   "isim":model.isim,
    //   "ogrenci_soyisim":model.soyisim,
    //   "ogrenci_sinif":model.sinif,
    // }).then((onValue){
    //   print("kayıt işlemi gerçekleşti");
    // }).catchError((onError){
    //   print("kayıt işlemi sırasında hata oluştu");
    // });
    final jsonBody=jsonEncode(model.toJson(firebaseDatabaseModel: model));//gelen modeli json a çevir
    
    print(jsonBody.toString());

     await firebaseDatabaseRef.push().set(
      jsonDecode(jsonBody)//sonra json verisi olarak yolla burada bunu yapmaz isek json objesi yerine dart
      //objesi olarak gidecektir
    ).then((onValue){
      print("kayıt işlemi gerçekleşti");
    }).catchError((onError){
      print("kayıt işlemi sırasında hata oluştu");
    }); 
    
  }

    //gelen model verisini öğrencilerin altında ara ve sonra onu kremove et
   ogrenciSil({FirebaseDatabaseModel model}) async{
      await firebaseDatabaseRef.child(model.id).remove().then((onValue){
      print("öğrenci silme işlemi gerçekleşti");
    }).catchError((onError){
      print("öğrenci silme işlemi sırasında hata oluştu");
    });
  }

  //gelen model ile öğrenciyi database ref içinde bul ve uptade
  ogrenciguncelle({FirebaseDatabaseModel model})async{
    final jsonBody=jsonEncode(model.toJson(firebaseDatabaseModel: model));
     await firebaseDatabaseRef.child(model.id).update(
       jsonDecode(jsonBody)
     ).then((onValue){
       print("güncelleme işlemi gerçekleşti");
     }).catchError((chatEror){
       print("güncelleme sırasında hata oluştu");
     });
  }

}