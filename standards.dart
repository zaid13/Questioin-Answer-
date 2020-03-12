import "package:flutter/material.dart";


void standardDialog(BuildContext context,{@required String text})
{
  showDialog(
    context: context,
    child: Center(
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(right:20,left:20,top:200,bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "$text",
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  //letterSpacing: 3,
                  fontFamily: 'OpenSans',
                  color: Colors.red,
                  fontSize: 20),
            ),
          /*  Text(
              "Try Again",
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  //letterSpacing: 3,
                  fontFamily: 'OpenSans',
                  color: Colors.red,
                  fontSize: 15),
            ),

           */
            Container(margin: EdgeInsets.only(top:50),child:Container(
                margin: EdgeInsets.only(top: 40),
                child: RaisedButton(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 20, left: 40, right: 40),
                    color: Colors.redAccent,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 25),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(12))))),)
          ],
        )
      ),
    ),
  );
}