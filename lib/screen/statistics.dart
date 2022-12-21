import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  final myStyle0 = const TextStyle(
      color: Colors.grey, fontFamily: 'AkayaTelivigala', fontSize: 15);
  final myStyle = const TextStyle(
      color: Colors.black, fontFamily: 'AkayaTelivigala', fontSize: 15);
  final myStyle2 = const TextStyle(
      color: Colors.deepPurple, fontFamily: 'AkayaTelivigala', fontSize: 15);
  final myStyle3 = const TextStyle(
      color: Colors.blue, fontFamily: 'AkayaTelivigala', fontSize: 15);
  final myStyle4 = const TextStyle(
      color: Colors.green, fontFamily: 'AkayaTelivigala', fontSize: 15);
  final myStyle5 = const TextStyle(
      color: Colors.red, fontFamily: 'AkayaTelivigala', fontSize: 15);
  final myStyle1 = const TextStyle(
      color: Colors.black, fontFamily: 'AkayaTelivigala', fontSize: 15);
  Future<void> _init() async {
    final db = FirebaseFirestore.instance;

    db.collection('hhcc').doc("register").snapshots().listen((docSnapshot) {
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
    db.collection('hhcc').doc("status").snapshots().listen((docSnapshot) {
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

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('hhccmessages')
      .orderBy('timestamp', descending: true)
      .snapshots();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

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
        title: const Text('Statistics'),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue.shade100,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              // child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       '${online} Total listens',
              //       style: const TextStyle(
              //           color: Colors.white,
              //           fontFamily: 'AkayaTelivigala',
              //           fontSize: 20),
              //     ),
              //     SizedBox(
              //       height: 20,
              //     ),
              //     Text(
              //       '${onlineStatus.abs()} online',
              //       style: const TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 20),
              //     ),
              //   ],
              // ),
              child: StreamBuilder<QuerySnapshot>(
                  stream: _usersStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error loading data');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    print(snapshot.data!);
                    return Column(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        print(data);
                        print(snapshot.data!);
                        Timestamp t = data['timestamp'];
                        DateTime d = t.toDate();
                        String y = DateFormat("yyyy-MM-dd").format(d);
                        y = "$y ";
                        final emailLength = data['email'].length - 1;
                        final total = int.parse(data['price']) * emailLength;
                        return Column(
                            // ignore: prefer_const_constructors
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                height: 30,
                                color: Colors.white.withOpacity(.1),
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Text(
                                      y,
                                      style: myStyle0,
                                    ),
                                    Text(
                                      "Message:  " +
                                          data['song_name'].toString(),
                                      style: myStyle1,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Total listens: " +
                                          data['listenCounter'].toString() +
                                          " times",
                                      style: myStyle2,
                                    ),
                                    // Text(data['email'].length().toString()),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text("Paid: " + data['paid'].toString()),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Subscribers: $emailLength',
                                      style: myStyle3,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Message Price: " +
                                          data['price'].toString(),
                                      style: myStyle4,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Total sold:  N$total',
                                      style: myStyle5,
                                    ),
                                  ],
                                ),
                              ),
                              // Text(
                              //   '${onlineStatus.abs()} Online on Radio',
                              //   style: const TextStyle(
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 20),
                              // ),
                              // Text(
                              //   '${online} Total listens on Radio',
                              //   style: const TextStyle(
                              //       color: Colors.white,
                              //       fontFamily: 'AkayaTelivigala',
                              //       fontSize: 20),
                              // ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              // Text(
                              //   "Total Messages:" + data['document'].length(),
                              //   style: const TextStyle(
                              //       color: Colors.white,
                              //       fontFamily: 'AkayaTelivigala',
                              //       fontSize: 20),
                              // ),
                              // Text(
                              //   "Total income:" + data['document'].length(),
                              //   style: const TextStyle(
                              //       color: Colors.white,
                              //       fontFamily: 'AkayaTelivigala',
                              //       fontSize: 20),
                              // ),
                              // Text(
                              //   "Total Message listens:" +
                              //       data['document'].length(),
                              //   style: const TextStyle(
                              //       color: Colors.white,
                              //       fontFamily: 'AkayaTelivigala',
                              //       fontSize: 20),
                              // ),
                              // Text(
                              //   "Total Radio Listens:" + data['document'].length(),
                              //   style: const TextStyle(
                              //       color: Colors.white,
                              //       fontFamily: 'AkayaTelivigala',
                              //       fontSize: 20),
                              // ),
                              // Text(
                              //   "Total Messages:" + data['document'].length(),
                              //   style: const TextStyle(
                              //       color: Colors.white,
                              //       fontFamily: 'AkayaTelivigala',
                              //       fontSize: 20),
                              // ),
                              // Text(
                              //   "Total Messages:" + data['document'].length(),
                              //   style: const TextStyle(
                              //       color: Colors.white,
                              //       fontFamily: 'AkayaTelivigala',
                              //       fontSize: 20),
                              // ),
                              const Divider(
                                height: 4,
                              )
                            ]);
                      }).toList(),
                    );
                  }),
            ),
          )
         ],
      ),
    );
  }
}
