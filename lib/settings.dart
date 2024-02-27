import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key, required this.title});
  final String title;
  @override
  Key? get key => const Key("Settings");

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
