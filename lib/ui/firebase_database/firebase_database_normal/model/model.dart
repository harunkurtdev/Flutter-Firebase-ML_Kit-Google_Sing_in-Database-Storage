import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseModel{
String id;
String isim;
String soyisim;
String sinif;

  FirebaseDatabaseModel({this.id,this.isim, this.soyisim, this.sinif});

  Map<String,dynamic> toJson({FirebaseDatabaseModel firebaseDatabaseModel}){
    final Map<String,dynamic> data=new Map<String,dynamic>();

    data["isim"]=firebaseDatabaseModel.getisim;//this.isim;
    data["soyisim"]=firebaseDatabaseModel.getsoyisim;//this.soyisim;
    data["sinif"]=firebaseDatabaseModel.getsinif;//this.sinif;

    return data;
  }

  FirebaseDatabaseModel.fromDataSnapshot(DataSnapshot snapshot){
    id=snapshot.key;
    isim=snapshot.value["isim"];
    soyisim=snapshot.value["soyisim"];
    sinif=snapshot.value["sinif"];

  }
  

get getisim=>isim;
get getsoyisim=>soyisim;
get getsinif=>sinif;

}