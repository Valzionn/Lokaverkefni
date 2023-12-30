import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class Garfield {
  int stamina; // = 10;
  List<String> imaginaryBackpack;

  Garfield(this.stamina) : imaginaryBackpack = [];

  bool winnerWinnerLasagnaDinner() => ListEquality()
      .equals(imaginaryBackpack, [
        'Ground Beef',
        'Salt and Pepper',
        'Pastasauce',
        'Lasagna Noodles',
        'Cheese']);

  bool canMove() => stamina > 0;
  /*
  List<String> imaginaryBackpack = [];
  int stamina = 10;

  Garfield(this.stamina, this.imaginaryBackpack);

  bool canMove() => stamina > 0;
  bool winnerWinnerLasagnaDinner() => ListEquality().equals(imaginaryBackpack, [
        'Ground Beef',
        'Salt and Pepper',
        'Pastasauce',
        'Lasagna Noodles',
        'Cheese'
      ]);
*/
  String findFood(String food) {
    String message;
    //print('you found $food!');
    if (food == 'Hot Dogs' || food == 'Pepperoni Pizza') {
      int staminaRestored = Random().nextInt(2) + 1;
      stamina += staminaRestored;
      message =
          'You recover some stamina, and can continue collecting ingredients for your lasagna';
    } else {
      int staminaDrain = Random().nextInt(2) + 1;
      stamina -= staminaDrain;
      message =
          'Oh no it was your least favorite food, you get even more tired, lose $staminaDrain';
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
    List<String>  messages = [];
    if (!hasBeenSearched) {
      messages.add("You look around $name.");

      garfield.imaginaryBackpack.add(ingredients);
      messages.add("You found the $ingredients!");

      String food = foods[Random().nextInt(foods.length)];
      messages.add(garfield.findFood(food));

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
/*
  void searchPlace(Garfield garfield) {
    print('You enter $name and start searching for what you need.');
    garfield.imaginaryBackpack.add(ingredients);
    print('You found $ingredients!!');
    String food = foods[Random().nextInt(foods.length)];
    garfield.findFood(food);
  }
}
*/
class GarfGame extends StatefulWidget {
  @override
  _GarfieldApp createState() => _GarfieldApp();
}

//void main(/*_Garfield*/) {
  //print('You wake suddenly to a lion\'s roar, no wait it was your stomach rumbling \n ugh, mondays!,(button?) you roll out of bed and walk to the kitchen');
  //print('huh, this is strange, Jon\'s not home, and there\'s nothing to eat!');
  //print('I know what I have to do, but I don\'t know if I  have the strength to do it');
  //print('You\'ve thought up a plan, you will have to make your own lasagna to survive this monday!');

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
    Places('Steakhouse', 'Salt and Pepper', ['Steak', 'Fruit Cake'],'mmm, smells like '),
    Places('Hot Dog Trailer', 'Lasagna Noodles', ['Hot Dogs', 'Spinach'],''),
    Places('Burger Joint', 'Pastasauce', ['Hamburger', 'Raisins'],''),
    Places('Ice Cream Cart', 'Cheese', ['Ice Cream', 'Yoghurt'],''),
    Places('Vito\'s pizza', 'Ground Beef', ['Pepperoni Pizza', 'Anchovies'],'')
  ];

  final Places hub = Places('711 Maple Street', '', [], 'You better hurry and find something to eat');

  @override
  void initState() {
    super.initState();
    buildings.insert(0, hub);
    currentLocation = 0;
  }

 int currentLocation = 0;

  void _processInput(String input) {
    List<String> parts = input.toLowerCase().split('  ');

    switch (parts[0]) {
      case 'search' :
        _messages.addAll(buildings[currentLocation].searchHouse(garfield));
        break;
      case 'leave' :
        _leaveHouse();
        break;
      case 'enter' :
        if (parts.length == 3 && parts[1] == 'house') {
          _enterHouse(parts[2]);
        } else {
          _displayMessage(
            'You might have entered that wrong, try again.');
        }
        break;
      case 'status' :
        _displayMessage(
          'Currently at: ${buildings[currentLocation].name}\n Stamina: ${garfield
            .stamina}');
        break;
      default:
        _displayMessage('Unknown command: $input');
    }
    setState(() {});
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
      _displayMessage('You left the restaurant and returned to 711 Maple Street.');
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
        duration: Duration(milliseconds:200),
        curve: Curves.easeOut,
    );
  }

  Widget _buildStaminaIcons(int stamina) {
    List<Widget> icons = [];
    for (int i = 0; i < stamina; i++) {
      icons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:2.0),
          child: Icon(Icons.favorite, color: Colors.red),
        )
      );
    }
    return Wrap(
      children: icons,
      spacing: 4.0,
      runSpacing: 4.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garfield\'s Monday Madness'),
      ),
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
    );
  }
}

