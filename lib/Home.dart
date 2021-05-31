import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uts/botNav.dart';
import 'dart:async';
import 'FireDatabase/Database.dart';
import 'DbHelper/DbHelper.dart';
import 'EntryForm.dart';
import 'Models/Item.dart';
import 'Models/UserSql.dart';

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
  final CollectionReference _mainCollection = firestore.collection('notes');
  final List<Widget> _children = [];
  DbHelper dbHelper = DbHelper();
  int count = 0;
  int countUser = 0;
  List<Item> itemList;
  List<UserSql> userList;
  List<String> listItem = ["Delete", "Update"];
  String _newValuePerem = "";
  @override
  Widget build(BuildContext context) {
    String i = widget.id;
    //int id = userArgs.id;
    if (itemList == null) {
      itemList = List<Item>();
    }
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
              var item = await navigateToEntryForm(context, null, i);
              if (item != null) {
                int result = await dbHelper.insert(item);
                if (result > 0) {
                  updateListView(i);
                }
              }
            },
          ),
        ),
      ]),
    );
  }

  Future<Item> navigateToEntryForm(
      BuildContext context, Item item, String id) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(item, id);
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
            child: Text('Loading',style: TextStyle(fontWeight: FontWeight.bold)));
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
                          dbHelper.delete(this.itemList[index].id);
                          updateListView(a);
                        } else if (changeValue == "Update") {
                          var item = await navigateToEntryForm(
                              context, this.itemList[index], a);

                          dbHelper.update(item);
                          updateListView(a);
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

  ListView createListView(String id) {
    updateListView(id);
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.cake_rounded),
            ),
            title: Text(
              this.itemList[index].name,
              style: textStyle,
            ),
            subtitle: Text(this.itemList[index].stock.toString()),
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
                    dbHelper.delete(this.itemList[index].id);
                    updateListView(id);
                  } else if (changeValue == "Update") {
                    var item = await navigateToEntryForm(
                        context, this.itemList[index], id);

                    dbHelper.update(item);
                    updateListView(id);
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

  ListView createListViewUser(int id) {
    updateUserView(id);
    return ListView.builder(
      itemCount: countUser,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.cyan[200],
          elevation: 3.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.account_balance),
            ),
            title: Text(
              userList[index].name,
              style: TextStyle(fontSize: 25),
            ),
            subtitle: Text(userList[index].id.toString(),
                style: TextStyle(fontSize: 25)),
          ),
        );
      },
    );
  }

//update List item
  void updateUserView(int id) {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<UserSql>> userListFuture = dbHelper.getUserList(id);
      userListFuture.then((userList) {
        setState(() {
          this.userList = userList;
          this.countUser = userList.length;
        });
      });
    });
  }

  //update List item
  void updateListView(String idUser) {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Item>> itemListFuture = dbHelper.getItemList(idUser);
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
