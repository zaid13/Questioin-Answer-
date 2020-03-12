import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:loading_animations/loading_animations.dart";

getUserDetails(uid) async{

  var details=[];
  await Firestore.instance
      .collection("people")
      .document('$uid')
      .get()
      .then((DocumentSnapshot ds) {

    print(ds.data["pic"]);
    details.add(ds["pic"]);
    details.add(ds["name"]);

  });
  return details;
}


class person extends StatefulWidget {
final uid;


  person(this.uid);

  @override
  _personState createState() => _personState();
}

class _personState extends State<person> {
  Future person_future;

  @override
  void initState() {
    person_future = getUserDetails(widget.uid);
    super.initState();
    print("initializing person");

  }
  @override
  Widget build(BuildContext context) {

  //getUserDetails(widget.uid);

    return  FutureBuilder(
      future: person_future,
      builder: (context, userData){

        if(userData.hasData)
          {
            return  Container(

              padding:EdgeInsets.only(top:5,bottom: 5,left:5) ,
              decoration: new BoxDecoration(
                  color: Colors.black87,
                  borderRadius: new BorderRadius.all(Radius.circular(15.0),)
              ),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                      radius: 25
                      ,backgroundImage: NetworkImage("${userData.data[0]}",)),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(left:10),
                      child: Text(
                        "${userData.data[1]}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Open Sans",
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        else{
          return LoadingBouncingLine.circle(size: 50, backgroundColor: Colors.white,); //loading
        }


      },

    );
  }
}
