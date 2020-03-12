import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_qa/routes/feed.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_app_qa/Cloud_message/messageHandler.dart';

var imageUrl;
var name;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<FirebaseUser> signInWithGoogle(context) async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  imageUrl = user.photoUrl;
  name = user.photoUrl;
  print('signInWithGoogle succeeded: ${user.uid}');
  Firestore.instance.collection('people').document(user.uid).collection('replies').document(user.uid).setData({ "name":"","num":1});
  Firestore.instance.collection('people').document(user.uid).collection('likes').document(user.uid).setData({"name":"", "num":1});

  getAnalyticsforregister(currentUser.uid,user);






  saveDeviceToken(currentUser.uid);

  Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (context) => feed(user: user,)));

  return currentUser;
}

void signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Sign Out");
}


getAnalyticsforregister(uid,user)async
{

  List details=[];
  await Firestore.instance
      .collection("people")
      .document('$uid')
      .get()
      .then((DocumentSnapshot ds) {

//    print("_"+ds.data["authorized"].toString());
    details.add(ds["questions"]);
    details.add(ds["answers"]);
    details.add(ds["likes"]);
    details.add(ds["authorized"]);

if(ds["questions"]==null){

  Firestore.instance.collection('people').document(user.uid).setData({"authorized":false,"questions":0.0,"answers":0.0,"likes":0.0,"name":user.displayName , "pic":user.photoUrl,"uid":user.uid});

}
  });
}