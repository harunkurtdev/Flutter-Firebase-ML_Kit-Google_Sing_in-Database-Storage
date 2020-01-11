import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/firebase_database/firebase_database_normal/database_api/database_api.dart';
import 'package:flutter_firebase/ui/firebase_database/firebase_database_normal/model/model.dart';
import 'package:flutter_firebase/ui/firebase_database/uiwidget/itemwidget.dart';

class Firebase_Database_Normal_UI extends StatefulWidget {
  @override
  _Firebase_Database_Normal_UIState createState() => _Firebase_Database_Normal_UIState();
}

class _Firebase_Database_Normal_UIState extends State<Firebase_Database_Normal_UI> {

 Firebase_Database_Api _firebase_database_api =Firebase_Database_Api();

  final isimController=TextEditingController();
  final soyisimController=TextEditingController();
  final sinifController=TextEditingController();

  double ogrenciicon=96;

  bool duzenleyici=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebase_database_api =new Firebase_Database_Api();
    _firebase_database_api.initState();
  }

  Query verileriguncelle(){
    return _firebase_database_api.verilerigetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex:1,
              child: Container(
                color:Colors.blueAccent,
                child:Center(
                  child:Text("Öğrenci İşlemleri",
                  style: TextStyle(
                    fontSize: 28
                  ),),
                ), 
              ),
            ),
            Expanded(
                flex: 2,
                child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color:Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)
                  )
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.white,
                      iconSize: ogrenciicon,
                      tooltip: "Yeni Bir Data  ekliyor olucaksınız",
                      onPressed: () {
                        ogrenciekle();
                      }
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
                child: FirebaseAnimatedList(
                  query: verileriguncelle(), 
                  itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation animation, int index) {
                    FirebaseDatabaseModel firebaseDatabaseModel=new FirebaseDatabaseModel.fromDataSnapshot(snapshot);

                      if(index==null){
                        print("bnuraya girdi");
                        return Center(child: CircularProgressIndicator(),);
                      }

                    return Dismissible(
                        key:Key(firebaseDatabaseModel.id),
                        secondaryBackground: Container(
                          color: Colors.redAccent,
                          child: Icon(Icons.remove),
                          alignment: Alignment(0.85,0.0),
                        ),
                        onDismissed: (DismissDirection dismissDirection) async{
                         //dismissible ile burada switch ile sağa sola yukarı aşağı gibi işlemler 
                         //yaptırıyourz
                          switch(dismissDirection){

                            case DismissDirection.vertical:
                              // TODO: Handle this case.
                              break;
                            case DismissDirection.horizontal:
                              // TODO: Handle this case.
                              break;
                            case DismissDirection.endToStart:
                              // TODO: Handle this case.
                               print("sola doğru çekildi");
                                //Center(child: CircularProgressIndicator());
                                  showDialog(
                                  context: context,
                                  barrierDismissible: false,                         
                                  child: AlertDialog(
                                    key: Key(firebaseDatabaseModel.id),
                                    content: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      child: Text("Öğrenciyi Silmek istediğnize emin misiniz?"),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Icon(Icons.not_interested,size: 48.0,),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          verileriguncelle();
                                        },
                                      ),
                                      FlatButton(
                                      child:Icon(Icons.restore_from_trash,size: 48.0,),
                                      onPressed: ()async {
                                        await _firebase_database_api.ogrenciSil(model: firebaseDatabaseModel).then((onValue){
                                          Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.blueAccent,
                                          ));
                                        });
                                        Navigator.of(context).pop();
                                        verileriguncelle();
                                      },
                                      ),
                                    ],
                                  )
                               );

                              break;
                            case DismissDirection.startToEnd:
                              // TODO: Handle this case.
                               print("sağa doğru çekildi");
                               ogrenciekle(model: firebaseDatabaseModel);
                              
                              
                              //await _firebase_database_api.ogrenciguncelle(model: firebaseDatabaseModel);
                               

                              break;
                            case DismissDirection.up:
                              // TODO: Handle this case.
                              break;
                            case DismissDirection.down:
                              // TODO: Handle this case.
                              break;
                          }
                        },
                        background: Container(
                          color: Colors.greenAccent,
                          child: Icon(Icons.edit),
                          alignment: Alignment(-0.85, 0.0),
                        ),
                        child: Center(
                          child: ItemWidget(
                            isim: firebaseDatabaseModel.isim,
                          )
                        ),
                    );
                  },
                ),
            )
          ],
        ),
      ),
     );
  }

  //öğrenci ekleye iki çeşit veri gönderiyoruz birisi güncelleme yani modeli göndererek
  //güncelleme işlemi için
  //modelsiz bir şekilde ise veriyi direkt eklemek için
  ogrenciekle({FirebaseDatabaseModel model}){
  if(model!=null){
    duzenleyici=true;
    isimController.text=model.isim;
    soyisimController.text=model.soyisim;
    sinifController.text=model.sinif;
  }else{
    duzenleyici=false;
    isimController.clear();
    soyisimController.clear();
    sinifController.clear();
  }

   return showDialog<String>(
     barrierDismissible: false,
     context: context,
     builder: (BuildContext context){
       return AlertDialog(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.only(
             topRight: Radius.elliptical(100.0, 30.0)
           ,bottomLeft: Radius.elliptical(100.0, 30.0)
           )
         ),
         title: Text(duzenleyici?"Öğrenci Düzenleme Yeri":"Öğrenci ekleme yeridir"),
         content: SingleChildScrollView(
           child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(15))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  onTap: (){
                    setState(() {
                      print("Ekrana basıldı");
                    ogrenciicon=48;
                    });
                  },
                  scrollPadding: EdgeInsets.all(20.0),
                  controller: isimController,
                  decoration: InputDecoration(
                    hintText: duzenleyici?"Öğrenciyi düzenleyin":"Öğrenci ismini giriniz",
                    border: OutlineInputBorder(),
                    labelText:duzenleyici?"öğrenciyi düzenliyorsunuz":"Öğrenci ismini giriyorsunuz"
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  onTap: (){
                    setState(() {
                      print("Ekrana basıldı");
                    ogrenciicon=48;
                    });
                  },
                  scrollPadding: EdgeInsets.all(20.0),
                  controller: soyisimController,
                  decoration: InputDecoration(
                    hintText: duzenleyici?"Öğrenciyi düzenleyin":"Öğrenci soyismini giriniz",
                    border: OutlineInputBorder(),
                    labelText:duzenleyici?"öğrenciyi düzenliyorsunuz":"Öğrenci soyismini giriyorsunuz"
                  ),
                ),SizedBox(
                  height: 10.0,
                ),TextFormField(
                  onTap: (){
                    setState(() {
                      print("Ekrana basıldı");
                    ogrenciicon=48;
                    });
                  },
                  scrollPadding: EdgeInsets.all(20.0),
                  controller: sinifController,
                  decoration: InputDecoration(
                    hintText: duzenleyici?"Öğrenciyi düzenleyin":"Öğrenci sinifini giriniz",
                    border: OutlineInputBorder(),
                    labelText:duzenleyici?"öğrenciyi düzenliyorsunuz":"Öğrenci sinifini giriyorsunuz"
                  ),
                ),
              ],
            ),
           ),
         ),
         actions: <Widget>[
           FlatButton(
             child: Text("İşlemi iptal et"),
             onPressed: (){
               Navigator.of(context).pop();
               setState(() {
                  ogrenciicon=96;
                  isimController.text="";
                  soyisimController.text="";
                  sinifController.text="";
                });
             },
           ),
            FlatButton(
             child: Text(duzenleyici?"Öğrenciyi düzenle":"Öğrenci ekleyin"),
             onPressed: duzenleyici?(){
                  //burada öğrenci düzenle true ise bu bölüme gir
                  //database_apiye öğrenci güncelle ile modelimize ilk öncelikle
                  /*
                  controller dan gelen verileri atayıp daha sonradan ise model e kayıt edip 
                  bunu database apiye göndermek
                   */
                 _firebase_database_api.ogrenciguncelle(
               model: FirebaseDatabaseModel(
                 id: model.id,
                 isim: isimController.text
                 , sinif: sinifController.text
                 ,soyisim: soyisimController.text
                 )
                 );
                Navigator.of(context).pop();
                setState(() {
                  ogrenciicon=96;
                  isimController.text="";
                  soyisimController.text="";
                  sinifController.text="";
                });

             } : () {
               /*
               eğer modelimiz boş ise bize düzenleyici false dönerek burada ki onpress i çalıştıracaktır
               burada öğrencikaydet ede bir model göndererek database e kaydetme işlemi yapmış oluyoruz
                */
               _firebase_database_api.ogrenciKaydet(
               model: FirebaseDatabaseModel(
                 isim: isimController.text
                 , sinif: sinifController.text
                 ,soyisim: soyisimController.text
                 )
                 );
                Navigator.of(context).pop();
                setState(() {
                  ogrenciicon=96;
                  isimController.text="";
                  soyisimController.text="";
                  sinifController.text="";
                });
             },
           ),
         ],
       );
     }
   ); 
 }

}