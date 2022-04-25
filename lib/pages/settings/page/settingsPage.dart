import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../../app/controllers/firebase_controller.dart';
import '../../../app/controllers/theme_controller.dart';
import '../model/menuOptions.dart';
import '../widget/themeSelector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  FirebaseController firebaseController = Get.find();
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
    firebaseController.logCurrentScreen(screenName: 'Settings Screen');
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
                Get.snackbar('Language',
                    'We are currenlty supporting English and Hindi only !',
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
                      'This id is crucial to provide you with news and give you the best experience.',
                      snackPosition: SnackPosition.BOTTOM);
                },
              ),
            ],
          )
        ]),
      ),
    );
  }
}
