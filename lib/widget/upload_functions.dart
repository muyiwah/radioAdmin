import 'dart:io';
// import 'dart.html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:trccadmin/screen/upload.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Uploadfunctions extends StatefulWidget {
  const Uploadfunctions({super.key});
  // final Function callFunction;

  @override
  State<Uploadfunctions> createState() => _UploadfunctionsState();
}

class _UploadfunctionsState extends State<Uploadfunctions> {
  var subscription;
  var lognow = Logger();
  static bool internetAvailable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();
    // print(subscription);
  }

  void checkInternet() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        print(result);
        if (result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile) {
          setState(() {
            internetAvailable = true;
          });
        } else {
          setState(() {
            internetAvailable = false;
          });
        }
        // Got a new connectivity status!
      },
    );
  }
  // Future checkConnect(context) async {
  //   _onTapButton(context, 'not ');
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     setState(() {
  //       internetAbailable = true;
  //       stat = connectivityResult;
  //     });
  //     _onTapButton(context, 'not availabel');
  //     // I am connected to a mobile network.
  //     return internetAbailable;
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     stat = connectivityResult;
  //     internetAbailable = true;
  //     _onTapButton(context, 'availabel');
  //     return internetAbailable;
  //   } else {
  //     internetAbailable = false;
  //     return internetAbailable;
  //   }
  // }

  TextEditingController preach = TextEditingController();
  TextEditingController amount = TextEditingController();

  String datetime = DateTime.now().toString();
  TextEditingController preacher = TextEditingController();
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
  String preacherValue = "";
  String messageTitle = "";
  String paymentOPtion = "";
  String paymentAmount = "0";
  String valueText = "";
  bool paid = false;
  int level = 0;
  List email = ['admin@gmail.com'];
  bool textData = false;
//output: 2021-10-17 20:04:17.118089

  String datetime1 = DateFormat("yyyy-MM-dd").format(DateTime.now());
  DateTime datetime2 = DateTime.now();
  var stat;
  // Future selectimage() async {
  //   final image = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     type: FileType.image,
  //   );
  //   if (image != null) {
  //     setState(() {
  //       pickedFile = image.files.first;
  //       PaidSelector();
  //     });
  //   } else {
  //     Get.back();
  //   }
  // }

  // void defaulImage() {
  //   pickedFile = Path('lib/icon/trcc.jpg');
  // }

  void selectsong() async {
    setState(() {
      waiting = true;
    });
    final song = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
    );

    final songName = song?.names.first;
    songpath = songName;
    songname.text = songpath.toString();
    print(songName);
    print(song?.names);
    setState(() {
      songnameforfirebase = songname.text.toLowerCase();
      waiting = false;
      // displayTextInputDialog(context, 'Enter name of Preacher', true);
    });
    if (song != null) {
      setState(() {
        pickedSong = song.files.first;
      });
    }
    PreacherName();
  }

  void selectsong2() async {
    print("im here now");
    setState(() {
      waiting = true;
    });
    final song = await FilePicker.platform
        .pickFiles(type: FileType.audio, allowMultiple: false);

    if (song != null && song.files.isNotEmpty) {
      final fileBytes = song.files.first.bytes;
      final fileName = song.files.first.name;
      final songName = song.names.first;
      songpath = songName;
      songname.text = songpath.toString();
      print(fileBytes);
      print(song.names);
      setState(() {
        songnameforfirebase = songname.text.toLowerCase();
        pickedSong = song.files.first;
        waiting = false;
        // displayTextInputDialog(context, 'Enter name of Preacher', true);
        PreacherName();
      });
      // upload file
      // await FirebaseStorage.instance
      //     .ref('uploads/$fileName')
      //     .putData(fileBytes);
    }
  }

  bool waiting = false;
  Future uploadFiles(context) async {
    if (songname.text == '' || songpath == null) {
      print(songname.text + "song path" + songpath.toString());
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
      // final path = 'hhccFiles/${pickedFile!.name}';
      final path2 = 'leadershipconf2023/${pickedSong!.name}';
      // final file = File(pickedFile!.path!);
      final file2 = File(pickedSong!.path!);
      songnameforfirebase = songname.text;
      preacherforfirebase = preacherValue;
      // final ref = FirebaseStorage.instance.ref().child(path);
      final ref2 = FirebaseStorage.instance.ref().child(path2);
      setState(() {
        songnameforfirebase = songname.text;
        preacherforfirebase = preacherValue;
        // uploadTask = ref.putFile(file);
        uploadTask2 = ref2.putFile(file2);
      });
      // final snapshot = await uploadTask!.whenComplete(() {});
      final snapshot2 = await uploadTask2!.whenComplete(() {});
      // urlDownload = await snapshot.ref.getDownloadURL();
      urlDownload2 = await snapshot2.ref.getDownloadURL();
      await finalupload(context);
      // print(urlDownload);
      setState(() {
        print(urlDownload);
        // uploadTask2 = null;
        // uploadTask = null;
      });
    }
  }

  bool hideprogress = true;
  Future cancelUpload() async {
    await uploadTask2!.cancel();
    Future.delayed(
        const Duration(seconds: 10),
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
  List<String> caseSearchList2 = [];
  DateTime date = DateTime.now();
  List listenCounter = [];
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

  setSearchParam2(String preacherforfirebase) {
    print(preacherforfirebase);
    String temp = "";
    for (int i = 0; i < preacherforfirebase.length; i++) {
      temp = temp + preacherforfirebase[i].toLowerCase();
      caseSearchList.add(temp);
    }
    print(caseSearchList2);
    return caseSearchList2;
  }

  // final DateTime date2 = DateTime(2021, 8, 10);
  // late final timestamp2 = date2.millisecondsSinceEpoch;
  Future finalupload(context) async {
    hideprogress = false;
    lognow.e(datetime2);
    lognow.d(datetime2.microsecondsSinceEpoch);
    // if (songname.text != '') {
    var data = {
      "song_name": songname.text,
      // "image_url": urlDownload.toString(),
      "song_url": urlDownload2.toString(),
      "search": setSearchParam(songnameforfirebase),
      "search2": setSearchParam2(preacherforfirebase),
      // "search": caseSearchList,
      'timestamp': datetime2.millisecondsSinceEpoch,
      'price': paymentAmount,
      'date': datetime1,
      'paid': paid,
      'preacher': preacherValue,
      'listenCounter': 0,
      'email': email,
    };

    FirebaseFirestore.instance
        .collection("mivconfmessages")
        .add(data)
        .whenComplete(() => {
              setState(() {
                hideprogress = true;
              }),
              print(hideprogress),
              showDialog(
                context: context,
                builder: (context) =>
                    _onTapButton(context, "Files Uploaded Successfully "),
              ),
            });
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (context) => _onTapButton(context, "Please Enter All Details"),
    //   );
    // }
  }

  void resetValues() {
    songpath = "";
    songpath = null;
    preacherValue = "";
    paymentOPtion = "";
    paymentAmount = "0";
    pickedFile = null;
    datetime1 = DateFormat("yyyy-MM-dd").format(DateTime.now());
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * .5,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage('lib/icon/radio6.jpg'),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    // if (pickedFile != null)
                    //   Container(
                    //     padding: EdgeInsets.only(left: 10),
                    //     height: 100,
                    //     width: 100,
                    //     child: Container(
                    //       child: Image.file(
                    //         File(pickedFile!.path!),
                    //         width: double.infinity,
                    //         fit: BoxFit.cover,
                    //       ),
                    //     ),
                    //   ),
                    Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (waiting == true)
                            const Center(child: CircularProgressIndicator()),
                          if (songpath != null)
                            Text(
                              'Title: $songpath',
                              style: const TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          if (preacherValue.isNotEmpty)
                            Text(
                              'Preacher:  ' + preacherValue,
                              style: const TextStyle(color: Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (preacherValue.isNotEmpty)
                            Text('Date:  ' + datetime1,
                                style: const TextStyle(color: Colors.black)),
                          if (paymentOPtion.isNotEmpty)
                            Text('Message Type:  ' + paymentOPtion,
                                style: const TextStyle(color: Colors.black)),
                          if (paymentAmount != "0")
                            Text('Amount:  N$paymentAmount',
                                style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                    )
                  ],
                ),
                // const Spacer(),
                (songpath != null && preacherValue.isNotEmpty)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          hideprogress
                              ? ElevatedButton(
                                  onPressed: () {
                                    if (internetAvailable) {
                                      textData = false;
                                      hideprogress = false;

                                      uploadFiles(context);
                                    } else {
                                      Get.snackbar(
                                        'Alert',
                                        'seems as if you are not connected to the internet, check your internet connection and try again',
                                        snackPosition: SnackPosition.BOTTOM,
                                        forwardAnimationCurve:
                                            Curves.elasticInOut,
                                        reverseAnimationCurve: Curves.easeOut,
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'upload to database',
                                  ),
                                )
                              : const CircularProgressIndicator(),
                          const SizedBox(
                            width: 8,
                          ),
                          hideprogress
                              ? ElevatedButton(
                                  // style: styleFrom(color: Colors.red),
                                  onPressed: () {
                                    resetValues();
                                    setState(() {});
                                  },
                                  child: const Text(
                                    'Clear',
                                  ),
                                )
                              : const SizedBox(
                                  width: 8,
                                ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          textData = false;
                          resetValues();
                          MessageSelector();
                        },
                        child: const Text(
                          'Select Message',
                        ),
                      ),
                (songname.text != '' && hideprogress == false)
                    ? buldProgress()
                    : const SizedBox.shrink()
              ],
            ),
          )
        ],
      ),
    );
  }

  void dateSelector() {
    Get.defaultDialog(
      title: "Date",
      content: Text("Use Todays' date or select a different date"),
      onConfirm: () async {
        DateTime? newDate = await showDatePicker(
            helpText: 'Search Message by Date',
            // showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100));
        if (newDate == null) return;
        setState(() {
          print(newDate);
          datetime1 = newDate.toString().split(" ")[0];
          datetime2 = newDate;
          lognow.e(datetime2);
          lognow.d(datetime2.microsecondsSinceEpoch);
          print(datetime1);
          Get.back();
        });
        // datetime1 = DateFormat("yyyy-MM-dd").format(newDate);
      },
      confirmTextColor: Colors.white,
      textConfirm: 'Change Date',
      textCancel: 'Today',
    );
    // Get.dialog(AlertDialog(
    //   title: Text('hello'),
    //   content: Text('this is working'),
    //   actions: [ElevatedButton(onPressed: (() {}), child: Text('click'))],
    // ));
  }

  // void BannerSelector() {
  //   Get.dialog(
  //     AlertDialog(
  //       actionsAlignment: MainAxisAlignment.center,
  //       content: Text('select a thumnail/image'),
  //       actions: <Widget>[
  //         ElevatedButton(
  //           child: const Text('CANCEL'),
  //           onPressed: () {
  //             level = 0;
  //             setState(() {
  //               Navigator.pop(context);
  //             });
  //           },
  //         ),
  //         ElevatedButton(
  //           child: const Text('Ok'),
  //           onPressed: () {
  //             Get.back();
  //             selectimage();
  //           },
  //         ),
  //         // ElevatedButton(
  //         //   child: const Text('Skip'),
  //         //   onPressed: () {
  //         //     Get.back();
  //         //     PaidSelector();
  //         //   },
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  void MessageSelector() {
    Get.dialog(
      AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        content: Text('select message(mp3 only)'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('CANCEL'),
            onPressed: () {
              level = 0;
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
          ElevatedButton(
            child: const Text('Ok'),
            onPressed: () {
              Get.back();
              selectsong2();
            },
          ),
        ],
      ),
    );
  }

  void PaidSelector() {
    Get.dialog(
      FittedBox(
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Column(children: [
            const Text('Is the message free or paid?'),
            RadioListTile(
              title: const Text("Free"),
              value: paid,
              // toggleable: true,
              groupValue: false,
              onChanged: (value) {
                setState(() {
                  paymentOPtion = "free";
                  paymentAmount = '0';
// Get.snackbar()
                  paid = false;
                });
                Get.back();
                dateSelector();
              },
            ),
            RadioListTile(
              title: const Text("Paid"),
              value: paid,
              groupValue: true,
              onChanged: (value) {
                setState(() {
                  paid = true;

                  paymentOPtion = 'paid';
                  print(value);
                });
                Get.back();
                EnterAmount();
              },
            ),
          ]),
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
                if (paid == true) {
                  paymentOPtion = 'paid';
                } else {
                  paymentOPtion = 'free';
                }
                if (paymentOPtion == 'paid') {
                  Get.back();
                  EnterAmount();
                  setState(() {});
                } else if (paymentOPtion == 'free') {
                  Get.back();
                  dateSelector();
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void EnterAmount() {
    Get.dialog(
      AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        content: TextField(
          controller: amount,
          maxLength: 10,
          onChanged: ((value) => setState(() {
                paymentAmount = value;
              })),
          keyboardType: TextInputType.number,
          maxLines: 1,
          decoration: const InputDecoration(
            // errorText: messageError,
            border: OutlineInputBorder(),
            hintText: 'Enter Amount in Naira',
            labelText: 'Amount(N)',
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
              resetValues();
              setState(() {});
              Get.back();
            },
          ),
          ElevatedButton(
            child: const Text('Ok'),
            onPressed: () {
              if (paymentAmount.contains('.')) {
                paymentAmount = paymentAmount.split('.')[0];
              } else if (paymentAmount.contains(',')) {
                paymentAmount = paymentAmount.split(',')[0];
              }
              setState(() {});
              if (paymentAmount != '0' && paymentOPtion != 'free') {
                amount.text = "";
                Get.back();
                dateSelector();
              }
            },
          ),
        ],
      ),
    );
  }

  void PreacherName() {
    print('PreacherName');
    Get.dialog(
      AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        content: TextField(
          controller: preach,
          maxLength: 50,
          onChanged: (value) {
            setState(() {
              preacherValue = value;
            });
          },
          keyboardType: TextInputType.text,
          maxLines: 2,
          decoration: const InputDecoration(
            // errorText: messageError,
            border: OutlineInputBorder(),
            hintText: 'Preacher Name',
            labelText: 'Preacher',
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
              level = 0;
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
          ElevatedButton(
            child: const Text('Ok'),
            onPressed: () {
              if (preacherValue.isNotEmpty) {
                preach.text = "";
                Get.back();
                print('PaidSelector');
                PaidSelector();
              }
            },
          )
        ],
      ),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.red,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${(100 * progress).roundToDouble()}%',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
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
        },
      );
}
