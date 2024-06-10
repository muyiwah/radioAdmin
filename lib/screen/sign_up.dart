import 'package:flutter/material.dart';
import 'package:trccadmin/screen/push_navbar.dart';

import '../widget/lottieHello.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    super.initState();
  }

  String email = "";
  String _errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Center(child: HelloLottie()),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Enter password',
            ),
            onChanged: (val) {
              setState(() {
                {
                  email = val;
                }
              });
              // validateEmail(val);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              validateEmail(email);
              print("Sing in Clicked");
            },
            child: const Text('Log in'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        ),
        // ElevatedButton(
        //     onPressed: (() async {
        //       Box box = await Hive.openBox('register');
        //       await box.clear();
        //       setState(() {});
        //     }),
        //     child: const Text('clear')),
      ]),
    ));
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "password can not be empty";
      });
    } else if (val != 'wgcadmin') {
      setState(() {
        _errorMessage = "Incorrect password";
      });
    } else if (val == 'wgcadmin') {
      // Get.snackbar('register', register.toString());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PushNavbar(),
        ),
      );
    }
  }
}
