import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hearts/code4.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Code3 extends StatefulWidget {
  @override
  _Code3State createState() => _Code3State();
}

class _Code3State extends State<Code3> {
  String _name = "";

  get mydivider => null;

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<List> getData() async {
    String currentusername = _name;
    final response = await http.get(
        Uri.parse('https://wealthlifeglobal.com/fetchcode.php?username=' +
            currentusername+"_3"),
        headers: {"Accept": "application/json"});
    return jsonDecode(response.body.toString());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshdata,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Code 3"),
          actions: [
            Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
   Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Code4()));
        },
        child: Icon(
            Icons.arrow_right_alt_rounded,
        ),
      )
    ),
          ],
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
                        child: new CircularProgressIndicator(),
                      );
              },
            ),
          ),
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
                title: new Text(
                    list[i]['name'] + ' ${list[i]['mobile']}' ?? 'N/A'),
                leading: new Icon(Icons.person),
                subtitle: new Text("Position : ${list[i]['id']}"),
              ),
            ),
          );
        },
      ),
    );
  }

  Container mydivider() {
    return Container(child: Text('dsd'),);
  }
}
