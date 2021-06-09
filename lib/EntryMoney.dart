import 'package:flutter/material.dart';
import 'FireDatabase/Database.dart';


class EntryMoney extends StatefulWidget {
  
  final int money;
  final String id;
  final String docId;
  EntryMoney( this.money, this.id, this.docId);
  @override
  EntryMoneyState createState() =>
      EntryMoneyState(this.money,id, docId);
}

//class controller
class EntryMoneyState extends State<EntryMoney> {
  int money;
  String id;
  String docId;
  EntryMoneyState( this.money, this.id, this.docId);
  TextEditingController moneyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int moneyAkhir;
    //kondisi
    if (money != null) {
     moneyAkhir = money;
     
    }
    //rubah
    return Scaffold(
        appBar: AppBar(
          title:  Text('Jadwal'),
          leading: Icon(Icons.keyboard_arrow_left),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              // nama
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: moneyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tambah Uang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              // harga
            
              // tombol button
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    // tombol simpan
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (money == null) {
                            // tambah data
                            DatabaseF.addUang(
                              i: id,
                              uang: int.parse(moneyController.text),
                             
                            );
                          } else {
                            // ubah data
                            DatabaseF.updateUang(
                                uid: id,
                                uang: moneyAkhir+int.parse(moneyController.text),
                                docId: docId);
                          }
                          // kembali ke layar sebelumnya dengan membawa objek item
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    // tombol batal
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