/*
            void main() {
    runApp(
    MaterialApp(
    home: GarfieldAppScreen(),
    ),
    );
    }

 */
/*
   ],
    ),
     )
    ],
     ))
   ]
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                'You wake suddenly to a lion\'s roar, no wait it was your stomach rumbling \n ugh, mondays!,(button?) you roll out of bed and walk to the kitchen'
                'huh, this is strange, Jon\'s not home, and there\'s nothing to eat!'
                'I know what I have to do, but I don\'t know if I  have the strength to do it \n'
                'You\'ve thought up a plan, you will have to make your own lasagna to survive this monday! \n'
                'Right now you are at: ${buildings[currentLocation].name} \n'
                'Stamina: ${garfield.stamina}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            buildings.length,
            (index) => ElevatedButton(
              onPressed: () {

                setState(() {
                  buildings[index].searchPlace(garfield);
                    if (Random().nextBool()) {
                      print('Nermal is here to annoy you!');
                      garfield.stamina -= Random().nextInt(2) +1;
                      if (!garfield.canMove()) {
                        print('you are exhausted, get taken to Liz(the vet)');
                        return;
                      }
                    }
                    currentLocation = index;
                  });
                },
                child: Text('Restaurant $index'),
              ),
            ),
          )
        ],
      ),  
    );
  }
}
*/
/*
  while (garfield.canMove() && !garfield.winnerWinnerLasagnaDinner()) {
    String? choice = stdin.readLineSync();
    int index = int.tryParse(choice ?? '') ?? 0;
    if (index > 0 && index <= buildings.length) {
      buildings[index - 1].searchPlace(garfield);
      if (Random().nextBool()) {
        print('Nermal is here to annoy you!!!');
        garfield.stamina -= Random().nextInt(2) + 1;
        if (!garfield.canMove()) {
          print('Nermal has exhausted you, you can\'t go on, GAME OVER');
          break;
        }
      }
    } else {
      print('What? You\'ve already been there, try another place');
    }
  }

  if (garfield.winnerWinnerLasagnaDinner()) {
    print(
        'Well done, You\'ve found all the ingredients for a tasty lasagna. Now we force Odie to make you some');
  } else if (!garfield.canMove()) {
    print(
        "You can't move any further, and are being taken to see Liz (the vet)");
  }
  }
}
*/
  

/*
  List<String> ingredients = [
  'Ground Beef',
  'Salt and Pepper',
  'Pastasauce',
  'Lasagna Noodles',
  'Cheese'
  ];
  // get all = win

  while (garfield.stamina > 0 && ingredients.isNotEmpty) {
      print('You wake suddenly to a lion\'s roar, no wait it was your stomach rumbling \n ugh, mondays!,(button?) you roll out of bed and walk to the kitchen');
      print('huh, this is strange, Jon\'s not home, and there\'s nothing to eat!');

  leave House
  meet Odie
  meet Nermal
  search restaurants
    print('I know what I have to do, but I don\'t know if I  have the strength to do it');
    print('You\'ve thought up a plan, you will have to make your own lasagna to survive this monday!');
    print('your quest for ingredients has begun! \n type "search" to look around Jons house');



  /*
  print(
      'You\'re the new cat on the block, and you hear through an open window cries for help, \nit\'s old Garfield, "What\'s Wrong?" you ask, He replies "Jon has left me home alone, on a monday! and there\'s nothing to eat!" \n');
  print(
      'What would you like to do? type: Help to help Garfield, and No to leave him to fend for himself ---------');
    if (stdin.readLineSync() == 'Help') {
      helpTheGarf();
    } else {
      //game ends
    }
*/      
switch(searchHotDogStand) {
      case trashCan;
      break;
    
    case benchArea;
  
    break;
    case customers;
    break;
    case 
    }
  
  make Lasagna = win
  eat goodFood = win
  lives = 0 = loss (vet visit)
  }
*/

/*
class Garfield {
  String? food;
  String? ingredients;
  String? place;
  String? rooms;
  String? blurv;

  Garfield({this.food, this.ingredients, this.place, this.rooms, this.blurv});
}
*/

/*
class Restaurants {
  List<String> food = [
  'Hot Dogs',
  'Pepperoni Pizza',
  'Hamburger',
  'Ice Cream',
  'Meatloaf',
  'Steak',
  'Spaghetti',
  'raisins',
  'Fruit Cake',
  'Spinach',
  'Yoghurt'
  'Anchovies'
  ];

  // if food 0 to 8 = restores life, sustains the Garf
  // if food 9 to 13 = stomach problems = vet visit

}
*/