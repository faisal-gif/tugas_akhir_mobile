import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'FireDatabase/Database.dart';
import 'EntryForm.dart';


//pendukung program asinkron
class Home extends StatefulWidget {
  @override
  static String tag = 'home-page';
  final id;
  Home(this.id);
  HomeState createState() => HomeState();
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class HomeState extends State<Home> {
 
  List<String> listItem = ["Delete", "Update"];
  String _newValuePerem = "";
  @override
  Widget build(BuildContext context) {
    String i = widget.id;
    //int id = userArgs.id;
   
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: fireList(i),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              var item =
                  await navigateToEntryForm(context, null, null, null, i, null);
            
            },
          ),
        ),
      ]),
    );
  }

  Future<DatabaseF> navigateToEntryForm(BuildContext context, String name, int price,
      int stock, String id, String docId) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(name, price, stock, id, docId);
    }));
    return result;
  }

  StreamBuilder fireList(String a) {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseF().readItems(a),
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
              String name = noteInfo['name'];
              int price = noteInfo['price'];
              int stock = noteInfo['stock'];

              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.cake_rounded),
                  ),
                  title: Text(
                    name,
                    style: textStyle,
                  ),
                  subtitle: Text(stock.toString()),
                  trailing: GestureDetector(
                    child: DropdownButton<String>(
                      underline: SizedBox(),
                      icon: Icon(Icons.menu),
                      items: listItem.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String changeValue) async {
                        if (changeValue == "Delete") {
                         DatabaseF.deleteItem(uid: a,docId: docID);
                        } else if (changeValue == "Update") {
                          await navigateToEntryForm(
                              context, name, price, stock, a, docID);
                        }
                        ;
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}