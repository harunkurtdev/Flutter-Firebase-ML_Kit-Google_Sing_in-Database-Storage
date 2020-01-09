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
      child: Text(_user==null? "Giriş yapmaslısın": "${_user.displayName} Kullanıcı adı ile giriş yaptınız"),
    );

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

  Future<FirebaseUser> _googleSignIn() async {
    debugPrint("ilk teyiz");

    final curUser =this._user?? await FirebaseAuth.instance.currentUser();
    if(curUser!=null &&!curUser.isAnonymous){
      return curUser;
    }
    debugPrint("içerideyiz");

    final googleUser=await GoogleSignIn().signIn().then((value){
      debugPrint("$value hatası var");
    });
    debugPrint("2");
    final googleAuth=await googleUser.authentication;
    debugPrint("5");
    final AuthCredential credential=GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
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