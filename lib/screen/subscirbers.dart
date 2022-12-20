import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Subscribers extends StatefulWidget {
  Subscribers({
    super.key,
    // this.message,
    // this.documentID,
  });
  // final String? documentID;
  // final String? message;
  @override
  State<Subscribers> createState() => _SubscribersState();
}

late String document;

class _SubscribersState extends State<Subscribers> {
  var fromEdit = Get.arguments;
  TextEditingController subscribe = TextEditingController();
  String emailEntry = "";
  List receivedMail = [];
  int totalPrice = 0;
  var totalPrice2 = 0;
  String price = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    document = fromEdit[1].toString();
    print(document);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // final Stream<DocumentSnapshot> _tableStream = FirebaseFirestore.instance
  //     .collection('hhccmessages')
  //     .doc()
  //     // .orderBy('timestamp', descending: true) /////'s5y2m01JvgL6kxg7UlPh'
  //     .snapshots();
  // final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
  //     .collection('hhccmessages')
  //     .doc(document)
  //     .snapshots() as Stream<QuerySnapshot<Object?>>;

  Future addMail(emailEntry) => FirebaseFirestore.instance
          .collection('hhccmessages')
          .doc(fromEdit[0].toString())
          .update({
        'email': FieldValue.arrayUnion([emailEntry])
      }).then((value) => setState(() {
                emailEntry = "";
              }));
  Future deleteMail(toDelete) => FirebaseFirestore.instance
          .collection('hhccmessages')
          .doc(fromEdit[0].toString())
          .update({
        'email': FieldValue.arrayRemove([toDelete.toString()])
      }).then((value) => print('deleted succesfully'));
  void enterSubscriber(context) {
    print('PreacherName');
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            content: TextField(
              controller: subscribe,
              maxLength: 50,
              onChanged: (value) {
                emailEntry = value;
              },
              keyboardType: TextInputType.text,
              maxLines: 2,
              decoration: const InputDecoration(
                // errorText: messageError,
                border: OutlineInputBorder(),
                hintText: 'Email',
                labelText: 'Email',
                fillColor: Colors.white,
                filled: true,
                labelStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: const Text('Ok'),
                onPressed: () {
                  if (emailEntry.isNotEmpty) {
                    subscribe.text = "";
                    Get.back();
                    print('BannerSelector');
                    addMail(emailEntry);
                  }
                },
              )
            ],
          );
        }));
  }

  void del(mail) {
    Get.defaultDialog(
      title: 'Are you sure you want to delete this subsciber?',
      onConfirm: () {
        deleteMail(mail);
        Get.back();
      },
      content: Text(
        mail,
        overflow: TextOverflow.ellipsis,
      ),
      textConfirm: 'Confirm',
      textCancel: 'Cancel',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fromEdit[1].toString()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(children: [
            const Text(
              'Message  ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Flexible(
              child: Text(
                fromEdit[1].toString(),
                // maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),

          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hhccmessages')
                    .doc(fromEdit[0].toString())
                    // .orderBy('timestamp', descending: true)/////'s5y2m01JvgL6kxg7UlPh'
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error loading data');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  final post = snapshot.data!;
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  receivedMail = data['email'];
                  // print(data['price'].toString());
                  price = data['price'].toString();
                  // // print(int.parse(data['price']));
                  // print(data['price'].runtimeType);
                  // final totalPrice2 = receivedMail.length * data['price'];
                  // print(totalPrice2);
                  // print(data);
                  print(
                      '..................................................................................................................');
                  return ListView.builder(
                      // reverse: true,
                      itemCount: receivedMail.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return ListTile(
                          enableFeedback: true,
                          tileColor: Colors.grey.shade100,
                          // ignore: prefer_const_constructors
                          title: Text(
                            data['email'][index].toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                              onPressed: (() {
                                if (data['email'][index].toString() !=
                                    "admin@gmail.com") {
                                  del(
                                    data['email'][index].toString(),
                                  );
                                }
                                print(data['email'][index].toString());
                              }),
                              icon: Icon(Icons.delete)),
                        );
                      });
                }),
          ),
          // Container(
          //   color: Colors.red,
          //   height: 40,
          //   child: ListView(
          //       shrinkWrap: true,
          //       scrollDirection: Axis.horizontal,
          //       children: [
          //         Text('Total subscribers=${receivedMail.length}'),
          //         const Text('/'),
          //         Text('Message Cost=$price'),
          //         const Text('/'),
          //         Text('Total price = N${totalPrice2.toString()}'),
          //       ]),
          // ),

          ElevatedButton(
            onPressed: () {
              enterSubscriber(context);
              // enterSubscriber;
            },
            child: const Text(
              'Add Subscriber',
            ),
          ),
        ],
      ),
    );
  }
}
