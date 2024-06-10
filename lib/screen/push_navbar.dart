import 'package:flutter/material.dart';
// import 'package:trccadmin/screen/sliver_notification.dart';
import 'package:trccadmin/screen/statistics.dart';
// import 'package:trccadmin/screen/subscirbers.dart';
// import 'package:trccadmin/screen/upload.dart';

import '../widget/upload_functions.dart';
// import '../widget/upload_functions__forweb.dart';
// import 'editforweb.dart';
import 'eidt.dart';

class PushNavbar extends StatefulWidget {
  PushNavbar({Key? key}) : super(key: key);

  @override
  State<PushNavbar> createState() => _PushNavbarState();
}

class _PushNavbarState extends State<PushNavbar> {
  final _screens = [
    // Subscribers(),
    // Notificat(),
    // UploadfunctionsWeb(),
    Uploadfunctions(),
    Edit(),
    // Editweb(),
    Statistics()
  ];
  // final _screens = [Text('hello'), Upload(), Edit()];

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          items: const [
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.notification_important_rounded),
            //     label: 'Push'),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Upload'),
            BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit'),
            BottomNavigationBarItem(
                icon: Icon(Icons.star_rate_outlined), label: 'Statistics'),
          ]),
    );
  }
}
