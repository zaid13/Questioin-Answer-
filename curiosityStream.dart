import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:asker/routes/feed.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:asker/answerViewer.dart";

var docs=[];

class CuriosityStream extends StatefulWidget {
  final uid;
  CuriosityStream(this.uid);

  @override
  _CuriosityStreamState createState() => _CuriosityStreamState();
}

class _CuriosityStreamState extends State<CuriosityStream> {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: getAllUserQuestions(widget.uid),
      builder: (context,snapshot){

        if(snapshot.connectionState==ConnectionState.done){
          return Container(
            color: Colors.blueGrey,
            height: 300,
            child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Container(
                    margin: EdgeInsets.only(top:10) ,
                    width: MediaQuery.of(context).size.width-10,
                    child: FlatButton(
                      padding: EdgeInsets.only( bottom: 10,top: 10),
                      onPressed: () {
                        showDialog(context: context, builder: (context) => answersViewer(widget.uid,alldata[index])  );
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      color: Colors.white,
                      child: Card(
                        child: Column(
                          children: <Widget>[

                            Container(
                              padding: EdgeInsets.only(left:10),
                              child: Text(
                                "${ alldata[index]["question"]  }",
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.fade,
                                maxLines: 3,
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    color: Colors.black,
                                    fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                }),
          );
        }
        else{
          return Text("");
        }


      },
    );


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
