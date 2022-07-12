// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:chomu/app/controllers/firebase_controller.dart';
import '../../../repository/meme_repository.dart';

class FeedbackController extends GetxController {
  static FeedbackController feedbackController = Get.find();
  final feedbackFormKey = GlobalKey<FormState>();
  var fileSelected = 'No file selected'.obs;
  String paragraph = '';
  String title = '';
  String? phoneNo;
  String? email;
  File? file;
  // ignore: prefer_const_constructors
  Rx<Widget> submitButton = Text('Submit').obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  submitFeedback() async {
    // ignore: prefer_const_constructors
    submitButton.value = Text('Submitting....');
    try {
      FirebaseController firebaseController = Get.find();
      var date = MemeRepository().getDate();
      var id = await firebaseController.getUid();
      if (feedbackFormKey.currentState!.validate()) {
        if (file != null) {
          debugPrint('feedback with image');
          var url = await uploadFileToCloud(file!, id + 'xx' + date);
          await uploadFormToCloud(url.toString(), id, date);
        } else {
          await uploadFormToCloud(id.toString(), id, date);
        }
      }
      Get.back();
      Get.back();
      Get.snackbar('Feedback Submitted', 'Thanks for giving us your feedback');
    } catch (e) {
      Get.back();
      Get.back();
      Get.snackbar('Failed', 'Failed to submit feedback');
    }
  }

  uploadFormToCloud(String? imageUrl, String id, String date) async {
    try {
      await FirebaseFirestore.instance.collection('feedbacks').doc().set({
        'userId': id,
        'date': date,
        'image': imageUrl.toString(),
        'title': titleController.text.toString(),
        'description': descriptionController.text.toString(),
        'phoneNo': phoneController.text.toString(),
        'email': emailController.text.toString(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  uploadFileToCloud(File file, String name) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('feedback/$name');
      await ref.putFile(file);

      return FirebaseStorage.instance
          .ref()
          .child('feedback/$name')
          .getDownloadURL();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
