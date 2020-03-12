import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:asker/nav1.dart';
import "package:asker/person.dart";
import "package:asker/answerViewer.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:asker/search/Searchbar.dart';
import "package:loading_animations/loading_animations.dart";
import 'package:asker/replypop_up.dart';

import 'option_post.dart';



int index=0;


class questionPage extends StatefulWidget {
  final uid;
  final curruser;
  questionPage({this.uid,this.curruser});
  @override
  _questionPageState createState() => _questionPageState();

  }
double startpos =0;
class _questionPageState extends State<questionPage> {
  List dataList=[];
  List<dynamic> alldata;
  DocumentSnapshot lastdoc ;

  ScrollController _sre = new ScrollController();
    Future questionlist_future;
    List <Future> person_future;



    @override
  void initState(){



      super.initState();
      print(startpos.toString() + "11111111111111");

      questionlist_future  =getAllQuestions();
//      print("initializing questions");
      _sre.addListener((){

        if(_sre.position.pixels == _sre.position.maxScrollExtent)
        {


          print(_sre.position.pixels );
        questionlist_future  =getAllQuestions();


        print("ser state called  "+ _sre.position.pixels.toString() );

        }


      });

    }

@override
  void dispose() {
    // TODO: implement dispose
  _sre.dispose();
//  dataList= [];
  super.dispose();

  }


    @override
  Widget build(BuildContext context) {




        return Container(
          padding: EdgeInsets.only(top: 60),

        child: Column(

        children: <Widget>[

          Expanded(
            child: FutureBuilder(
              future: questionlist_future,
              builder: (context,snapshotData){
                 alldata=snapshotData.data;
                if(snapshotData.connectionState==ConnectionState.done){

                  print("LIST BUILDER CALLED ");
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                    controller:_sre,
                      itemCount: alldata.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Container(

                          margin: EdgeInsets.only(top: 0, bottom: 0),
                          child: Column(
                            children: <Widget>[
//                      person("${ alldata[index]["uid"]  }"),//Person  old code
                            FutureBuilder(
                            future:getUserDetails(alldata[index]["uid"]),   //getUserDetails got this from person file
                              builder: (context, userData){

                              if(userData.hasData)
                              {
                                return  Container(
                                  padding:EdgeInsets.only(top:2,bottom: 1,left:5) ,
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.all(Radius.circular(15.0),)),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                          radius: 20
                                            ,backgroundImage: NetworkImage("${userData.data[0]}",)),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.only(left:10),
                                          child: Text(
                                            "${userData.data[1]}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 18,
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

                              Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top:10) ,
                                    width: MediaQuery.of(context).size.width-10,
                                    child: FlatButton(
                                      padding: EdgeInsets.only( bottom: 20),
                                      onPressed: () {
                                        setState(() {
                                          questionlist_future  =getAllQuestions();
                                          showDialog(context: context, builder: (context) => answersViewer(widget.uid,alldata[index],DocId: alldata[index]["docid"],user: widget.curruser,)  );

                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(topLeft:  Radius.circular(10) , topRight  : Radius.circular(10) )

                                      ),                                      color: Colors.white,
                                      child: Card(
                                        child: Column(
                                          children: <Widget>[
//                                    Container(
//                                      alignment: Alignment.topRight,
//                                      child: FlatButton(
//                                          onPressed: (){
//                                            showDialog(context: context,builder:(context)=>option_post(data: alldata[index],docid:alldata[index]["docid"] ,));
//
//                                          },
//                                          child: Icon(Icons.brush)),
//                                    ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(left:10),
                                              child: Text(
                                                "${ alldata[index]["question"]  }",
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.fade,
                                                maxLines: 3,
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    color: Colors.black,
                                                    fontSize: 22),

                                              ),

                                            ),
                                            Column(
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                    child: Text("Ansawers  " +ToInt(alldata[index]["noAnswers"]).toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.lightBlue),)),

                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text("TAP TO OPEN ANSWERS",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: RaisedButton(
                                        padding: EdgeInsets.only(
                                            top: 15, bottom: 5, left: 40, right: 40),

                                        color: Colors.blue[800],
                                        onPressed: ()  {

                                          setState(() {
                                            questionlist_future  =getAllQuestions();
                                            showDialog(context: context,child: replypop_up(Curruser: widget.curruser,Docid:alldata[index]["docid"],questionposter: alldata[index]["uid"],));
                                            questionlist_future  =getAllQuestions();


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
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only( bottomLeft :  Radius.circular(10) , bottomRight: Radius.circular(10) )

                        ),

                                  ),
                                  )],
                              ),//Question Card

                            ],
                          ),
                        );

                      });
                }
                else{
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,

                      child: LoadingBouncingLine.circle(size: 50, backgroundColor: Colors.white,)); //loading
                }


              }
            ),
          ),
        ],
      ),
    );

  }
  double lastpostion=0;

  var docs=[];




  getAllQuestions() async {

    if (lastdoc == null)
    {
      print("nulllll");

      await Firestore.instance
          .collection("questions").orderBy("uid").limit(10)
          .snapshots()
          .listen((data) =>
      {


        data.documents.forEach((doc) {
        //  lastpostion =_sre.position.maxScrollExtent;
          docs.add(doc.documentID);
          dataList.add(

              {"answers": doc["answers"],
                "question": doc["question"],
                "uid": doc["uid"],
                "noAnswers": doc["noAnswers"],
                "docid": doc.documentID
              }
          );
          print(doc["question"].toString() + "   TOP answeressssss_____");
          lastdoc   = doc;
        })
      });
      return dataList;
    }
    else{

      print("has data"  + lastdoc.toString());

      await Firestore.instance
          .collection("questions").orderBy("uid").startAfterDocument(lastdoc).limit(10)
          .snapshots()
          .listen((data) =>
      {

        data.documents.forEach((doc) {
          print("printing data  _________________");
        setState(() {





        });

          Timer(Duration(milliseconds: 500), () => _sre.jumpTo(lastpostion));
          lastpostion = _sre.position.maxScrollExtent+20;

          docs.add(doc.documentID);

          dataList.add(

              {"answers": doc["answers"],
                "question": doc["question"],
                "uid": doc["uid"],
                "noAnswers": doc["noAnswers"],
                "docid": doc.documentID
              }
          );

          print(doc["question"].toString() + "answeressssss_____");
          lastdoc     = doc;
        })
      });

      return dataList;



    }
  }


}
