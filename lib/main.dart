import 'package:flutter/material.dart';
import 'package:hotwheels/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HOTWHEELS',
      home: HomePage(),
    );
  }
}
