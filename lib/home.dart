import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hearts/Login.dart';
import 'package:hearts/auth.dart';
import 'package:hearts/mycode.dart';
import 'package:hearts/profile.dart';
import 'package:hearts/settings.dart';
import 'package:hearts/transcations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

import 'package:share_plus/share_plus.dart';

enum ButtonType { payBills, donate, receiptients, offers }
enum TransactionType { sent, received, pending }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: unused_field
  final AuthService _auth = AuthService();
  // ignore: unused_field
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final formatter = intl.NumberFormat.decimalPattern();

  String _name = '';
  String _phone = '';
  String _email = '';
  String _balance = '';
  // ignore: unused_field
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

  // ignore: unused_element
  Future<void> _refreshAllData() async {
    //pull users, balance, top earner
    _getUserName();
    _getUserEmail();
    _getUserPhone();
    _getBalance();
    _getUserCount();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(19),
                    color: Colors.purple[300],
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Hey " + _name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "What would you do like to do today ?",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 5.0,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/customer.jpg'),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        SendReceiveSwitch(
                          balance: _balance,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(21),
                    color: Color(0xfff4f5f9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          child: CustomButton(buttonType: ButtonType.payBills, onPressed: _openCodes,),
                        ),
                        Flexible(
                          child: CustomButton(buttonType: ButtonType.donate, onPressed: _share,),
                        ),
                        Flexible(
                          child:
                              CustomButton(buttonType: ButtonType.receiptients, onPressed:_openProfile,),
                        ),
                        Flexible(
                          child: CustomButton(buttonType: ButtonType.offers, onPressed:_openTransactions),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(21.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "RECENT TRANSACTIONS",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: new FutureBuilder<List>(
                          future: getData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);

                            return snapshot.hasData
                                ? new ItemList(
                                    list: snapshot.data ?? [],
                                  )
                                : new Center(
                                    child: new Text("No Transactions"),
                                  );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _bottomNavTab(),
      ),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyCode()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Signin()));
        break;
    }
  }

  Widget _bottomNavTab() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      unselectedItemColor: Theme.of(context).primaryColor,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
          activeIcon: Icon(Icons.home_filled),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle),
          label: "Profile",
          activeIcon: Icon(Icons.verified_user_sharp),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: "Codes",
          activeIcon: Icon(Icons.receipt_long_outlined),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
          activeIcon: Icon(Icons.settings_applications_outlined),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: "logout",
          activeIcon: Icon(Icons.logout_rounded),
        ),
      ],
    );
  }

  Future<void> _share() async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    await Share.share(
        'download loving hearts on google playstore https://play.google.com/store/apps/details?id=com.lovinghearts.foodybite_app, register and use the sponsor name ' +
            _name,
        subject: 'use sponsor name' + _name);
  }

  Future<List> getData() async {
    String currentphone = _phone;
    final response = await http.get(
        Uri.parse('https://wealthlifeglobal.com/fetchtransactions.php?phone=' +
            currentphone),
        headers: {"Accept": "application/json"});
    return jsonDecode(response.body.toString());
  }

  Future<void> _openCodes() async {
      Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyCode()));
  }

   Future<void> _openTransactions() async {
      Navigator.push(
            context, MaterialPageRoute(builder: (context) => Transactions()));
  }

  Future<void> _openProfile() async {
      Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
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

// ignore: must_be_immutable
class ItemList extends StatelessWidget {
  final List list;

  var transactionInfo;
  ItemList({required this.list, List? title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView.builder(
        // ignore: unnecessary_null_comparison
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return new Transaction(
            transactionType: TransactionType.sent,
            transactionAmout: list[i]['amount'],
            transactionInfo: 'MPESA',
            transactionDate: list[i]['from'],
            receptient: list[i]['transaction_id'],
          );
        },
      ),
    );
  }
}

class Transaction extends StatelessWidget {
  final TransactionType transactionType;
  final String transactionAmout, transactionInfo, transactionDate, receptient;
  const Transaction(
      {Key? key,
      required this.transactionType,
      required this.transactionAmout,
      required this.transactionInfo,
      required this.transactionDate,
      required this.receptient})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String transactionName;
    IconData transactionIconData;
    Color color;
    switch (transactionType) {
      case TransactionType.sent:
        transactionName = "company";
        transactionIconData = Icons.arrow_upward;
        color = Theme.of(context).primaryColor;
        break;
      case TransactionType.received:
        transactionName = "Received";
        transactionIconData = Icons.arrow_downward;
        color = Colors.green;
        break;
      case TransactionType.pending:
        transactionName = "Pending";
        transactionIconData = Icons.arrow_downward;
        color = Colors.orange;
        break;
    }
    return Container(
      height: 70.0,
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.all(9.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.black12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset('assets/customer.jpg')),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 15.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      child: Icon(
                        transactionIconData,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 5.0),
          Flexible(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      receptient,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\ksh $transactionAmout",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "$transactionInfo - $transactionDate",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Text(
                      "$transactionName",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SendReceiveSwitch extends StatelessWidget {
  final String balance;

  SendReceiveSwitch({Key? key, required this.balance}) : super(key: key);

  final formatter = intl.NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white54,
      ),
      padding: EdgeInsets.all(21.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Earnings:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "\ksh " + balance,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final ButtonType buttonType;
  final VoidCallback onPressed;
  const CustomButton({
    Key? key,
    required this.buttonType, required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String buttonText = "", buttonImage;
    switch (buttonType) {
      case ButtonType.payBills:
        buttonText = "Codes";
        buttonImage = "assets/receipt.png";
        break;
      case ButtonType.donate:
        buttonText = "Sell slot";
        buttonImage = "assets/sell.png";
        break;
      case ButtonType.receiptients:
        buttonText = "My profile";
        buttonImage = "assets/customer.jpg";
        break;
      case ButtonType.offers:
        buttonText = "transactions";
        buttonImage = "assets/transaction.png";
        break;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:this.onPressed,
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(17),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  gradient: LinearGradient(
                    colors: [Colors.white10, Colors.black12],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.asset(
                  buttonImage,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              FittedBox(
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Money"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Select Payee",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, payees) {
                return ListTile(
                  title: PayeeContainer(),
                  onTap: () {},
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class PayeeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "https://cdn.pixabay.com/photo/2017/11/02/14/26/model-2911329_960_720.jpg",
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: Container(
              padding: EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "John Doe",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "+213123456789",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
