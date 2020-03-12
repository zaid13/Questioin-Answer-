//import 'dart:js_util';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:asker/nav1.dart';
import 'package:asker/nav3.dart';
import "package:asker/person.dart";
import 'package:asker/answerViewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asker/routes/feed.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_animations/loading_animations.dart';
List<Widget> carouselItems(uid ,List answers,user){
  List<Widget> replies=[];
  List a = answers[1];


//builing a 2 D array for likerss;
  List<List> likers=[];
  List<int> number=[];

  for(var d in a){
    List e = d["likes"];
    List Tlist = [];
    for( var k in e ){
      Tlist.add(k);
    }
    print(Tlist.length);
    likers.add(Tlist);
    number.add(Tlist.length);
  }



  answers = answers[0];


  //ctr for array of likers
  for (Map el in answers){
    print("//////////////////////////////");

print(el['ind']);


    replies.add(
        likes(el,uid,likers,user: user),

    );

  }

  return replies;
}
//funct() async{
//  QuerySnapshot querySnapshot = await Firestore.instance.collection("collection").getDocuments();
//  List l = querySnapshot.documents[1];
//  for(var a in l )
//    {
//      print(a);
//    }
//}

class likes extends StatefulWidget {
  @override
  _likesState createState() => _likesState();
  final el;
  final uid;
  final likers;
  FirebaseUser user;
  likes(this.el,this.uid,this.likers,{this.user}){}
}

class _likesState extends State<likes> {
  Future getuserAnalytics;

  @override
  void initState() {
    getuserAnalytics = getAnalytics(widget.el["uid"]);

    // TODO: implement initState
    super.initState();
  setState(() {

  });
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: EdgeInsets.only(left: 20),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                FutureBuilder(
                  future:getUserDetails(widget.el["uid"] ),   //getUserDetails got this from person file
                  builder: (context, userData){

                    if(userData.hasData)
                    {
                      return  Container(
                        padding:EdgeInsets.only(top:5,bottom: 5,left:5) ,
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.all(Radius.circular(15.0),)),
                        child: Row(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                CircleAvatar(
                                    radius: 25
                                    ,backgroundImage: NetworkImage("${userData.data[0]}",)),
                                tick(getuserAnalytics),
                              ],
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(left:10),
                                child: Text(
                                  "${userData.data[1]}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Open Sans",
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    else{
                      return LoadingBouncingLine.circle(size: 50, backgroundColor: Colors.black,); //loading
                    }


                  },

                ),
                Row(
                  children: <Widget>[

                    Container(
                      alignment: Alignment.centerRight,
                      child: LikeButton(

                        size: 40,
                        onTap: (bool isLiked) async{
                          setState(() {

                          });
                          print(widget.likers[widget.el['ind']].length);

                          if(!isLiked){

                            await Firestore.instance
                                .collection("questions").document(globaldocid).collection("answer").document(widget.el['doc']).updateData({"likes":FieldValue.arrayUnion([widget.uid])});

                            if(!widget.likers[widget.el['ind']].contains(widget.uid))
                              widget.likers[widget.el['ind']].add(widget.uid);
                            await Firestore.instance.collection('people').document(widget.el['uid']).collection('likes').document(widget.el['uid']).updateData({"name":widget.user.displayName,"num":FieldValue.increment(1.0)});

                            await Firestore.instance.collection('people').document(widget.el['uid']).updateData({"likes":FieldValue.increment(1.0)});



                          }
                          else{
//
//                            setProperty(o, name, value)
                            await Firestore.instance
                                .collection("questions").document(globaldocid).collection("answer").document(widget.el['doc']).updateData({"likes":FieldValue.arrayRemove([widget.uid])});
//                          print(el['doc']);
                            if(widget.likers[widget.el['ind']].contains(widget.uid))
                              widget.likers[widget.el['ind']].remove(widget.uid);

                            Firestore.instance.collection('people').document(widget.el['uid']).updateData({"likes":FieldValue.increment(-1.0)});


                          }

                          print(widget.likers[widget.el['ind']].length);


                          return !isLiked;
                        },

                        isLiked:widget.likers[widget.el['ind']].contains(widget.uid),
                        likeCount: widget.likers[widget.el['ind']].length,
                      ),
                    ),


                  ],
                )
              ],
            ),/*el['answer']*/
            Text(widget.el['answers'],textAlign: TextAlign.left,style: TextStyle(
              fontFamily: 'OpenSans',
              color: Colors.white,
              fontSize: 20,

            ),),

          ],
        ),
    );}
  getAnalytics(uid)async{

    List details=[];
    await Firestore.instance
        .collection("people")
        .document('$uid')
        .get()
        .then((DocumentSnapshot ds) {

      details.add(ds["questions"]);
      details.add(ds["answers"]);
      details.add(ds["likes"]);
      details.add(ds["authorized"]);



    });
    return details;



  }

}
