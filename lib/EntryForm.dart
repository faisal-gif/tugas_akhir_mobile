import 'package:flutter/material.dart';
import 'FireDatabase/Database.dart';


class EntryForm extends StatefulWidget {
  final String name;
  final int price;
  final int stock; 
  final String id;
  final String docId;
  EntryForm(this.name,this.price,this.stock,this.id,this.docId);
  @override
  EntryFormState createState() => EntryFormState(this.name,this.price,this.stock,id,docId);
}

//class controller
class EntryFormState extends State<EntryForm> {
  String name;
  int price;
  int stock; 
  String id;
  String docId;
  EntryFormState(this.name,this.price,this.stock,this.id,this.docId);
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //kondisi
    if (name != null) {
      nameController.text = name;
      priceController.text = price.toString();
      stockController.text = stock.toString();
    }
    //rubah
    return Scaffold(
        appBar: AppBar(
          title: Text('Barang') ,
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
                  controller: nameController,
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
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Harga',
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
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    hintText: 'Kg',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
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
                         
                          if (name == null) {
                            // tambah data
                             DatabaseF.addItem(
                                i: id,
                                name: nameController.text,
                                price: int.parse(priceController.text),
                                stock : int.parse(stockController.text));
                          } else {
                            // ubah data
                            DatabaseF.updateItem(
                              uid: id,
                              name:nameController.text,
                              price: int.parse(priceController.text),
                              stock: int.parse(stockController.text),
                              docId:  docId);
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
