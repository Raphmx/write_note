import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_write_app/database_firebase.dart';
import 'package:note_write_app/stream.dart';

class WritePage extends StatefulWidget {
  const WritePage({Key? key}) : super(key: key);

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final DatabaseFirebase _databaseFirebase = DatabaseFirebase();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Adding notes',
            onPressed: () {
              setState(() {
                createAndNavigate();
              });
            },
          ),
        ],
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        title: const Text(
          'Write Note',
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
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
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
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          createAndNavigate();
                        },
                        controller: _contentController,
                        style: const TextStyle(
                            fontSize: 20, color: Color(0xFF757575)),
                        minLines: 1,
                        maxLines: 12,
                        maxLength: 200,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            counterStyle: TextStyle(color: Colors.transparent),
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
      ),
    );
  }

  void createAndNavigate() {
    _databaseFirebase.createNote(
        _titleController.text, _contentController.text);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const StreamData(),
        ));
  }
}
