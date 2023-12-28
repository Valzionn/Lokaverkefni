import 'package:flutter/material.dart';
import 'lokaverkefni.dart';

class GarfMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garfield\'s Monday Madness'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Begin Madness'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GarfGame()),
            );
          },
        ),
      ),
    );
  }
}