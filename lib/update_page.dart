import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_write_app/database_firebase.dart';
import 'package:note_write_app/stream.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference noteRef = _firestore.collection('notes');

class UpdatePage extends StatefulWidget {
  final DatabaseFirebase databaseFirebase;

  final DocumentSnapshot doc;

  const UpdatePage({required this.doc, required this.databaseFirebase});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.doc['title'];
    _contentController.text = widget.doc['content'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const StreamData(),
                    ));
              }),
          actions: [
            IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  setState(() {
                    update();
                  });
                }),
          ],
          backgroundColor: Colors.blue.shade800,
          centerTitle: true,
          title: const Text(
            "Update Note",
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _titleController,
                          style: const TextStyle(
                              fontSize: 20, color: Color(0xFF757575)),
                          maxLength: 25,
                          maxLines: 1,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: const InputDecoration(
                              counterStyle: TextStyle(color: Colors.grey),
                              border: UnderlineInputBorder(),
                              hintText: 'Type your title',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          onFieldSubmitted: (value) {
                            update();
                          },
                          textInputAction: TextInputAction.done,
                          controller: _contentController,
                          style: const TextStyle(
                              fontSize: 20, color: Color(0xFF757575)),
                          minLines: 1,
                          maxLines: 12,
                          maxLength: 200,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              counterStyle:
                                  TextStyle(color: Colors.transparent),
                              border: InputBorder.none,
                              hintText: 'Type your messages',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ));
  }

  void update() {
    widget.databaseFirebase.updateNotes(
      widget.doc.id,
      _titleController.text,
      _contentController.text,
    );

    Navigator.pop(context, true);
  }
}
