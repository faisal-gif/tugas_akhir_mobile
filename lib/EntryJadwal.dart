import 'package:flutter/material.dart';
import 'FireDatabase/Database.dart';


class EntryJadwal extends StatefulWidget {
  final String barang;
  final String tanggal;
  final String id;
  final String docId;
  EntryJadwal(this.barang, this.tanggal, this.id, this.docId);
  @override
  EntryJadwalState createState() =>
      EntryJadwalState(this.barang, this.tanggal, id, docId);
}

//class controller
class EntryJadwalState extends State<EntryJadwal> {
  String barang;
  String tanggal;
  String id;
  String docId;
  EntryJadwalState(this.barang, this.tanggal, this.id, this.docId);
  TextEditingController barangController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //kondisi
    if (barang != null) {
      barangController.text = barang;
      tanggalController.text = tanggal;
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
                  controller: barangController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nama Barang',
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
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: tanggalController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Tanggal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              //stock

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
                          if (barang == null) {
                            // tambah data
                            DatabaseF.addNote(
                              i: id,
                              barang: barangController.text,
                              tanggal: tanggalController.text,
                            );
                          } else {
                            // ubah data
                            DatabaseF.updateJadwal(
                                uid: id,
                                barang: barangController.text,
                                tanggal: tanggalController.text,
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
