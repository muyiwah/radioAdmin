import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:share_plus/share_plus.dart';

class Notificat extends StatefulWidget {
  const Notificat({Key? key}) : super(key: key);

  @override
  State<Notificat> createState() => _NotificatState();
}

final functions = FirebaseFunctions.instance;

class _NotificatState extends State<Notificat> {
  final String _content =
      'hhcc Radio is live, connect using hhccradio.web.app or download hhccradio app from playstore';

  void _shareContent() {
    Share.share(_content);
  }

  bool secureText = true;
  Future<void> Notification() async {
    // await FirebaseMessaging.instance.subscribeToTopic("AllPushNotifications2");

    final results = await FirebaseFunctions.instance
        .httpsCallable('hhccradio')
        .call(<String, dynamic>{
      'title': _minLength.text,
      'body': _minLengthMessage.text,
    });
  }

  TextEditingController _minLength = TextEditingController();
  TextEditingController _minLengthMessage = TextEditingController();
  TextEditingController passwordText = TextEditingController();

  String? lengthError;
  String? messageError;
  String? passwordError;
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  //
                  width: double.maxFinite,
                  padding: EdgeInsets.all(8),
                  child: Center(
                      child: Text(
                    'Push Notifications',
                    style: TextStyle(fontSize: 20),
                  ))),
            ),
            backgroundColor: Colors.blue[600],
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'lib/icon/trcc.jpeg',
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
              // child: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Column(
              //     children: [
              //       Container(
              //           child: Text(
              //         'Push Notifications are used to notify users of any programe, The user gets the notification immediately if online or gets the notification immediately it gets online if offline. Use discreetly!',
              //       )),
              //       SizedBox(
              //         height: 9,
              //       ),
              //       Flexible(
              //         child: TextField(
              //           controller: _minLength,
              //           maxLength: 25,
              //           decoration: InputDecoration(
              //             border: OutlineInputBorder(),
              //             hintText: 'Notification Title',
              //             labelText: 'Title',
              //             errorText: lengthError,
              //             fillColor: Colors.white,
              //             filled: true,
              //             labelStyle: TextStyle(
              //               fontSize: 18,
              //               color: Colors.black,
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         height: 9,
              //       ),
              //       TextField(
              //         controller: _minLengthMessage,
              //         maxLength: 150,
              //         maxLines: 4,
              //         decoration: InputDecoration(
              //           errorText: messageError,
              //           border: OutlineInputBorder(),
              //           hintText: 'Notification Body',
              //           labelText: 'Message',
              //           fillColor: Colors.white,
              //           filled: true,
              //           labelStyle: TextStyle(
              //             fontSize: 18,
              //             color: Colors.black,
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         height: 9,
              //       ),
              //       TextField(
              //         controller: passwordText,
              //         obscureText: secureText,
              //         decoration: InputDecoration(
              //           suffixIcon: IconButton(
              //             onPressed: () {
              //               setState(() {
              //                 secureText = !secureText;
              //               });
              //             },
              //             icon: Icon(
              //                 secureText ? Icons.remove_red_eye : Icons.security),
              //           ),
              //           errorText: passwordError,
              //           border: OutlineInputBorder(),
              //           labelText: 'Password',
              //           hintText: 'password',
              //           fillColor: Colors.white,
              //           filled: true,
              //           labelStyle: TextStyle(
              //             fontSize: 18,
              //             color: Colors.black,
              //           ),
              //         ),
              //       ),
              //       ElevatedButton(
              //         onPressed: () {
              //           setState(() {
              //             if (_minLength.text.length < 4) {
              //               lengthError = "Enter at least 4 char";
              //               print(lengthError);
              //             } else {
              //               lengthError = null;
              //               print(_minLength.text);
              //             }
              //             if (_minLengthMessage.text.length < 5) {
              //               messageError = "Enter at least 5 char";

              //               print(lengthError);
              //             } else {
              //               messageError = null;

              //               print(_minLengthMessage.text);
              //             }
              //             if (passwordText.text != 'admin@hhccradio') {
              //               passwordError = "Wrong Password";
              //               print(passwordText.text);
              //             } else {
              //               passwordError = null;

              //               print(_minLengthMessage.text);
              //             }
              //             if (_minLength.text.length > 3 &&
              //                 _minLengthMessage.text.length > 5 &&
              //                 passwordText.text == 'admin@hhccradio') {
              //               _minLength.text = '';
              //               _minLengthMessage.text = '';
              //               print('Notification');
              //               Notification();
              //               ScaffoldMessenger.of(context).showSnackBar(
              //                 SnackBar(
              //                   content: const Text('sending...'),
              //                   action: SnackBarAction(
              //                     label: 'Dismiss',
              //                     onPressed: () {
              //                       // Code to execute.
              //                     },
              //                   ),
              //                 ),
              //               );
              //             }
              //           });
              //         },
              //         child: Text('Push'),
              //       ),
              //       IconButton(
              //         icon: Icon(Icons.share),
              //         onPressed: _shareContent,
              //       ),
              //     ],
              //   ),
              // ),
              )
        ],
      ),
    );
  }
}
