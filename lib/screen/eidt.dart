import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:transparent_image/transparent_image.dart';
import 'package:just_audio/just_audio.dart';
import 'package:trccadmin/screen/subscirbers.dart';
import 'package:trccadmin/widget/qr.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  // bool internetAvailable = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   print(result);
    //   if (result == ConnectivityResult.wifi ||
    //       result == ConnectivityResult.mobile) {
    //     setState(() {
    //       internetAvailable = true;
    //     });
    //   } else {
    //     setState(() {
    //       internetAvailable = false;
    //     });
    //   }
    //   // Got a new connectivity status!
    // });
    // print(subscription);
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  String? playUrl;
  bool isPlaying = false;
  static AudioPlayer player = AudioPlayer();
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('mivconfmessages')
      .orderBy('timestamp', descending: true)
      .snapshots();

  CollectionReference firebaseDelete =
      FirebaseFirestore.instance.collection('mivconfmessages');

  Future deleteSong(documentID) {
    return firebaseDelete
        .doc(documentID)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  void playSong(uri) {
    try {
      player.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      playUrl = uri;
      if (!isPlaying) {
        player.play();
        isPlaying = true;
        setState(() {});
      } else {
        player.pause();
        isPlaying = false;
        setState(() {});
      }
    } catch (e) {
      print('cant connect to player');
    }
  }

  void deleteMessage(mail, mess) {
    Get.defaultDialog(
      confirmTextColor: Colors.white,
      title: 'Are you sure you want to delete this message from the database?',
      onConfirm: () {
        deleteSong(mail);
        Get.back();
      },
      content: Text(
        mess,
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
        title: const Text('Edit'),
        centerTitle: true,
      ),
      body: Material(
        child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const Text("Loading"));
            }

            return Expanded(
              child: ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  var documentID = document.id;
                  // Timestamp t = data['timestamp'];
                  // DateTime d = t.toDate();
                  // String y = DateFormat("yyyy-MM-dd").format(d);
                  final price = data['price'];
                  bool isPaid = false;
                  // List exceptions = data['email'];
                  if (price == '0') isPaid = true;
                  return Column(
                    children: [
                      Divider(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(9)),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      playSong(data['song_url']);
                                    },
                                    child: Icon(
                                      isPlaying && data['song_url'] == playUrl
                                          ? Icons.pause
                                          : Icons.play_arrow_outlined,
                                      size: 28,
                                    )),
                                GestureDetector(
                                  onTap: () {
                                    // if (!internetAvailable == true) {
                                    deleteMessage(
                                      documentID,
                                      data['song_name'],
                                    );
                                    // } else {
                                    // Get.snackbar(
                                    //   duration:
                                    //       const Duration(milliseconds: 8000),
                                    //   backgroundColor: Colors.white,
                                    //   'Alert',
                                    //   'seems as if you are not connected to the internet, check your internet connection and try again',
                                    //   snackPosition: SnackPosition.BOTTOM,
                                    //   forwardAnimationCurve:
                                    //       Curves.elasticInOut,
                                    //   reverseAnimationCurve: Curves.easeOut,
                                    // );
                                    // }
                                  },
                                  child: Image.asset(
                                    'lib/icon/del.png',
                                    fit: BoxFit.contain,
                                    height: 26,
                                  ),
                                ),
                              ],
                            ),

                            // Container(
                            //   margin: EdgeInsets.symmetric(horizontal: 5),
                            //   padding: EdgeInsets.all(2),
                            //   decoration: BoxDecoration(
                            //       color: Colors.blue,
                            //       borderRadius: BorderRadius.circular(10)),
                            //   child: const Text(
                            //     'QR',
                            //     style: TextStyle(
                            //         color: Colors.black,
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 18),
                            //   ),
                            // ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Qr(
                                                    documentID: documentID,
                                                    title: data['song_name']))),
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color:
                                              Colors.lightBlue.withOpacity(.3),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Image.asset(
                                        'lib/icon/qr-code.png',
                                        fit: BoxFit.contain,
                                        height: 24,
                                      ),
                                    )),
                                isPaid
                                    ? InkWell(
                                        onTap: () {
                                          Get.to(Subscribers(), arguments: [
                                            documentID,
                                            data['song_name']
                                          ]);
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (BuildContext context) =>
                                          //         Subscribers(
                                          //       documentID: documentID,
                                          //       message: data['song_name'],
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                        child: Image.asset(
                                          'lib/icon/gmail.png',
                                          fit: BoxFit.contain,
                                          height: 26,
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(3),
                                        margin: const EdgeInsets.only(top: 6),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.green.withOpacity(0.3),
                                        ),
                                        child: const Text(
                                          'Free',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 11),
                                        ),
                                      ),
                              ],
                            ),
                          ]),
                          // trailing: Row(
                          //   children: [
                          //     IconButton(
                          //         onPressed: () {
                          //           playSong(data['song_url']);
                          //         },
                          //         icon: Icon(!isPlaying
                          //             ? Icons.play_arrow_outlined
                          //             : Icons.pause)),
                          //     IconButton(
                          //         onPressed: () => deleteSong(documentID),
                          //         icon: Icon(Icons.delete)),
                          //   ],
                          // ),
                          // onTap: () => deleteMessage(
                          //   documentID,
                          //   data['song_name'],
                          // ),
                          leading: CircleAvatar(
                              // backgroundImage: NetworkImage(data['image_url']),
                              radius: 25),
                          title: Expanded(
                            child: Text(
                              data['song_name'],
                              style: const TextStyle(fontSize: 15),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Flexible(
                            child: Text(
                              data['date'],
                              style: const TextStyle(
                                fontSize: 10.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                  // return Text('data');
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
