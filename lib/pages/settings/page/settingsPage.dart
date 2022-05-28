// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../../app/controllers/firebase_controller.dart';
import '../../../app/controllers/theme_controller.dart';
import '../../../app/controllers/version_controller.dart';
import '../model/menuOptions.dart';
import '../widget/themeSelector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  FirebaseController firebaseController = Get.find();
  VersionController versionController = Get.find();
  PackageInfo? packageInfo;
  int? groupValue = 0;
  final List<MenuOptionsModel> themeOptions = [
    MenuOptionsModel(
        key: "system", value: 'System'.tr, icon: Icons.brightness_4),
    MenuOptionsModel(
        key: "light", value: 'Light'.tr, icon: Icons.brightness_low),
    MenuOptionsModel(key: "dark", value: 'Dark'.tr, icon: Icons.brightness_3)
  ];

  @override
  void initState() {
    super.initState();
    packageInfo = versionController.packageInfo;
    FirebaseController firebaseController = Get.find();
    firebaseController.logCurrentScreen(
        screenClass: 'Settings', screenName: 'Settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: SettingsList(sections: [
          //Common section , doesnt really do anything
          SettingsSection(title: const Text('Common'), tiles: [
            SettingsTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              description: const Text('English'),
              onPressed: (i) {
                Get.snackbar(
                    'Language', 'We are currenlty supporting English only !',
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
            SettingsTile(
              leading: const Icon(Icons.cloud_queue_rounded),
              title: const Text('Environmnent'),
              description: const Text('Production'),
              onPressed: (i) {
                Get.snackbar('Environment',
                    'You are using production version of the App.',
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
            SettingsTile(
              leading: const Icon(Icons.devices_other_rounded),
              title: const Text('Platform'),
              description: const Text('Android'),
              onPressed: (i) {
                Get.snackbar(
                    'Platform', 'You are using the App on an Android device .',
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
          ]),
          // theme widget changes the theme of the app
          SettingsSection(title: const Text('Theme'), tiles: [
            CustomSettingsTile(
              child: GetBuilder<ThemeController>(
                builder: (controller) => ThemeSelector(
                    menuOptions: themeOptions,
                    selectedOption: controller.currentTheme,
                    onValueChanged: (value) {
                      controller.setThemeMode(value);
                    }),
              ),
            ),
          ]),
          SettingsSection(
            title: const Text(
              'User Details',
            ),
            tiles: [
              SettingsTile(
                leading: const Icon(Icons.account_box_rounded),
                title: const Text('Anonymous id'),
                description:
                    Text(firebaseController.getUid() ?? 'Not Logged In'),
                onPressed: (i) {
                  Get.snackbar('Id ?',
                      'This id is crucial to provide you with posts and give you the best experience.',
                      snackPosition: SnackPosition.BOTTOM);
                },
              ),
            ],
          ),
          //package info

          packageInfo == null
              ? const SettingsSection(title: Text('Chomu'), tiles: [])
              : SettingsSection(
                  title: const Text(
                    'App Info',
                  ),
                  tiles: [
                    //app name
                    SettingsTile(
                      leading: const Icon(Icons.android_rounded),
                      title: const Text('App Name'),
                      description: Text(packageInfo!.appName),
                      onPressed: (i) {
                        Get.snackbar('App Name ?',
                            'name of the app is ${packageInfo!.appName}',
                            snackPosition: SnackPosition.BOTTOM);
                      },
                    ),
                    //package  name
                    SettingsTile(
                        leading: const Icon(Icons.scatter_plot_rounded),
                        title: const Text('Package Name'),
                        description: Text(packageInfo!.packageName),
                        onPressed: (i) {
                          Get.snackbar('Package Name ?',
                              'name of the package is ${packageInfo!.packageName}',
                              snackPosition: SnackPosition.BOTTOM);
                        }),
                    //Version  name
                    SettingsTile(
                      leading: const Icon(Icons.precision_manufacturing_sharp),
                      title: const Text('Version Code'),
                      description: Text(packageInfo!.version),
                      onPressed: (i) {
                        Get.snackbar('Version Code ?',
                            'name of the Version is ${packageInfo!.version}',
                            snackPosition: SnackPosition.BOTTOM);
                      },
                    ),
                    //Build  Number
                    SettingsTile(
                      leading: const Icon(Icons.build),
                      title: const Text('Build Number'),
                      description: Text(packageInfo!.buildNumber),
                      onPressed: (i) {
                        Get.snackbar('Build Number ?',
                            'value of the buildNumber is ${packageInfo!.buildNumber}',
                            snackPosition: SnackPosition.BOTTOM);
                      },
                    ),
                  ],
                ),
        ]),
      ),
    );
  }

  crashCauseDialog(i) {
    Get.defaultDialog(
      title: 'Package Name ?',
      buttonColor: Colors.red,
      cancelTextColor: Colors.red,
      content: Text(
        packageInfo!.packageName +
            ' is your package name\nThe Force Crash button is a test button for users experiencing crashes.Press Force Crash to test it.\nWARNING! This might crash the app.',
      ),
      onCancel: () {},
      onConfirm: () {
        Get.back();
        // Get.snackbar('Crash Reported',
        //     'A crash wash reported with ${packageInfo!.packageName} and user id ${firebaseController.getUid()}',
        //     snackPosition: SnackPosition.BOTTOM);
        // throw Exception();
      },
      textConfirm: 'Force Crash',
    );
  }
}
