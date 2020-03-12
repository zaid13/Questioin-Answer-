import 'dart:async';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asker/questionPage.dart';
import 'package:asker/routes/feed.dart';
import "package:asker/standards.dart";

var text="";

class navPage3 extends StatefulWidget {
  final FirebaseUser user;
  navPage3(this.user);
  @override
  _navPage3State createState() => _navPage3State();
}

class _navPage3State extends State<navPage3> {
  final texteditcontroling  = TextEditingController();

  final fstore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    print(widget.user.displayName);

    submitAnswer() async{

      //when posting a new question reset data of question viewer
//      dataList = [];
//      lastdoc=null;


      print("submit pressed");
      texteditcontroling.clear();

      Firestore.instance.collection('questions').document().setData({"noAnswers":0,'uid': '${widget.user.uid}',"searchKey":text.substring(0,1).toUpperCase()    , 'question': '${text}' });

      Firestore.instance.collection('people').document(widget.user.uid).updateData({"questions":FieldValue.increment(1.0)});


        showDialog(context: context,
            child:not("SUBMITTED")
        );


      FocusScope.of(context).requestFocus(new FocusNode());
    }

    return SafeArea(
      child: Container(
          padding: EdgeInsets.only(top: 60),
        child: Center(
            child: Column(
              children: <Widget>[
                Card(
                  color: Colors.white,

                  child: Container(
//color: Colors.red,
                    alignment: Alignment.topLeft,
height: 100,
                    width: MediaQuery.of(context).size.width-50,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      cursorColor: Colors.blue[700],
                  //    decoration: InputDecoration(labelText: "WRITE YOUR QUESTION HERE "),
//                    keyboardAppearance:Brightness.dark,

textAlign: TextAlign.center,

                      onChanged: (value) {
                       text = value;
                      },
                      controller: texteditcontroling,
                      style: TextStyle(fontFamily: 'OpenSans', color: Colors.black, fontSize: 25),
                    ),
                  ),
                ),
            Container(
              margin: EdgeInsets.only(top:20),
              color: Colors.transparent,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: FloatingActionButton(

//                  padding: EdgeInsets.only(
//                      top: 20, bottom: 20, left: 40, right: 40),
//                  color: Colors.blue[800],
                  onPressed: ()  {

                    setState(() {
                      if(text.length>0){
                        submitAnswer();
                        text="";

                      }
                      else{
                        showDialog(context: context,child:
                        Container(
                          margin: EdgeInsets.only(top:350),
                          child: SafeArea(
                            child: Container(
                                child: Center(
                                    child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(top:20),
                                            padding: EdgeInsets.only(left: 20, right: 20),
                                            child: RaisedButton(
                                                padding: EdgeInsets.only(
                                                    top: 20, bottom: 20, left: 40, right: 40),
                                                color: Colors.indigo,
                                                onPressed: ()  {

                                                },
                                                child: Container(
                                                  height: 60,
                                                  child: Container(
                                                    child: Center(
                                                      child: Text(
                                                        "Empty Question",
                                                        style: TextStyle(
                                                            letterSpacing: 5.0,
                                                            fontFamily: 'OpenSans',
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w900,
                                                            fontSize: 25),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
                                          ),
                                        ]
                                    ))


                            ),
                          ),
                        )
                        );
                      }

                    });



                  },
                  child: Container(
                    height: 60,
                    child: Center(
                      child: Text(
                        "ASK",
                        style: TextStyle(

                            letterSpacing: 1.0,
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 25),
                      ),
                    ),
                  ),
               //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))
                   ),
            ),
        ]
        ))


      ),
    );
  }
}









class not extends StatefulWidget {
  @override
  _notState createState() => _notState();
  final str;
  var mood;
  not(this.str,{this.mood});
}

class _notState extends State<not> {

  @override
  void initState() {
    // TODO: implement initState

    Timer(Duration(seconds: 1), () {
Navigator.pop(context);

    });

  }
  @override
  Widget build(BuildContext context) {

    if(widget.mood==null){
      widget.mood='✔';
    }

    return Container(
      padding: EdgeInsets.only(left:50,right:50,top:250,bottom: 250),

      child: Center(
      child:
      Scaffold(body: Center(child:Text("${widget.str} ${widget.mood}",style: TextStyle(fontSize: 25),),)


    )

    ));

  }
}
