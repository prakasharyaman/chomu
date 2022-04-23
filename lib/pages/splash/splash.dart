import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorizeColors = [Colors.purple, Colors.purpleAccent];
    var width = MediaQuery.of(context).size.width;

    var colorizeTextStyle = const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: width / 2.5,
            backgroundColor: Colors.purple,
            child: CircleAvatar(
              radius: width / 2.52,
              backgroundImage: const AssetImage('assets/images/loading.gif'),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'Just A Moment ...',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),
                ColorizeAnimatedText(
                  'Your Content is Loading ...',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),
                ColorizeAnimatedText(
                  'Please Wait ...',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),
              ],
              isRepeatingAnimation: true,
              onTap: () {
                // print("Tap Event");
              },
            ),
          ),
        ],
      ),
    );
  }
}
