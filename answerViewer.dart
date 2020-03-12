import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:carousel_slider/carousel_slider.dart";
import 'package:asker/carouselItemsBuilder.dart';
import 'package:asker/person.dart';

var ans = [];

//String uninit_DocId;
getanswers() async {
  int k = 0;
  List dataList = [];
  List arr = new List();
  final oop = await Firestore.instance
      .collection("questions")
      .document(globaldocid)
      .collection("answer")
      .snapshots()
      .listen((data) => {
            data.documents.forEach((doc) {
              dataList.add({
                "doc": doc.documentID,
                "answers": doc["answer"],

                "uid": doc["uid"],
                'ind': k++,
//
              });

              print("LIKES++");
              arr.add({"likes": doc['likes']});
            })
          });

  List a = [];
  a.add(dataList);
  a.add(arr);

  return a;
}

var globaldocid;

class answersViewer extends StatefulWidget {
  final answerData;

  final DocId;
  final uid;
  FirebaseUser  user;
  answersViewer(this.uid, this.answerData, {this.DocId,this.user}) {
    //  uninit_DocId = DocId;
    print(DocId);
  }

  @override
  _answersViewerState createState() => _answersViewerState();
}

class _answersViewerState extends State<answersViewer> {
  var Answers;
  @override
  void initState() {
    // TODO: implement initState
    Answers = getanswers();
    globaldocid = widget.DocId;
  }

  @override
  Widget build(BuildContext context) {
    print("ALL DATA IUS");
    print(widget.answerData);
    Answers = getanswers();
    return Container(
      color: Colors.grey[700],
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
          floatingActionButton: Container(
              margin: EdgeInsets.only(top: 50),
              alignment: Alignment.topRight,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                )),
          body: Center(
              child: Container(
                  color: Colors.grey[700],
                  height: 500,
                  width: 400,
                  child: FutureBuilder<Object>(
                      future: Answers,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            child: ListView(children: <Widget>[
                              person(widget.answerData["uid"]),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  widget.answerData["question"],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                width: MediaQuery.of(context).size.width,
                                child: CarouselSlider(
                                  viewportFraction: 1.0,
                                  enableInfiniteScroll: false,
                                  aspectRatio: 16 / 10,
                                  height: 500,
                                  items:
                                      carouselItems(widget.uid, snapshot.data,widget.user),
                                ),
                              ),
                            ]),
                          );
                        } else
                          return Text("wait..");
                      })))),
    );
  }
}
