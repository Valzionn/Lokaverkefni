import 'package:flutter/material.dart';
import 'garf_menu.dart';

void main() {
  runApp(GarfApp));
}

class GarfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garfield\'s Monday Madness',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: GarfMenu(),
    );
  }
}

