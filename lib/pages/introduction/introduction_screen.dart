// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

// 🌎 Project imports:
import 'package:chomu/app/controllers/firebase_controller.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  void _onIntroEnd(context) {
    debugPrint('IntroductionShown ,now asking for age');

    int age = 25;

    showMaterialNumberPicker(
      headerColor: Colors.deepPurple,
      buttonTextColor: Colors.deepPurple,
      context: context,
      title: 'Please Pick Your Age',
      maxNumber: 100,
      minNumber: 13,
      selectedNumber: age,
      onConfirmed: () {
        Get.back();
        debugPrint('Age is $age');
        FirebaseController firebaseController = Get.find();
        firebaseController.saveUserAge(age: age);
      },
      onCancelled: () {
        Get.back();
        debugPrint('Age is $age');
        FirebaseController firebaseController = Get.find();
        firebaseController.saveUserAge(age: age);
      },
      onChanged: (value) => setState(() => age = value),
    );
  }

  Widget _buildFullscreenImage(String url) {
    return Image(
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      image: NetworkImage(url),
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
            child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ));
      },
      errorBuilder:
          (BuildContext context, Object object, StackTrace? stackTrace) {
        debugPrint('Image threw an error \n Reporting to the developer');

        return const Center(
          child: Icon(
            Icons.error,
          ),
        );
      },
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  Widget _buildNetworkImage(String url, [double width = 350]) {
    return Image(
      image: NetworkImage(url),
      width: width,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
            child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ));
      },
      errorBuilder:
          (BuildContext context, Object object, StackTrace? stackTrace) {
        debugPrint('Image threw an error \n Reporting to the developer');

        return const Center(
          child: Icon(
            Icons.error,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, color: Colors.white);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.deepPurple,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      isTopSafeArea: true,

      globalBackgroundColor: Colors.deepPurple,

      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Let\'s go right Away !',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        // welcome
        PageViewModel(
          title: "Welcome to CHOMU",
          body: "Let's show you what we have to offer ! Swipe to continue ",
          image: _buildImage('images/logo.png'),
          decoration: pageDecoration,
        ),
        // memes
        PageViewModel(
          title: "Memes",
          body:
              "When we say memes, We Mean It !. We have a lot of memes to share with you. Swipe to continue ",
          image: _buildNetworkImage('https://i.imgur.com/fY3EOju.png'),
          decoration: pageDecoration,
        ),
        // stories
        PageViewModel(
          title: "Stories",
          body:
              "Whats the best way to enjoy good content ? Stories !. We have a lot of stories to share with you. Swipe to continue ",
          image: _buildNetworkImage('https://i.imgur.com/FHxzIY0.png'),
          decoration: pageDecoration,
        ),
        // videos
        PageViewModel(
          title: "Videos",
          body: "Watch good videos.\n Psss, We too hate Cringe content !.",
          image: _buildFullscreenImage('https://i.imgur.com/GijajBA.png'),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
        // end
        PageViewModel(
          title: "Enjoy !",
          body:
              "We hope you enjoy our app. If you have any feedback, please let us know.",
          image: _buildNetworkImage('https://i.imgur.com/p6eNx99.png'),
          decoration: pageDecoration,
          footer: ElevatedButton(
            child: const Text(
              'Yayy ! Let\'s Go !',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _onIntroEnd(context),
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      // onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      // showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(
        Icons.arrow_back,
        color: Colors.orangeAccent,
      ),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.orangeAccent,
      ),
      done: const Text('Done',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),

      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.orangeAccent,
        activeColor: Colors.orange,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.deepPurple,
        shadows: [
          BoxShadow(
            color: Colors.deepPurpleAccent,
            blurRadius: 5.0,
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
