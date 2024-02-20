import 'package:assignment_project/database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'mainmenu.dart';

import 'package:flutter/rendering.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.title});
  final String title;
  @override
  Key? get key => const Key("MainMenu");

  double levelUpPercent = 0.0;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfilePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
