import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uts/EntryJadwal.dart';
import 'dart:async';
import 'FireDatabase/Database.dart';



//pendukung program asinkron
class Jadwal extends StatefulWidget {
  @override
  static String tag = 'jadwal-page';
  final id;
  Jadwal(this.id);
  JadwalState createState() => JadwalState();
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class JadwalState extends State<Jadwal> {
  
  List<String> listItem = ["Delete", "Update"];
  String _newValuePerem = "";
  @override
  Widget build(BuildContext context) {
    String i = widget.id;
   
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
                  await navigateToEntryJadwal(context, null, null, i, null);
            },
          ),
        ),
      ]),
    );
  }
//untuk menavigasi ke EntryFormJadwal
  Future<DatabaseF> navigateToEntryJadwal(BuildContext context, String barang,
      String tanggal, String id, String docId) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryJadwal(barang, tanggal, id, docId);
    }));
    return result;
  }

//untuk menampilkan data yang diambil dari firestore
  StreamBuilder fireList(String a) {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseF().readJadwal(a),
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
              String barang = noteInfo['barang'];
              String tanggal = noteInfo['tanggal'];

              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.cake_rounded),
                  ),
                  title: Text(
                    barang,
                    style: textStyle,
                  ),
                  subtitle: Text(tanggal.toString()),
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
                          DatabaseF.deleteJadwal(uid: a, docId: docID);
                        } else if (changeValue == "Update") {
                          await navigateToEntryJadwal(
                              context, barang, tanggal, a, docID);
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
