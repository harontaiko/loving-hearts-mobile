import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hearts/home.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaidUsers extends StatefulWidget {
  @override
  _PaidUsersState createState() => _PaidUsersState();
}

class _PaidUsersState extends State<PaidUsers> {

    String _name = "";

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<List> getData() async {
        String currentName = _name;
    final response = await http.get(
        Uri.parse('https://wealthlifeglobal.com/fetchPaidUsers.php?n='+currentName),
        headers: {"Accept": "application/json"});
    return jsonDecode(response.body.toString());
  }

  Future<List> deleteTemp() async {
     String name = _name;
    final response = await http.post(
        Uri.parse('https://wealthlifeglobal.com/DeleteTemp.php?n='+name),
        headers: {"Accept": "application/json"});
        //update balances of users
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
    return jsonDecode(response.body.toString());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshdata,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Pay to complete process"),
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
                        child: new Text("..."),
                      );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Confirm payment"),
          icon: Icon(Icons.arrow_forward_sharp),
          onPressed: () => deleteTemp(),
        ),
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
        _name = value.data()!['username'].toString();
        print(FirebaseAuth.instance.currentUser!.uid);
      });
    });
  }

  Future<void> _refreshdata() async {
    //pull users, balance, top earner
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
                title: new Text('Name: ' +
                    ' ${list[i]['name']}, \ntel: ${list[i]['mobile']}\n${list[i]['sponsor_id']}'),
                leading: new Icon(Icons.payments),
                subtitle: new Text("Pay : 500/=",style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }
}
