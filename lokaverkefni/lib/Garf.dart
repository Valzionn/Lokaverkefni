import 'package:flutter/material.dart';
import 'garf_menu.dart';

void main() {
  runApp(GarfApp());
}

class GarfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garfield\'s Monday Madness',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'SourceCodePro'
      ),
      home: BackgroundWrapper(child: GarfMenu()),
    );
  }
}

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  BackgroundWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/garf_background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}