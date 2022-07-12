// Flutter imports:
// ignore_for_file: avoid_print

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import '../../app/controllers/firebase_controller.dart';

// Project imports:

class ErrorScreen extends StatelessWidget {
  final String error;
  final Function onTap;
  ErrorScreen({Key? key, required this.error, required this.onTap})
      : super(key: key);
  final FirebaseController firebaseController = Get.find();

  @override
  Widget build(BuildContext context) {
    firebaseController.logCurrentScreen(
        screenName: 'Error', screenClass: 'Error');
    print('error screen opened with error: $error');
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              "assets/images/error.gif",
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'OOPS !',
            style: TextStyle(
                fontSize: 20,
                color: Colors.purple,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            error,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.purple,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 13),
                  blurRadius: 25,
                  color: Colors.purpleAccent.withOpacity(0.3),
                ),
              ],
            ),
            child: TextButton(
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(40)),
              onPressed: () {
                onTap();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 15.0, left: 30.0, right: 30.0),
                  child: Text(
                    "Okay".toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
