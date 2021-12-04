import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hearts/code3.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Code2 extends StatefulWidget {
  @override
  _Code2State createState() => _Code2State();
}

class _Code2State extends State<Code2> {
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
            currentusername+"_2"),
        headers: {"Accept": "application/json"});
    return jsonDecode(response.body.toString());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshdata,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Code 2"),
          actions: [
            Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
   Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Code3()));
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
