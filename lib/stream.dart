import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_write_app/database_firebase.dart';
import 'package:note_write_app/update_page.dart';
import 'package:note_write_app/write_page.dart';

class StreamData extends StatefulWidget {
  const StreamData({
    Key? key,
  }) : super(key: key);

  @override
  _StreamDataState createState() => _StreamDataState();
}

class _StreamDataState extends State<StreamData> {
  late DatabaseFirebase databaseFirebase;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    databaseFirebase = DatabaseFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        title: const Text(
          'Write Note',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 12.0,
          left: 8.0,
          right: 8.0,
        ),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notes')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.blue,
                  ),
                );
              }

              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: const Color(0xFFF5F5F5),
                      elevation: 10,
                      child: ListTile(
                        trailing: PopupMenuButton(
                          color: const Color(0xFFF5F5F5),
                          padding: const EdgeInsets.only(left: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          onSelected: (value) {
                            setState(() {
                              if (value == 0) {
                                databaseFirebase.delete(doc.id);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0)),
                                  backgroundColor: const Color(0xFF1565C0),
                                  content: Row(
                                    children: const [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          child: Text(
                                        'Message is deleted',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(fontSize: 18),
                                      ))
                                    ],
                                  ),
                                ));
                              }
                            });
                          },
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem<dynamic>(
                                child: Center(
                                  child: Text(
                                    'Delete',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color(0xFF1565C0),
                                    ),
                                  ),
                                ),
                                value: 0,
                              )
                            ];
                          },
                          icon: const Icon(Icons.more_vert_outlined,
                              color: Color(0xFF1565C0)),
                        ),
                        onTap: () => setState(() {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return UpdatePage(
                                doc: doc,
                                databaseFirebase: databaseFirebase,
                              );
                            },
                          ));
                        }),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 25),
                        title: Text(
                          doc['title'],
                          maxLines: 1,
                          style: const TextStyle(
                              color: Color(0xFF1565C0),
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                        ),
                        subtitle: Text(
                          doc['content'],
                          maxLines: 1,
                          style: const TextStyle(
                              color: Color(0xFF1565C0), fontSize: 16),
                        ),
                      ),
                    );
                  });
            }),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue.shade800,
          child: const Icon(
            Icons.note_add,
            size: 25,
          ),
          onPressed: () => setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const WritePage()));
              })),
    );
  }
}
