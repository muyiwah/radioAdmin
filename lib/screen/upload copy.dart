import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'eidt.dart';

String songnameforfirebase = "";

class Upload extends StatefulWidget {
  Upload({Key? key}) : super(key: key);
  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchData2();
  }

  Future fetchData() async {
    final db = FirebaseFirestore.instance;
    await db
        .collection('trcc')
        .doc("register")
        .snapshots()
        .listen((docSnapshot) {
      Map<String, dynamic> data = docSnapshot.data()!;
      print(data);
    });
  }

  List docsId = [];
  Future fetchData2() async {
    final db = FirebaseFirestore.instance;
    await db.collection('trccmessages').doc().get().then((value) {
      docsId.add(value.get('song_name'));
    });
    // .collection('zionmessages')
    // .orderBy('timestamp', descending: true)
    // .get()
    // .then((snapshot) => snapshot.docs.forEach((document) {
    //       docsId.add(document.reference.id);
    //     }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String datetime = DateTime.now().toString();

  TextEditingController songname = TextEditingController();
  PlatformFile? pickedFile, pickedSong;
  UploadTask? uploadTask, uploadTask2;
  File? image, song;
  String? imagepath, songpath;
  // final ref = FirebaseStorage.instance.ref();
  var image_down_url;
  var song_down_url;
  var urlDownload;
  var urlDownload2;

//output: 2021-10-17 20:04:17.118089

  String datetime1 = DateFormat("yyyy-MM-dd").format(DateTime.now());

  Future selectimage() async {
    final image = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (image != null) {
      setState(() {
        pickedFile = image.files.first;
      });
    }
  }

  Future selectsong() async {
    setState(() {
      waiting = true;
    });
    final song = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
    );
    final songName = song?.names.first;
    songpath = songName;
    print(songName);
    setState(() {
      songnameforfirebase = songname.text.toLowerCase();
      waiting = false;
    });
    if (song != null) {
      setState(() {
        pickedSong = song.files.first;
      });
    }
  }

  bool waiting = false;
  Future uploadFiles(context) async {
    if (songname.text == '' || songpath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Ensure image, song and title fields are not empty!'),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
    } else {
      final path = 'TrccFiles/${pickedFile!.name}';
      final path2 = 'TrccFiles/${pickedSong!.name}';
      final file = File(pickedFile!.path!);
      final file2 = File(pickedSong!.path!);
      songnameforfirebase = songname.text;
      final ref = FirebaseStorage.instance.ref().child(path);
      final ref2 = FirebaseStorage.instance.ref().child(path2);
      setState(() {
        songnameforfirebase = songname.text;
        uploadTask = ref.putFile(file);
        uploadTask2 = ref2.putFile(file2);
      });
      final snapshot = await uploadTask!.whenComplete(() {});
      final snapshot2 = await uploadTask2!.whenComplete(() {});
      urlDownload = await snapshot.ref.getDownloadURL();
      urlDownload2 = await snapshot2.ref.getDownloadURL();
      await finalupload(context);
      print(urlDownload);
      setState(() {
        print(urlDownload);
        // uploadTask2 = null;
        // uploadTask = null;
      });
    }
  }

  bool hideprogress = false;
  Future cancelUpload() async {
    await uploadTask2!.cancel();
    Future.delayed(
        Duration(seconds: 10),
        (() => setState(() {
              hideprogress = true;
            })));
  }

  // void selectsong() async {
  //   song = await FilePicker.getFile();

  //   setState(() {
  //     song = song;
  //     songpath = basename(song?.path);
  //     uploadsongfile(song.readAsBytesSync(), songpath);
  //   });
  // }

  // Future<String> uploadsongfile(List<int> song, String songpath) async {
  //   final ref = FirebaseStorage.instance.ref().child(songpath);
  //   StorageUploadTask uploadTask = ref.putData(song);

  //   song_down_url = await (await uploadTask.onComplete).ref.getDownloadURL();
  List<String> caseSearchList = [];
  // }
  setSearchParam(String songnameforfirebase) {
    print(songnameforfirebase);
    String temp = "";
    for (int i = 0; i < songnameforfirebase.length; i++) {
      temp = temp + songnameforfirebase[i].toLowerCase();
      caseSearchList.add(temp);
    }
    print(caseSearchList);
    return caseSearchList;
  }

  Future finalupload(context) async {
    hideprogress = false;
    // if (songname.text != '') {
    var data = {
      "song_name": songname.text,
      "image_url": urlDownload.toString(),
      "song_url": urlDownload2.toString(),
      "search": setSearchParam(songnameforfirebase),
      // "search": caseSearchList,
      'timestamp': Timestamp.now(),
      'date': datetime1
    };

    FirebaseFirestore.instance
        .collection("trcccmessages")
        .add(data)
        .whenComplete(
          () => showDialog(
            context: context,
            builder: (context) =>
                _onTapButton(context, "Files Uploaded Successfully "),
          ),
        );
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (context) => _onTapButton(context, "Please Enter All Details"),
    //   );
    // }
  }

  _onTapButton(BuildContext context, data) {
    caseSearchList = [];
    return AlertDialog(title: Text(data));
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => Edit(),
    //     ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (pickedFile != null)
            Expanded(
              child: Container(
                child: Image.file(
                  File(pickedFile!.path!),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (waiting == true) const Center(child: CircularProgressIndicator()),
          if (songpath != null)
            Text('$songpath', style: const TextStyle(color: Colors.black)),
          // Text('$urlDownload', style: const TextStyle(color: Colors.black)),
          // Text('$urlDownload2', style: const TextStyle(color: Colors.black)),
          // Text('$songpath',
          //     style: const TextStyle(
          //         color: Colors.black, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: TextField(
              style: TextStyle(fontWeight: FontWeight.bold),
              controller: songname,
              decoration: const InputDecoration(
                hintText: "Enter song name",
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: selectimage,
                child: const Text("Select Image"),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: selectsong,
                child: const Text("Select Song"),
              ),
            ],
          ),
          ElevatedButton(
            // onPressed: () => finalupload(context),
            onPressed: () => uploadFiles(context),
            child: const Text("Upload"),
          ),
          if (songname.text != '' && hideprogress == false) buldProgress(),
        ],
      ))),
    );
  }

  Widget buldProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask2?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          double progress = data!.bytesTransferred / data.totalBytes;
          return Column(
            children: [
              SizedBox(
                height: 50,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .75,
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.red,
                        color: Colors.green,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${(100 * progress).roundToDouble()}%',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              // if ((100 * progress).roundToDouble() != 100)
              // ElevatedButton(
              //     onPressed: cancelUpload,
              //     child: const Text('Cancel',
              //         style: TextStyle(color: Colors.red)))
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      });
}
