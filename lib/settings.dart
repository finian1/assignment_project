import 'package:flutter/material.dart';
import 'database.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key, required this.title});
  final String title;
  @override
  Key? get key => const Key("Settings");
  List<Setting> settings = [];

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

//Settings page, displays a list of settings that the user can alter
//A local copy of the settings is made so that the user can leave the page without committing the new settings
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
          const Text(
            "Settings",
            style: TextStyle(fontSize: 40),
          ),
          SizedBox(
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
          SizedBox(
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

  //Gets the user's current settings
  void getSettings() {
    setState(() {
      widget.settings = DatabaseHelper.currentUser.settings
          .map((element) => element.copy())
          .toList();
    });
  }

  //Updates the users settings to the new values
  Future<void> updateSettings() async {
    await DatabaseHelper.updateSettings(widget.settings);
    backToMenu();
  }

  //Returns to previous page
  void backToMenu() {
    Navigator.pop(context);
  }

  //Updates our local copy of the settings
  void onSettingChanged(int index, bool val) {
    setState(() {
      widget.settings[index].selected = val;
    });
  }
}

// Settings tab that includes a setting name and a check box with onChangedValue function for user input
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
    return SizedBox(
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
