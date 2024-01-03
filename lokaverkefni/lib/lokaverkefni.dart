import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lokaverkefni/Garf.dart';
import 'package:lokaverkefni/garf_menu.dart';

class Garfield {
  int stamina; // = 10;
  List<String> imaginaryBackpack;

  Garfield(this.stamina) : imaginaryBackpack = [];

  bool winnerWinnerLasagnaDinner() {
    var requiredItems = {
      'Ground Beef',
      'Salt and Pepper',
      'Pastasauce',
      'Lasagna Noodles',
      'Cheese'
    }.toSet();
    var backpackItems = imaginaryBackpack.toSet();
    return backpackItems.containsAll(requiredItems);
  }

  bool canMove() => stamina > 0;

  String findFood(String food) {
    String message;
    if (food == 'Hot Dogs' || food == 'Pepperoni Pizza') {
      int staminaRestored = Random().nextInt(2) + 1;
      stamina += staminaRestored;
      message =
          'You found $food and recover $staminaRestored stamina, and can continue collecting ingredients for your lasagna';
    } else {
      int staminaDrain = Random().nextInt(2) + 1;
      stamina -= staminaDrain;
      message =
          'Oh no it was $food your least favorite food, you get even more tired, lose $staminaDrain';
    }
    return message;
  }
}

class Places {
  String name;
  String ingredients;
  List<String> foods;
  String description;
  bool hasBeenSearched = false;

  Places(this.name, this.ingredients, this.foods, this.description);

  List<String> searchHouse(Garfield garfield) {
    List<String> messages = [];

    if (!hasBeenSearched) {
      messages.add("You look around $name.");

      garfield.imaginaryBackpack.add(ingredients);
      messages.add("You found the $ingredients!");

      if (foods.isNotEmpty) {
        String food = foods[Random().nextInt(foods.length)];
        messages.add(garfield.findFood(food));
      }

      if (Random().nextBool()) {
        messages.add("Nermal has come to annoy you!");
        int exhaustion = Random().nextInt(2) + 1;
        garfield.stamina -= exhaustion;
        messages.add("you got exhausted by $exhaustion points");

        if (!garfield.canMove()) {
          messages.add("Nermal has completely exhausted you. you're done for");
        }
      }
      hasBeenSearched = true;
    } else {
      messages.add("you've already searched this place, don't be silly");
    }
    return messages;
  }
}

class GarfGame extends StatefulWidget {
  @override
  _GarfieldApp createState() => _GarfieldApp();
}

class _GarfieldApp extends State<GarfGame> {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Garfield garfield = Garfield(10);

  List<Places> buildings = [
    Places('Steakhouse', 'Salt and Pepper', ['Steak', 'Fruit Cake'],
        'mmm, smells like '),
    Places(
        'Hot Dog Trailer', 'Lasagna Noodles', ['Hot Dogs', 'Spinach'], 'ooo'),
    Places('Burger Joint', 'Pastasauce', ['Hamburger', 'Raisins'], 'ooooo'),
    Places('Ice Cream Cart', 'Cheese', ['Ice Cream', 'Yoghurt'], 'ooooooo'),
    Places('Vitos pizza', 'Ground Beef', ['Pepperoni Pizza', 'Anchovies'],
        'ooooooooo')
  ];

  final Places hub = Places(
      '711 Maple Street', '', [], 'You better hurry and find something to eat');

  @override
  void initState() {
    super.initState();
    buildings.insert(0, hub);
    currentLocation = 0;
  }

  int currentLocation = 0;

  void _processInput(String input) {
    List<String> parts = input.toLowerCase().split(' ');

    switch (parts[0]) {
      case 'search':
        List<String> searchMessages =
            buildings[currentLocation].searchHouse(garfield);
        for (String message in searchMessages) {
          _addMessage(message);
        }
        if (garfield.winnerWinnerLasagnaDinner()) {
          _showVictoryScreen();
        }
        if (!garfield.canMove()) {
        _showLosingScreen(); // Show losing screen if Garfield is too exhausted
        }
        break;
      case 'leave':
        _leaveHouse();
        break;
      case 'enter':
        if (parts.length == 3 && parts[1] == 'restaurant') {
          _enterHouse(parts[2]);
        } else {
          _displayMessage('You might have entered that wrong, try again.');
        }
        break;
      case 'status':
        _displayMessage(
            'Currently at: ${buildings[currentLocation].name}\n Stamina: ${garfield.stamina}');
        break;
      default:
        _displayMessage('Unknown command: $input');
    }
    setState(() {});
  }

  void _addMessage(String message) {
    setState(() {
      _messages.insert(0, message);
    });
    _scrollToBottom();
  }

  void _showVictoryScreen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Victory!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "You've got all the ingredients and head home, Odie makes you lasagna!"),
                SizedBox(height: 20),
                Image.asset(
                    'lib/assets/garf_win.png'), // Ensure this image path is correct
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Return to Menu'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GarfMenu()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showLosingScreen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Oh no, Garfield is too exhausted to continue!'),
                SizedBox(height: 20),
                Image.asset(
                    'lib/assets/garf_defeat.png'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Return to Menu'),
              onPressed: () {
                Navigator.of(context).pop(); 
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GarfMenu()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _enterHouse(String target) {
    int index = -1;

    try {
      index = int.parse(target);
    } catch (e) {
      index = buildings.indexWhere(
          (building) => building.name.toLowerCase() == target.toLowerCase());
    }
    if (index >= 0 && index < buildings.length) {
      currentLocation = index;
      _displayMessage('Entered ${buildings[currentLocation].name}.');
      _displayMessage(buildings[currentLocation].description);
    } else {
      _displayMessage('Not a name for a place: $target');
    }
  }

  void _leaveHouse() {
    if (currentLocation != 0) {
      currentLocation = 0;
      _displayMessage(
          'You left the restaurant and returned to 711 Maple Street.');
    } else {
      _displayMessage('You are already on 711 Maple Street');
    }
  }

  void _displayMessage(String message) {
    setState(() {
      _messages.insert(0, message);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Widget _buildStaminaIcons(int health) {
    List<Widget> icons = [];
    for (int i = 0; i < health; i++) {
      icons.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Image.asset(
          'lib/assets/stamina-icon-lasagna2.png',
          width: 60, // Adjust the width as needed
          height: 60, // Adjust the height as needed
          fit: BoxFit.cover, // Adjust how the image fits within the widget
        ),
      ));
    }
    return Wrap(
      children: icons,
      spacing: 4.0, // Spacing between the icons horizontally
      runSpacing: 4.0, // Spacing between the lines of icons
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Garfield\'s Monday Madness'),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Location: ${buildings[currentLocation].name}',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Stamina', style: TextStyle(fontSize: 16)),
                    _buildStaminaIcons(garfield.stamina),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return ListTile(title: Text(_messages[index]));
                      },
                    ),
                  ),
                  TextField(
                    controller: _controller,
                    onSubmitted: (value) {
                      _processInput(value);
                      _controller.clear();
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Command',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Garfield has no food on a monday morning and Jon isn\'t home',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
