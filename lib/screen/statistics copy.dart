import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({
    Key? key,
  }) : super(key: key);
  @override
  State<Statistics> createState() => _StatisticsState();
}

bool isPlaying = false;

class _StatisticsState extends State<Statistics> with WidgetsBindingObserver {
  int online = 0;
  int onlineStatus = 0;
  final city = <String, dynamic>{
    'count': 0,
  };
  int count = 0;
  // final _player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // ambiguate(WidgetsBinding.instance)!.addObserver(this);
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.black,
    // ));
    _init();
  }

  Future<void> _init() async {
    final db = FirebaseFirestore.instance;
    onlineStatusIncrease();

    await db
        .collection('zion')
        .doc("register")
        .update({"count": FieldValue.increment(1)});

    db.collection('trcc').doc("register").snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;

        // You can then retrieve the value from the Map like this:
        var name = data['count'];
        print(data);
        setState(() {
          online = name;
          print('online');
          print(online);
        });
      }
    });
    db.collection('trcc').doc("status").snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;

        // You can then retrieve the value from the Map like this:
        var name = data['online'];
        print(data);
        setState(() {
          onlineStatus = name.abs();
          print('onlineStatus');
          print(onlineStatus);
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      if (!isPlaying) {
        onlineStatusDecrease();
      }
      // _player.stop();
    }
    if (state == AppLifecycleState.resumed) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      if (!isPlaying) {
        onlineStatusIncrease();
      }
      // _player.stop();
    }
  }

  void onlineStatusIncrease() async {
    await FirebaseFirestore.instance
        .collection('trcc')
        .doc("status")
        .update({"online": FieldValue.increment(1)});
  }

  void onlineStatusDecrease() async {
    await FirebaseFirestore.instance
        .collection('trcc')
        .doc("status")
        .update({"online": FieldValue.increment(-1)});
  }

  @override
  void dispose() {
    // ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    // widget.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${online} Total listens',
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'AkayaTelivigala',
                    fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '${onlineStatus.abs()} online',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
