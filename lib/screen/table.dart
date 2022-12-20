import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Table extends StatefulWidget {
  const Table({super.key});

  @override
  State<Table> createState() => _TableState();
}

class _TableState extends State<Table> {
  final Stream<QuerySnapshot> _tableStream = FirebaseFirestore.instance
      .collection('hhccmessages')
      .orderBy('timestamp', descending: true)
      .snapshots();
  CollectionReference deleteMail =
      FirebaseFirestore.instance.collection('hhccmessages');

  // Future deleteMail(mailId){return firebaseDelete.doc(mailId)
  // .delete()
  //         .then((value) => print("User Deleted"))
  //       .catchError((error) => print("Failed to delete user: $error"));
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribers'),
        backgroundColor: Colors.red,
      ),
      body: Text('table'),
    );
  }
}
