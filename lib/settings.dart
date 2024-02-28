import 'dart:convert';

import 'package:flutter/material.dart';
import 'database.dart';
import 'themes.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key, required this.title});
  final String title;
  @override
  Key? get key => const Key("Settings");
  List<Setting> settings = [];

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Text(
            "Settings",
            style: TextStyle(fontSize: 40),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
              itemCount: widget.settings.length,
              itemBuilder: (context, index) {
                return SettingsTab(
                    settingName: widget.settings[index].settingName,
                    isSelected: widget.settings[index].selected,
                    settingIndex: index,
                    onChangedValue: onSettingChanged);
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Back")),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                ElevatedButton(
                    onPressed: () {
                      updateSettings();
                    },
                    child: const Text("Apply Changes")),
              ],
            ),
          )
        ],
      ),
    );
  }

  void getSettings() {
    setState(() {
      widget.settings = DatabaseHelper.currentUser.settings
          .map((element) => element.copy())
          .toList();
    });
  }

  Future<void> updateSettings() async {
    await DatabaseHelper.updateSettings(widget.settings);
    backToMenu();
  }

  void backToMenu() {
    Navigator.pop(context);
  }

  void onSettingChanged(int index, bool val) {
    setState(() {
      AppTheme.currentTheme = ThemeMode.dark;
      widget.settings[index].selected = val;
    });
  }

  void saveSettings() {}
}

class SettingsTab extends StatelessWidget {
  SettingsTab(
      {required this.settingName,
      required this.isSelected,
      required this.settingIndex,
      required this.onChangedValue});

  String settingName = "";
  int settingIndex = -1;
  bool isSelected = false;

  Function(int, bool) onChangedValue;

  //(context.widget as SettingsPage).settings[settingIndex].selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(settingName),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Checkbox(
              value: isSelected,
              onChanged: (val) {
                bool confVal = val as bool;
                onChangedValue(settingIndex, confVal);
              },
            ),
          ),
        ],
      ),
    );
  }
}
