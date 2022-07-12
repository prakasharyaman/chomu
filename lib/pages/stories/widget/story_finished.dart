// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:chomu/ads/widgets/small_banner_ad.dart';
import 'package:chomu/pages/home/controller/home_controller.dart';
import 'package:chomu/pages/stories/controller/stories_controller.dart';

class StoriesFinished extends StatefulWidget {
  const StoriesFinished({Key? key}) : super(key: key);

  @override
  State<StoriesFinished> createState() => _StoriesFinishedState();
}

class _StoriesFinishedState extends State<StoriesFinished> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StoriesController _controller = Get.find();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          //background gradient
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              const Color.fromARGB(255, 178, 74, 196).withOpacity(0.4),
              const Color.fromARGB(255, 88, 55, 145).withOpacity(0.4),
            ],
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '🎉\nYaaY',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'You\'re Awesome 👏',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'You have finished all Stories in this section ',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Let\'s go to Home or Watch more',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // button to go back
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // more stories
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
                        _controller.getMemes();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              top: 15.0, bottom: 15.0, left: 30.0, right: 30.0),
                          child: Text(
                            "Watch More 🚀",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'or',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //go home
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
                        HomeController _homecontroller = Get.find();
                        _homecontroller.changeCurrentPage(0);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              top: 15.0, bottom: 15.0, left: 30.0, right: 30.0),
                          child: Text(
                            "Go Home 🏠",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: SmallBannerAd(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
