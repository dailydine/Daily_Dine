import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(DailyDineApp());
}

class DailyDineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Dine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Arial',
      ),
      home: HomePage(),
    );
  }
}
