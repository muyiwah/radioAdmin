import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HelloLottie extends StatefulWidget {
  HelloLottie({Key? key}) : super(key: key);

  @override
  State<HelloLottie> createState() => _HelloLottieState();
}

class _HelloLottieState extends State<HelloLottie> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.asset(
        ('lib/animations/hello.json'),
        repeat: false,
        height: MediaQuery.of(context).size.height * .45,
      ),
    );
  }
}
