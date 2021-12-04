import 'package:flutter/material.dart';


class Terms extends StatelessWidget {
  const Terms({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      var size = MediaQuery
        .of(context)
        .size;
    final double itemWidth = size.width;

    return new Container(
      color: Colors.white,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(100.0, 24.0, 100.0, 10.0),
            child: new Image.asset(
              'assets/intro.png',
              height: 200.0,
              width: itemWidth,
            ),
          ),
          new AppBar(
          title: new Text("back"),
        ),
          new Padding(
            padding: const EdgeInsets.all(30.0),
            child: new Text(
              "Terms And Conditions",
              style: new TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
          new Expanded(
            flex: 1,
            child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,//.horizontal
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: new Text(
                  "1. Willing Members of Loving Hearts CBO must follow rules, guidlines and regulations imposed by respective authority. These rules are subject to change from time to time. "+
                  "                                                                                               "+
                  "                                                                                               "+
                  "2. I will conduct myself in such a manner that will display the highest levels of honesty, integrity and responsibility."+
                  "                                                                               "+
                  "3. Registration and supporting funds will not be refunded."+
                  "                                                                               "+
                  "4. I will be conscious to protect the organization's reputation and property"
                  "",  
                  style: new TextStyle(
                    fontSize: 16.0, color: Colors.black,
                  ),
                ), 
              ),
            ),
          ),
           new Padding(
            padding: const EdgeInsets.all(30.0),
            child: new Text(
              "Invites",
              style: new TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
          new Expanded(
            flex: 1,
            child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,//.horizontal
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: new Text(
                  "1. Activate Your codes by inviting others to duplicate your work. "+
                  "                                                                                               "+
                  "                                                                                               "+
                  "2. By activating your codes, you accept the no refund policy stated above, subsequently you will start earning after the action is fulfilled."+
                  "                                                                               "+
                  "3. Non activated accounts will not earn and therefore only the user is held accountable and not the organization."+
                  "                                                                               "+
                  "",  
                  style: new TextStyle(
                    fontSize: 16.0, color: Colors.black,
                  ),
                ), 
              ),
            ),
          ),
        ],
      ),
    );
  }
}


 