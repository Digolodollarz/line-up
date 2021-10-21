import 'package:flutter/material.dart';
import 'package:lineup/src/leaderboard/leaderboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.green,
      ),
      home: const LeaderboardPage(),
    );
  }
}

