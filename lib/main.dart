import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
// import 'package:trccadmin/screen/eidt%20copy.dart';
import 'package:trccadmin/screen/push_navbar.dart';
import 'screen/editforweb.dart';
import 'screen/sign_up.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   // await Firebase.initializeApp();

//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  print("ensure you have internet connection");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

      );

  runApp(
    GetMaterialApp(
      theme: ThemeData(//platform: TargetPlatform.iOS,
          ),
      // home: SongPage(),
      home: SignUp(),
      // home: Editweb(),
      // home: Text('sadfad'),
    ),
  );
}
