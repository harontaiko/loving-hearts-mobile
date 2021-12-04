import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hearts/paidusers.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

/// This is the stateless widget that the main application instantiates.

class Mpesa extends StatefulWidget {
  const Mpesa({Key? key}) : super(key: key);

  @override
  _MpesaState createState() => _MpesaState();
}

class _MpesaState extends State<Mpesa> {
  String _num = "";
  String _reg = "";
  double _amount = 1000.0;

  @override
  void initState() {
    super.initState();
    _getPhone();
    _getReg();
  }

  // ignore: unused_field
  String _res = "";
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String phpurl = "https://wealthlifeglobal.com/saveRegistration.php";

  Future<void> senddata() async {
    var res = await http.post(Uri.parse(phpurl), body: {
      "transaction_id": getRandomString(10).toString(),
      'from': _num,
      'to': 'company',
      'amount': _amount.toString(),
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"reg": "true"}).then((result) {
      print("new USer true");
    }).catchError((onError) {
      print("onError");
    });

    _res = res.body;
  }

  Future<void> _refreshAllData() async {
    //pull users, balance, top earner
    _getPhone();
    _getReg();
  }

  _refreshAction() {
    _getReg();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    senddata();
    return RefreshIndicator(
      onRefresh: _refreshAllData,
      child: MaterialApp(
        theme: ThemeData(primaryColor: Color(0xFF481E4D)),
        home: Scaffold(
          appBar: new AppBar(
            title: new Text("Registration Payment"),
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaidUsers()));
                      },
                      child: _reg == "true"
                          ? Icon(
                              Icons.arrow_right_alt_rounded,
                            )
                          : Text(''))),
            ],
          ),
          body: Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue.shade400),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10.0),
                                )
                              )
              ),
                onPressed: () {
                  lipaNaMpesa(_num, _amount);
                },
                child: Text(
                  "pay ksh 1000",
                  style: TextStyle(color: Colors.white),
                )),
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: _refreshAction,
            tooltip: 'refresh',
            child: new Icon(Icons.refresh),
          ),
        ),
      ),
    );
  }

  Future<void> _getPhone() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        _num = value.data()!['phone'].toString();
        print(FirebaseAuth.instance.currentUser!.uid);
      });
    });
  }

  Future<void> _getReg() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        _reg = value.data()!['reg'];
        print(FirebaseAuth.instance.currentUser!.uid);
      });
    });
  }
}

//create the lipaNaMpesa method here.Please note, the method can have any name, I chose lipaNaMpesa
Future<void> lipaNaMpesa(String num, double tamount) async {
  MpesaFlutterPlugin.setConsumerKey('gzQDoAeZIUuYYU4uoO4CCIERkZ8KzEsT');
  MpesaFlutterPlugin.setConsumerSecret('BscLrfQDQgEqecfy');
  dynamic transactionInitialisation;
  try {
    transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
        businessShortCode: "4075931",
        transactionType: TransactionType.CustomerPayBillOnline,
        amount: 1000.0,
        partyA: num,
        partyB: "4075931",
//Lipa na Mpesa Online ShortCode
        callBackURL: Uri(
          scheme: 'https',
          host: 'us-central1-lovinghearts-f590c.cloudfunctions.net',
          path: '/receiveCallback',
        ),
//This url has been generated from http://mpesa-requestbin.herokuapp.com/?ref=hackernoon.com for test purposes
        accountReference: "LOVING HEARTS CBO",
        phoneNumber: num,
        baseUri: Uri(scheme: "https", host: "api.safaricom.co.ke"),
        transactionDesc: "Registration Fee",
        passKey:
            "915fa1beae5bebc44fe96852e5a01ce0b3986d5f7695d95d811c75df5f26b954");
//This passkey has been generated from Test Credentials from Safaricom Portal
    //save transaction to db
    print("TRANSACTION RESULT: " + transactionInitialisation.toString());

    return transactionInitialisation;
  } catch (e) {
    print("CAUGHT EXCEPTION: " + e.toString());
  }
}
