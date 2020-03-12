import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asker/routes/feed.dart';
import "package:asker/standards.dart";

var text="";

class replypop_up extends StatefulWidget {
  final Docid ;
  final questionposter;
  FirebaseUser Curruser;

    replypop_up({this.Curruser,this.Docid ,this.questionposter}){

    print("reply ver "+Docid);
text= Docid;
  }

  @override
  _replypop_upState createState() => _replypop_upState();
}

class _replypop_upState extends State<replypop_up> {
  final texteditcontroling  = TextEditingController();

  final fstore = Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {



    submitAnswer() async{
      print("submit pressed");
      texteditcontroling.clear();
      List listofStrings = new List(); ;


  await  Firestore.instance.collection('questions').document(widget.Docid).collection("answer").add({"answer":text,"uid":widget.Curruser.uid ,"likes":listofStrings });
  print(widget.questionposter);
      Firestore.instance.collection('people').document(widget.questionposter ).collection('replies').document(  widget.questionposter).updateData({"name":widget.Curruser.displayName,"num":FieldValue.increment(1.0)});

      Firestore.instance.collection('people').document(widget.Curruser.uid).updateData({"answers":FieldValue.increment(1.0)});
      Firestore.instance.collection('questions').document(widget.Docid).updateData({"noAnswers":FieldValue.increment(1.0)});



      FocusScope.of(context).requestFocus(new FocusNode());

    }

    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: SafeArea(
        child: ClipRect(

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),

            child: Container(

                child: Center(
                    child: Column(
                        children: <Widget>[
                          Card(
                            color: Colors.white,
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onChanged: (value) {
                                text = value;
                              },
                              controller: texteditcontroling,
                              style: TextStyle(fontFamily: 'OpenSans', color: Colors.black, fontSize: 25),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top:20),
                            color: Colors.transparent,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: RaisedButton(
                                padding: EdgeInsets.only(
                                    top: 20, bottom: 20, left: 40, right: 40),
                                color: Colors.indigo,
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
                                                          color: Colors.transparent,
                                                          padding: EdgeInsets.only(left: 20, right: 20),
                                                          child: RaisedButton(
                                                              padding: EdgeInsets.only(
                                                                  top: 20, bottom: 20, left: 40, right: 40),
                                                              color: Colors.indigo,
                                                              onPressed: ()  {

                                                              },
                                                              child: Container(
                                                                height: 60,
                                                                child: ListView(
                                                                  children: <Widget>[
                                                                    Container(
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
                                                                  ],
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
                                  child: ListView(
                                    children: <Widget>[
                                      Container(
                                        child: Center(
                                          child: Text(
                                            "Post",
                                            style: TextStyle(
                                                letterSpacing: 5.0,
                                                fontFamily: 'OpenSans',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
                          ),
                        ]
                    ))


            ),
          ),
        ),
      ),
    );
  }
}






