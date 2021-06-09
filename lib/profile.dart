import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'FireDatabase/Database.dart';

import 'EntryMoney.dart';

//pendukung program asinkron
class Profile extends StatefulWidget {
  @override
  static String tag = 'home-page';
  final user;
  Profile(this.user);
  ProfileState createState() => ProfileState();
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;

String i;
int money;

class ProfileState extends State<Profile> {
  List<String> listItem = ["Delete", "Update"];
  String _newValuePerem = "";
  @override
  Widget build(BuildContext context) {
    User use = widget.user;
    i = use.uid;

    String nama = use.email.substring(0, use.email.indexOf("@"));
    //int id = userArgs.id;

    return Scaffold(
      body: Column(children: [
        Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text(use.email,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
              subtitle: Text('Nama = ' + nama),
            )),
        SizedBox(height: 8.0),
Text('Uang'),
        Expanded(
          child: fireList(i),
        ),
        coba(),
      ]),
    );
  }

  Future<DatabaseF> navigateToEntryMoney(
      BuildContext context, int money, String id, String docId) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryMoney(money, id, docId);
    }));
    return result;
  }

  Container coba() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: RaisedButton(
        child: Text('Ubah keungan'),
        onPressed: () async {
          var item = await navigateToEntryMoney(context, null, i, null);
        },
      ),
    );
  }

  StreamBuilder fireList(String a) {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseF().readUang(a),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              alignment: Alignment.center,
              child: Text('Loading',
                  style: TextStyle(fontWeight: FontWeight.bold)));
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              var noteInfo = snapshot.data.docs[index].data();
              String docID = snapshot.data.docs[index].id;

              money = noteInfo['uang'];

              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  title: Text(
                    money.toString(),
                    style: textStyle,
                  ),
                  onTap: () async {
                    await navigateToEntryMoney(context, money, a, docID);
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
