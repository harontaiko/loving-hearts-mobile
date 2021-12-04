import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hearts/Login.dart';
import 'package:hearts/home.dart';
import 'package:hearts/mycode.dart';
import 'package:hearts/profile.dart';
import 'package:hearts/settings.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  String _num = "";

  int _selectedIndex = 0;

  get mydivider => null;

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<List> getData() async {
    String currentphone = _num;
    final response = await http.get(
        Uri.parse('https://wealthlifeglobal.com/fetchtransactions.php?phone='+currentphone),
        headers: {"Accept": "application/json"});
    return jsonDecode(response.body.toString());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshdata,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Transactions"),
        ),
        body: Container(
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
        bottomNavigationBar: _bottomNavTab(),
      ),
    );
  }

  Future<void> _getUserName() async {
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

  Future<void> _refreshdata() async {
    //pull users, balance, top earner
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
      case 3:
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
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({required this.list, List? title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView.builder(
        // ignore: unnecessary_null_comparison
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return new Container(
            padding: const EdgeInsets.all(10.0),
            child: new Card(
              child: new ListTile(
                title: new Text('From: '+' ${list[i]['from']}, \nTo: ${list[i]['to']} \nksh ${list[i]['amount']}, \non: ${list[i]['tr_date']}'),
                leading: new Icon(Icons.money_outlined),
                subtitle: new Text("Mpesa : ${list[i]['transaction_id']}"),
              ),
            ),
          );
        },
      ),
    );
  }

}
