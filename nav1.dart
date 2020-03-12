import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asker/google.dart';
import 'package:asker/main.dart';
import 'package:asker/option_post.dart';
import 'package:asker/questionPage.dart';
import 'package:asker/replypop_up.dart';
import 'package:asker/routes/feed.dart';
import "package:asker/curiosityStream.dart";
import "package:asker/answerViewer.dart";
import 'package:asker/routes/login_page.dart';
import 'package:asker/routes/mainPage.dart';
import 'package:loading_animations/loading_animations.dart';
final appid="ca-app-pub-3940256099942544/6300978111";
class navPage1 extends StatefulWidget {
  FirebaseUser currUser;

  navPage1(this.currUser);
  @override
  _navPage1State createState() => _navPage1State();
}

class _navPage1State extends State<navPage1> {
  BannerAd createBannner(){
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      birthday: DateTime.now(),
      childDirected: false,
      designedForFamilies: false,
      gender: MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
      testDevices: <String>[], // Android emulators are considered test devices
    );


    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size:  AdSize.fullBanner,

        targetingInfo: targetingInfo,
        listener: (MobileAdEvent edv){
          print("Add mob $edv");


        }



    );
  }
  BannerAd _BannerAd;
  Future get_question_user;
  Future getuserAnalytics;
  Future questionlist_future;
  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: appid);
    _BannerAd = createBannner()..load()..show(
//  horizontalCenterOffset: lastpostion
      anchorType: AnchorType.top,
      //  anchorOffset: 80

    );

      print("get question user   " + widget.currUser.uid);
      get_question_user = getAllUserQuestions(widget.currUser.uid);
        getuserAnalytics = getAnalytics(widget.currUser.uid);
    // TODO: implement initState
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _BannerAd.dispose();
  }
  void createState() {
    print("creating stste");
  }



  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: 60),
      child: Card(
        child: Container(
          height: MediaQuery.of(context).size.height    ,
          color: Colors.black87,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(left: 10, top: 10),
                        child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(widget.currUser.photoUrl)),
                      ),

                      tick(getuserAnalytics),

                    ],
                  ),

                  FutureBuilder(
                      future: getuserAnalytics,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.done  ) {
                          return Row(
                            textDirection: TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5,0, 10, 0),
                                child: Column(
                                  children: <Widget>[
                                    Stats(ToInt(snapshot.data[0]).toString(),20),
                                    Stats("Questions".toString(),15),

                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20,0, 20, 0),
                                child: Column(
                                  children: <Widget>[
                                    Stats(ToInt(snapshot.data[1]).toString(),20),
                                    Stats("Answers".toString(),15),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10,0, 0, 0),
                                child: Column(
                                  children: <Widget>[
                                    Stats(ToInt( snapshot.data[2]).toString(),20),
                                    Stats("Likes".toString(),15),
                                  ],
                                ),
                              ),



                            ],
                          );

                        } else
                          return Text("");
                      }),


                ],
              ),
              Container(
                //  color: Colors.black87,
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  "${widget.currUser.displayName.substring(0,widget.currUser.displayName.indexOf(' '))
                }",
                  style: TextStyle(
                      letterSpacing: 2.0,
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                      fontSize: 20),
                ),
              ),
              Column(
                children: <Widget>[
                  FutureBuilder(
                    future: get_question_user,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        print("connection done ");
                        List<dynamic> alldata=snapshot.data;

                        return Container(
                          alignment: Alignment.bottomCenter,
                          color: Colors.black87,
                          height: MediaQuery.of(context).size.height/1.85,
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: MediaQuery.of(context).size.width - 10,
                                      child: FlatButton(
//                                        padding: EdgeInsets.only(bottom: 0, top: 5),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
builder: (context) => Container(child: answersViewer( widget.currUser.uid, alldata[index] ,DocId:  alldata[index]['docid'])));
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topLeft:  Radius.circular(10) , topRight  : Radius.circular(10) )

                                        ),







                                color: Colors.white,
                                        child: Card(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.topRight,
                                                child: FlatButton(

                                                    onPressed: (){

                                                        print(index);
                                                        setState(() {

                                                        });
                                                        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) =>option_post(data: alldata[index],docid:alldata[index]["docid"] ,currentuser: widget.currUser,)));

//                                                        reassemble();   //when i need to reload the page i will use this
//
                                                        get_question_user = getAllUserQuestions(widget.currUser.uid);


                                                    },
                                                    child: Icon(Icons.brush)),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text(
                                                  "${alldata[index]["question"]}",
                                                  textAlign: TextAlign.left,
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      color: Colors.black,
                                                      fontSize: 25),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(bottom: 5),
                                                  alignment: Alignment.centerLeft,
                                                  child: Text("Ansawers  " +ToInt(alldata[index]["noAnswers"]).toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.lightBlue),)),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
//                                      margin: EdgeInsets.only(bottom: ),
                                      child: RaisedButton(
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 5, left: 40, right: 40),

                                          color: Colors.blue[800],
                                          onPressed: ()  {

                                            setState(() {
                                              showDialog(context: context,child: replypop_up(questionposter:alldata[index]["uid"
                                                  ""], Curruser: widget.currUser ,Docid:alldata[index]["docid"],));


                                            });
                                          },
                                            child: Container(
                                              height: 25,
                                              child: Center(
                                                child: Text(
                                                  "Answer this !",
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10) ,bottomRight: Radius.circular(10) )

                                          )

                                      ),


                                    ),
                                  ],
                                );
                              }),
                        );
                      } else {
                        return LoadingBouncingLine.circle(
                          size: 50,
                          backgroundColor: Colors.red,
                        );
//                   return Text("loaing ");
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 20,//MediaQuery.of(context).size.height / 22.5,
                      alignment: Alignment.bottomCenter,
                      color: Colors.red,
                      child: SizedBox(
                        height: 20,
//                  width: ,
                        child: FlatButton(
                            onPressed: () {
                              signOutGoogle();
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => mainPage()));
//                      popAndPushNamed
                            },
                            child: Text(
                              "LOG OUT",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
  getAnalytics(uid)async{

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


    });
    return details;



  }
  var alldata=[];
  getAllUserQuestions(uid) async{
    alldata=[];
    await Firestore.instance
        .collection('questions')
        .where("uid", isEqualTo: "$uid")
        .snapshots()
        .listen((data) => data.documents.forEach((doc) {
      alldata.add(
          {
            "answers":doc["answers"],
            "question":doc["question"],
            "uid":doc["uid"],
            "noAnswers":doc["noAnswers"],

            "docid":doc.documentID
          }
      );
    }));
    print(alldata.length.toString() + "   4555555555555");
    return alldata;
  }


}
class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
  String str;
  double size;
  Stats(this.str ,this.size);
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return   Text(
      widget.str,
      style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.white,
          fontSize:widget.size ),
    );
  }
}

String ToInt(rank){

  if(rank<0){return "0";}  //handling bugs
  String zero = '0';
  String str = rank.toString();
  if(str.length==1){
    return zero;
  }
  else{
  return str.substring(0,str.indexOf('.'));
  }
}

class tick extends StatefulWidget {
  @override
  _tickState createState() => _tickState();
  final getuserAnalytics;
  tick(this.getuserAnalytics);
}

class _tickState extends State<tick> {
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.topRight,
      child:   FutureBuilder(
        future: widget.getuserAnalytics,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done && snapshot.data[3]==true )  {
          return Image.asset("assets/images/tick.png",
            width: 20,
            height: 20,
          );}
      else{
        return Image.asset("assets/images/circleGreen.png",
          width: 20,
          height: 20,
        );
      }
      }
      ),
    );
  }

}

