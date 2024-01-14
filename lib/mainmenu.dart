import 'package:flutter/material.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key, required this.title});
  final String title;

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class MovieGroup extends Column {
  MovieGroup(this.header);
  final String header;
  @override
  List<Widget> get children => [
        Text(header),
      ];
}
