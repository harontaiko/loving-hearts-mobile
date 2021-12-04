import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hearts/Login.dart';
import 'package:hearts/auth.dart';
import 'package:hearts/loading.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hearts/mycode.dart';
import 'package:hearts/profile.dart';
import 'package:hearts/settings.dart';
import 'package:hearts/transcations.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';


class HomePage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  final AuthService _auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _name = '';
  String _phone = '';
  String _email = '';
  String _balance = '';
  String _usercount = '';

  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);

  bool loading = false;

  String username = "";

  String verifyText = "";

  // ignore: unused_field
  String _res = "";

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getUserEmail();
    _getUserPhone();
    _getBalance();
    _getUserCount();
  }

  //run an update query to set 4th row to user data
  String phpurl = "https://wealthlifeglobal.com/updateslot.php";

  Future<void> updateslot() async {
    var res = await http.post(Uri.parse(phpurl), body: {
      'username': _name,
      'phone': _phone,
      'email': _email,
    });

    _res = res.body;
  }

  Future<void> _refreshAllData() async {
    //pull users, balance, top earner
    _getUserName();
    _getUserEmail();
    _getUserPhone();
    _getBalance();
    _getUserCount();
  }

  @override
  Widget build(BuildContext context) {

    updateslot();
    return loading
        ? Loading()
        : RefreshIndicator(
            onRefresh: _refreshAllData,
            child: Container(
              child: Scaffold(
                appBar: AppBar(),
                drawer: Container(
                  width: 300,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(180, 250, 250, 250),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(31, 38, 135, 0.4),
                        blurRadius: 8.0,
                      )
                    ],
                    border: Border(
                      right: BorderSide(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 4.0,
                              sigmaY: 4.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.grey.withOpacity(0.0),
                                  Colors.white.withOpacity(0.2),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          DrawerHeader(
                            child: Row(
                              children: [
                                Hero(
                                  tag: 'customer',
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          AssetImage('assets/customer.jpg'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text(_name)
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  },
                                  leading: Icon(
                                    Icons.home,
                                    color: Colors.black,
                                  ),
                                  title: Text("dashboard"),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()));
                                  },
                                  leading: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  title: Text("Profile"),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsPage()));
                                  },
                                  leading: Icon(
                                    Icons.settings,
                                    color: Colors.black,
                                  ),
                                  title: Text("Settings"),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyCode()));
                                  },
                                  leading: Icon(
                                    Icons.list,
                                    color: Colors.black,
                                  ),
                                  title: Text("my Codes"),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Transactions()));
                                  },
                                  leading: Icon(
                                    Icons.money,
                                    color: Colors.black,
                                  ),
                                  title: Text("Transactions"),
                                ),
                                ListTile(
                                  onTap: () {
                                    _firebaseAuth.signOut();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Signin()),
                                    );
                                  },
                                  leading: Icon(
                                    Icons.logout,
                                    color: Colors.black,
                                  ),
                                  title: Text("Log Out"),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 30.0, right: 15.0, left: 15.0),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 1.0),
                          child: Card(
                            color: Colors.amber,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5.0, 6.0, 5.0, 6.0),
                              child: Text(verifyText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  )),
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 30.0),
                          child: Text(_name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 35.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          width: double.infinity,
                          height: 370.0,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0.0, 0.3),
                                    blurRadius: 15.0)
                              ]),
                          child: CustomScrollView(
                            primary: false,
                            slivers: <Widget>[
                              SliverPadding(
                                padding: const EdgeInsets.all(20),
                                sliver: SliverGrid.count(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2,
                                  children: <Widget>[
                                    Container(
                                      child: Card(
                                          elevation: 20,
                                          color: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: SizedBox(
                                            width: 300,
                                            height: 200,
                                            child: Center(
                                                child: Text(_balance + ' ksh',
                                                    style: TextStyle(
                                                        fontSize: 15))),
                                          )),
                                    ),
                                    Container(
                                      child: Card(
                                          elevation: 20,
                                          color: Colors.cyan,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: SizedBox(
                                            width: 300,
                                            height: 200,
                                            child: Center(
                                                child: Text('Codes:4',
                                                    style: TextStyle(
                                                        fontSize: 15))),
                                          )),
                                    ),
                                    Container(
                                      child: Card(
                                          elevation: 20,
                                          color: Colors.red[300],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: SizedBox(
                                            width: 300,
                                            height: 200,
                                            child: Center(
                                                child: Text(
                                                    'Users ' + _usercount,
                                                    style: TextStyle(
                                                        fontSize: 15))),
                                          )),
                                    ),
                                    Container(
                                      child: Card(
                                          elevation: 20,
                                          color: Colors.tealAccent[400],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: SizedBox(
                                              width: 300,
                                              height: 200,
                                              child: Center(
                                                  child: GestureDetector(
                                                onTap: () => share(),
                                                child: 
                                                Text(
                                                  "sell slot",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )))),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Padding(
                        padding: EdgeInsets.fromLTRB(24.0, 0.0, 1.0, 0.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Transactions()));
                          },
                          child: Text(
                            "My Transactions ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  void share() async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
     await Share.share('download loving hearts on google playstore https://play.google.com/store/apps/details?id=com.lovinghearts.foodybite_app, register and use the sponsor name '+_name, subject: 'use sponsor name'+_name);
    
  }

  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        _name = value.data()!['username'].toString();
      });
    });
  }

  Future<void> _getUserPhone() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        _phone = value.data()!['phone'].toString();
      });
    });
  }

  Future<void> _getUserEmail() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        _email = value.data()!['email'].toString();
      });
    });
  }

  Future<void> _getBalance() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        _balance = value.data()!['balance'].toString();
      });
    });
  }

  Future<void> _getUserCount() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      setState(() {
        _usercount = value.size.toString();
      });
    });
  }
}

class ClickPerMonth {
  final String month;
  final int clicks;
  final charts.Color color;

  ClickPerMonth(this.month, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
