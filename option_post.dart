import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asker/nav1.dart';
import 'package:asker/routes/feed.dart';

import 'editscreeen.dart';

class option_post extends StatefulWidget {
  @override
  _option_postState createState() => _option_postState();

  final data;
  final docid;
final currentuser;

  option_post({this.data, this.docid,this.currentuser});
}

class _option_postState extends State<option_post> {
  @override
  Widget build(BuildContext context) {

    return SizedBox(

      height: 100,
      width: 100,
      child: Container(

        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
         Container(
           margin: EdgeInsets.only( bottom: 200,right: 50),

             alignment: Alignment.bottomRight,
           child: FloatingActionButton(
        backgroundColor: Colors.white,
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {});
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) =>feed(user: widget.currentuser,)));
            },
        ),
         ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: RaisedButton(
                  padding:
                      EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
                  color: Colors.red,
                  onPressed: () {
                    Firestore.instance
                        .collection("questions")
                        .document(widget.docid)
                        .delete();

                    Firestore.instance
                        .collection('questions')
                        .document(widget.docid)
                        .collection("answers")
                        .getDocuments()
                        .then((snapshot) {
                      for (DocumentSnapshot ds in snapshot.documents) {
                        ds.reference.delete();
                      }
                    });

                    Firestore.instance
                        .collection("people")
                        .document(widget.currentuser.uid)
                        .updateData({"questions": FieldValue.increment(-1.0)});

                    setState(() {
                      Firestore.instance
                          .collection("questions")
                          .document(widget.docid)
                          .delete();
                      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) =>feed(user: widget.currentuser,)));


                    });
                  },
                  child: Container(
                    height: 20,
                    child: Container(
                      child: Center(
                        child: Text(
                          "Delete",
                          style: TextStyle(
                              letterSpacing: 5.0,
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
            ),
            SizedBox(
              height: 10,
              width: 10,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: RaisedButton(
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
                  color: Colors.blue[800],
                  onPressed: () {
                    setState(() {
                      showDialog(
                          context: context, builder: (context) => updater(docid: widget.docid, id: widget.currentuser,));
                    });

                    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) =>feed(user: widget.currentuser,)));


                  },
                  child: Container(
                    height: 20,
                    child: Container(
                      child: Center(
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              letterSpacing: 5.0,
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
            ),
          ],
        ),
      ),
    );
  }
}

class updater extends StatefulWidget {
  @override
  _updaterState createState() => _updaterState();
  final docid;
  final id;
  updater({this.docid ,this.id});


}

class _updaterState extends State<updater> {
  String text;
  final texteditcontroling = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Container(
          padding:  EdgeInsets.only(top: 60),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
          Card(
            color: Colors.white,
            child: Container(
              alignment: Alignment.topLeft,
              height: 50,
              width: MediaQuery.of(context).size.width - 100,
              child: TextField(
                cursorColor: Colors.blue[700],
                //    decoration: InputDecoration(labelText: "WRITE YOUR QUESTION HERE "),
//                    keyboardAppearance:Brightness.dark,

                textAlign: TextAlign.center,

                onChanged: (value) {
                  text = value;
                },
                controller: texteditcontroling,
                style: TextStyle(
                    fontFamily: 'OpenSans', color: Colors.black, fontSize: 25),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            color: Colors.blue,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: FlatButton(

              onPressed: () {
                setState(() {
                  if (text.length > 0) {
                    texteditcontroling.clear();
                    Firestore.instance
                        .collection("questions")
                        .document(widget.docid)
                          .updateData({"question":text});

                    text = "";
                    Firestore.instance.collection('questions').document().setData({"noAnswers":0,'uid': '${widget.id}',"searchKey":text.substring(0,1).toUpperCase()    , 'question': '${text}' });
                    setState(() {
                      Navigator.pop(context);
                   });

                  } else {
                    showDialog(
                        context: context,
                        child: Container(
                          margin: EdgeInsets.only(top: 350),
                          child: SafeArea(
                            child: Container(
                                child: Center(
                                    child: Column(children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: RaisedButton(
                                    padding: EdgeInsets.only(
                                        top: 20,
                                        bottom: 20,
                                        left: 40,
                                        right: 40),
                                    color: Colors.indigo,
                                    onPressed: () {},
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
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)))),
                              ),
                            ]))),
                          ),
                        ));
                  }
                });


              },
              child: Container(
                height: 60,
                child: Center(
                  child: Text(
                    "update",
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
        ]))),
      ),
    );
  }
}
