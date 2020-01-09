import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseBilgi extends StatefulWidget {

  FirebaseUser user;

   FirebaseBilgi({Key key, this.user}) : super(key: key);

  @override
  _FirebaseBilgiState createState() => _FirebaseBilgiState();
}

class _FirebaseBilgiState extends State<FirebaseBilgi> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((_user){
      setState(() {
        this.widget.user=_user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcı sayfası"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(title: Text(widget.user.uid.toString()),),
          ListTile(title: Text(widget.user.displayName.toString()),),
          ListTile(title: Text(widget.user.isAnonymous.toString()),),
          ListTile(title: Text(widget.user.providerId),),
          ListTile(title: Text(widget.user.email),),
          ListTile(
              title: Text("Profil Fotoğrafı"),
              trailing: widget.user.photoUrl!=null
                  ?CircleAvatar(
                backgroundImage: NetworkImage(widget.user.photoUrl),
              ):
              CircleAvatar(
                child: Text(widget.user.displayName[0]),
              )
          ),
          ListTile(
            title: Text(widget.user.metadata.lastSignInTime.toString()),
          ),
          ListTile(
            title: Text(widget.user.metadata.creationTime.toString()),
          ),
          ListTile(title: Text(widget.user.providerData.toString()),)
        ],
      ),
    );
  }
}
