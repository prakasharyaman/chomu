// import 'package:animated_text_kit/animated_text_kit.dart';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var colorizeColors = [Colors.white54, Colors.white38];
    var width = MediaQuery.of(context).size.width;

    // var colorizeTextStyle = const TextStyle(
    //     fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white);
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: [
          Align(
            child: Center(
              child: Image.asset('assets/images/loadinggif.gif', width: width * 0.4),
            ),
          ),
          // Positioned(
          //   bottom: 30,
          //   right: 0,
          //   left: 0,
          //   child: Center(
          //     child: AnimatedTextKit(
          //       animatedTexts: [
          //         ColorizeAnimatedText(
          //           'Just A Moment ...',
          //           textStyle: colorizeTextStyle,
          //           colors: colorizeColors,
          //         ),
          //         ColorizeAnimatedText(
          //           'Your Content is Loading ...',
          //           textStyle: colorizeTextStyle,
          //           colors: colorizeColors,
          //         ),
          //         ColorizeAnimatedText(
          //           'Please Wait ...',
          //           textStyle: colorizeTextStyle,
          //           colors: colorizeColors,
          //         ),
          //       ],
          //       isRepeatingAnimation: true,
          //       onTap: () {
          //         // print("Tap Event");
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
