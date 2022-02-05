import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createNote(String title, String content) async {
    try {
      await _firestore.collection('notes').add({
        'title': title,
        'content': content,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (error) {
      print(error);
    }
    // DocumentReference documentReference = _collectionReference.doc(docId);

    // Map<String, dynamic> data = <String, dynamic>{
    //   'title': title,
    //   'content': content,
    //   'time': timeStamp.toDate()
    // };

    // await documentReference
    //     .set(data)
    //     // ignore: avoid_print
    //     .whenComplete(() => print("Notes added"))
    //     // ignore: avoid_print
    //     .catchError((e) => print(e));
  }

  Future<void> updateNotes(String id, String title, String content) async {
    // DocumentReference documentReference = _collectionReference.doc(docId);

    // Map<String, dynamic> updateData = <String, dynamic>{
    //   'title': title,
    //   'content': content,
    //   'time': timeStamp.toDate()
    // };

    try {
      await _firestore.collection('notes').doc(id).update({
        'title': title,
        'content': content,
      });
    } catch (e) {
      print(e);
    }
    //   await documentReference
    //       .update(updateData) // ignore: avoid_print
    //       .then((value) => print('notes updated'))
    //       // // ignore: avoid_print
    //       .catchError((e) => print(e));
    // }

    // Stream<QuerySnapshot> readData() {
    //  String docId = _collectionReference.doc().id;
    // CollectionReference notesItemCollection =
    //    _collectionReference.doc(docId).collection('items');

    //return notesItemCollection.snapshots();
    //}
// }
  }

  Future<void> delete(String id) async {
    try {
      await _firestore.collection('notes').doc(id).delete();
    } catch (e) {
      print(e);
    }
  }
}
