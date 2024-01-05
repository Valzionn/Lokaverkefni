import 'package:flutter/material.dart';
import 'garf.dart';
import 'lokaverkefni.dart';

class GarfMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Garfield\'s Monday Madness',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
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
      ),
    );
  }
}
