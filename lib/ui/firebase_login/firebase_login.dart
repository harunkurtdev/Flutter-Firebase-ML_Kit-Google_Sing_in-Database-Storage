import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_firebase/ui/firebase_login_bilgi.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_login_bilgi.dart';

final kFirebaseAnalytics=FirebaseAnalytics();

class Firebase_Login extends StatefulWidget {
  @override
  _Firebase_LoginState createState() => _Firebase_LoginState();
}

class _Firebase_LoginState extends State<Firebase_Login> {

  FirebaseUser _user;
  
  bool _busy =false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   FirebaseAuth.instance.currentUser().then((user){
     setState(() {
       this._user=user;
     });
   });
  }

  @override
  Widget build(BuildContext context) {

    final statusText=Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(_user==null? "Giriş yapmaslısın": "${_user.displayName} Kullanıcı adı ile giriş yaptınız"),//eğer ki user boş ise giriş yapmalısın dşyor değil ise 
      //username in ismini gösteriyort
    );
    /**google sign kütüphanesinden aldıgımız referasn ile ugoogle bilgilerine göre işlem yapabiliyoruz */
    final googleLoginBtn=MaterialButton(
      color: Colors.blueAccent,
      child: Text("Google ile giriş yapınız"),
      onPressed: this._busy?null:() async {
        setState(() {
          _busy=true;
        });
        final user=await this._googleSignIn();
        //this._showUserProfilePage(user);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>FirebaseBilgi(user: user,)));
        debugPrint("Giriş yapıldı");
        setState(() {
          _busy=false;
        });
      },
    );


    /*ananonim olarak giriş yapabilmekteyiz */
    final anonymousLoginBtn=MaterialButton(
      color: Colors.blueAccent,
      child: Text("Anonim olarak giriş yapınız"),
      onPressed: this._busy?null:() async {
        setState(() {
          _busy=true;
        });
        final user=await this._anonymousSignIn();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>FirebaseBilgi(user: user,)));
        //this._showUserProfilePage(user);
        setState(() {
          _busy=false;
        });
      },
    );

      /**çıkış buotnumuz */
    final signOutBtn=MaterialButton(
      color: Colors.blueAccent,
      child: Text("çıkış yapınız"),
      onPressed: this._busy?null:() async {
        setState(() {
          _busy=true;
        });
        await this._signOut();
        setState(() {
          _busy=false;
        });
      },
    );



    return Scaffold(
      body: Container(
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 100,horizontal: 100),
            children: <Widget>[
              statusText,
              googleLoginBtn,
              anonymousLoginBtn,
              signOutBtn
            ],
          ),
        ),
      ),
    );
  }
  //Future ile Firebase e google giriş i yapıyortuz
  //ssha1 tanımlı olması gerekli aksi halde kaydetmez
  Future<FirebaseUser> _googleSignIn() async {
    debugPrint("ilk teyiz");
    //eğer ki user null ise onun yerine Firebase auth u ekle
    final curUser =this._user?? await FirebaseAuth.instance.currentUser();
    if(curUser!=null &&!curUser.isAnonymous){ //eğer ki ananim giriş ve cursere user boş ise 
      return curUser;//return et kullanıcıyı
    }
    debugPrint("içerideyiz");
    //google girişi için
    final googleUser=await GoogleSignIn().signIn().then((value){
      debugPrint("$value hatası var");
    });
    debugPrint("2");
    final googleAuth=await googleUser.authentication;
    debugPrint("5");
     
    final AuthCredential credential=GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,//accsees token
      idToken: googleAuth.idToken//id sini alıyoryz
    );
    //ve bunu firewbase e kayıt ediyoruz
    debugPrint("3");
    final user=(await FirebaseAuth.instance.signInWithCredential(credential)).user;
    debugPrint("4");
    kFirebaseAnalytics.logLogin();

    setState(() {
      this._user=user;
    });
    debugPrint("4");
    return user;

  }

  //ananmoim girişe bakıyoruz ssha1 istemz
  Future<FirebaseUser> _anonymousSignIn() async {
    final curUser=this._user?? await FirebaseAuth.instance.currentUser();

    if(curUser!=null&&curUser.isAnonymous){
      return curUser;
    }

    FirebaseAuth.instance.signOut();
    final anonyUser=(await FirebaseAuth.instance.signInAnonymously()).user;
    final userUpdateInfo=UserUpdateInfo();
    userUpdateInfo.displayName=anonyUser.uid.substring(0,5).toString();
    await anonyUser.updateProfile(userUpdateInfo);
    await anonyUser.reload();
    final user=await FirebaseAuth.instance.currentUser();
    kFirebaseAnalytics.logLogin();
    setState(() {
      this._user;
    });
    return user;
  }

  Future<Null>_signOut() async {
    final user =await FirebaseAuth.instance.currentUser();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          user==null?
           "Çıkış yapılamaz kullanıcı yok":
            "${user.displayName} çıkış yapıldı"
        ),
      )
    );
    FirebaseAuth.instance.signOut();
    setState(() {
      this._user=null;
    });
  } 

  void _showUserProfilePage(FirebaseUser user){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx)=>Scaffold(
          appBar: AppBar(
            title: Text("Kullanıcı sayfası"),
          ),
          body: ListView(
           children: <Widget>[
              ListTile(title: Text(user.uid.toString()),),
            ListTile(title: Text(user.displayName.toString()),),
            ListTile(title: Text(user.isAnonymous.toString()),),
            ListTile(title: Text(user.providerId),),
            ListTile(title: Text(user.email),),
            ListTile(
              title: Text("Profil Fotoğrafı"),
              trailing: user.photoUrl!=null
              ?CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ):
              CircleAvatar(
                child: Text(user.displayName[0]),
              )
            ),
            ListTile(
              title: Text(user.metadata.lastSignInTime.toString()),
            ),
            ListTile(
              title: Text(user.metadata.creationTime.toString()),
            ),
            ListTile(title: Text(user.providerData.toString()),)
           ],
          ),
        )
      )
    );
  } 

} 