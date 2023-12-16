import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

class Garfield {
  List<String> imaginaryBackpack = [];
  int stamina = 5;

  Garfield(this.stamina, this.imaginaryBackpack);

  bool canMove() => stamina > 0;
  bool winnerWinnerLasagnaDinner() => ListEquality().equals(imaginaryBackpack, [
        'Ground Beef',
        'Salt and Pepper',
        'Pastasauce',
        'Lasagna Noodles',
        'Cheese'
      ]);

  void findFood(String food) {
    print('you found $food!');
    if (food == 'Hot Dogs' || food == 'Pepperoni Pizza') {
      int staminaRestored = Random().nextInt(2) + 1;
      stamina += staminaRestored;
      print(
          'You recover some stamina, and can continue collecting ingredients for your lasagna');
    } else {
      int staminaDrain = Random().nextInt(2) + 1;
      stamina -= staminaDrain;
      print(
          'Oh no it was your least favorite food, you get even more tired, lose $staminaDrain');
    }
  }
}

class Places {
  String buildings;
  String ingredients;
  List<String> foods;

  Places(this.buildings, this.ingredients, this.foods);

  void searchPlace(Garfield garfield) {
    print('You enter $buildings and start searching for what you need.');
    garfield.imaginaryBackpack.add(ingredients);
    print('You found $ingredients!!');
    String food = foods[Random().nextInt(foods.length)];
    garfield.findFood(food);
  }
}

void main(/*_Garfield*/) {
  print('You wake suddenly to a lion\'s roar, no wait it was your stomach rumbling \n ugh, mondays!,(button?) you roll out of bed and walk to the kitchen');
  print('huh, this is strange, Jon\'s not home, and there\'s nothing to eat!');
  print('I know what I have to do, but I don\'t know if I  have the strength to do it');
  print('You\'ve thought up a plan, you will have to make your own lasagna to survive this monday!');

  Garfield garfield = Garfield(5, []);

  List<Places> buildings = [
    Places('Steakhouse', 'Salt and Pepper', ['Steak', 'Fruit Cake']),
    Places('Hot Dog Trailer', 'Lasagna Noodles', ['Hot Dogs', 'Spinach']),
    Places('Burger Joint', 'Pastasauce', ['Hamburger', 'Raisins']),
    Places('Ice Cream Cart', 'Cheese', ['Ice Cream', 'Yoghurt']),
    Places('Vito\'s pizza', 'Ground Beef', ['Pepperoni Pizza', 'Anchovies'])
  ];

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