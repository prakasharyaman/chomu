// import 'package:animated_text_kit/animated_text_kit.dart';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: [
          Align(
            child: Center(
              child: Image.asset('assets/images/loadinggif.gif', width: width * 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
