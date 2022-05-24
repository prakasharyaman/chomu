import 'dart:io';

import 'package:chomu/pages/feedback/controller/feedback_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class FeedbackScreen extends GetView<FeedbackController> {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        body: Form(
          key: controller.feedbackFormKey,
          child: ListView(
            children: [
              _buildheadingWidget(
                heading: 'Feedback ',
              ),
              // title
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.titleController,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Title',
                      hintText: 'title of feedback ....'),
                ),
              ),

              // description
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.descriptionController,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Description',
                      hintText: 'description ....'),
                ),
              ),
              const Divider(),
              _buildheadingWidget(
                heading: 'Share Screenshot (optional)',
              ),

              // files select
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Obx(() => Text(
                          controller.fileSelected.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.image,
                        );

                        if (result != null) {
                          File file = File(result.files.single.path!);
                          controller.fileSelected.value = 'One file selected';
                          controller.file = file;
                          Get.snackbar('File Selected', 'You Selected an image',
                              duration: const Duration(seconds: 2));
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.file_present_rounded),
                          Text('Select Files'),
                        ],
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple),
                        shadowColor:
                            MaterialStateProperty.all(Colors.deepPurpleAccent),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // contact
              _buildheadingWidget(
                heading: 'Contact',
              ),
              // phone no
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.phoneController,
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Phone No. (optional)',
                      hintText: 'your phone no....'),
                ),
              ),
              //email
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.emailController,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Email (optional)',
                      hintText: 'your email ....'),
                ),
              ),

              //submit button
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    controller.submitFeedback();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Obx(() => controller.submitButton.value),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurple),
                    shadowColor:
                        MaterialStateProperty.all(Colors.deepPurpleAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.deepPurple,
              automaticallyImplyLeading: false,
              centerTitle: false,
              pinned: true,
              // leading: IconButton(
              //     onPressed: () {
              //       Get.back();
              //     },
              //     icon: const Icon(Icons.chevron_left_rounded)),
              expandedHeight: Get.height * 0.3,
              flexibleSpace: FlexibleSpaceBar(
                // logo image
                background: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: Get.height * 0.2,
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
              title: const Text('FeedBack'),
            ),
          ];
        },
      ),
    );
  }

  Widget _buildheadingWidget({required String heading}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        heading,
        style: const TextStyle(
            fontSize: 18,
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
