import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uts/Models/Item.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('notes');

class DatabaseF {
  static String userUid;
  static Future<void> addItem({
    String i,
    String name,
    int price,
    int stock,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(i).collection('items').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "price": price,
      "stock": price,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    String name,
    int price,
    int stock,
    String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "price": price,
      "stock": price,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  Stream<QuerySnapshot> readItems(
    String uid
  ) {
    CollectionReference notesItemCollection =
        _mainCollection.doc(uid).collection('items');

    return notesItemCollection.snapshots();
  }

  static Future<void> deleteItem({
    String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
 
}
