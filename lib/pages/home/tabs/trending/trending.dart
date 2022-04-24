// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../common/enum/status.dart';
// import '../../../../common/memeWidget/meme_widget.dart';
// import '../../../splash/splash.dart';
// import 'controller/trending_controller.dart';

// class Trending extends GetView<TrendingController> {
//   Trending({Key? key}) : super(key: key);
//   final trendingController = Get.put(TrendingController());

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 1,
//         title: const Text('Chomu'),
//         leading: Icon(Icons.menu),
//       ),
//       body: Container(
//         decoration: kHomeBoxDecoration(),
//         margin: const EdgeInsets.only(left: 1, right: 1),
//         child: GetBuilder<TrendingController>(
//           init: TrendingController(),
//           builder: (controller) => Obx(() {
//             switch (controller.status.value) {
//               case Status.loading:
//                 return const Splash();
//               case Status.loaded:
//                 return RefreshIndicator(
//                   displacement: 80,
//                   onRefresh: () async {
//                     controller.getMemes();
//                   },
//                   child: ListView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: controller.memes.length + 1,
//                       itemBuilder: (BuildContext context, int index) {
//                         return MemeWidget(
//                           meme: controller.memes[index],
//                           height: height,
//                         );
//                       }),
//                 );

//               case Status.error:
//                 return Center(
//                   child: Text('Error'),
//                 );
//             }
//           }),
//         ),
//       ),
//     );
//   }

//   BoxDecoration kHomeBoxDecoration() {
//     return BoxDecoration(
//         gradient: Get.isDarkMode
//             ? const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomLeft,
//                 colors: [
//                   Color.fromARGB(255, 9, 9, 9),
//                   Color.fromARGB(255, 8, 8, 8),
//                 ],
//               )
//             : const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomLeft,
//                 colors: [
//                   Color.fromARGB(255, 251, 252, 253),
//                   Color.fromARGB(255, 244, 247, 250),
//                 ],
//               ));
//   }
// }
