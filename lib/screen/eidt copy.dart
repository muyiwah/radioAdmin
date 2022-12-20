import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// import 'package:transparent_image/transparent_image.dart';
import 'package:just_audio/just_audio.dart';
import 'package:trccadmin/widget/qr.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  String? playUrl;
  bool isPlaying = false;
  static AudioPlayer player = AudioPlayer();
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('hhccmessages')
      .orderBy('timestamp', descending: true)
      .snapshots();

  CollectionReference firebaseDelete =
      FirebaseFirestore.instance.collection('hhccmessages');

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            var documentID = document.id;
            Timestamp t = data['timestamp'];
            DateTime d = t.toDate();
            String y = DateFormat("yyyy-MM-dd").format(d);
            return ListTile(
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      playSong(data['song_url']);
                    },
                    icon: Icon(isPlaying && data['song_url'] == playUrl
                        ? Icons.pause
                        : Icons.play_arrow_outlined)),
                IconButton(
                    onPressed: () => deleteSong(documentID),
                    icon: Icon(Icons.delete)),
                // TextButton(
                //     onPressed: () => Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (BuildContext context) => Qr(
                //                 documentID: documentID,
                //                 title: data['song_name']))),
                //     child: Text(
                //       'QR',
                //       style: TextStyle(color: Colors.black),
                //     ))
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
              onTap: () => deleteSong(documentID),
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(data['image_url']), radius: 25),
              title: Expanded(
                child: Text(
                  data['song_name'],
                  style: TextStyle(fontSize: 18),
                ),
              ),
              subtitle: Flexible(
                child: Text(
                  y,
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
