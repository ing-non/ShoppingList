// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';
import 'package:test_app/main.dart';
import 'add_meal.dart';
import '../../logic/meal_list_logic.dart';

String mealListName = "Meal list";

class CalenderHome extends StatefulWidget {
  const CalenderHome({super.key});

  @override
  State<CalenderHome> createState() => _CalenderHomeState();
}

class _CalenderHomeState extends State<CalenderHome> {
  static double addMealSize = 56;
  late Map meals;
  late MealListLogic mealListLogic;
  late Color mainColor;
  late Color accentColor;

  @override
  void initState() {
    super.initState();
    meals = MenuStoragePreferences.getMeals();
    mealListLogic = MealListLogic();
    mainColor = globalMainColor;
    accentColor = globalAccentColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          title: Text(
            mealListName,
            style: TextStyle(color: Color.fromARGB(230, 65, 65, 65)),
          ),
          elevation: 0,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Ink(
                    width: addMealSize,
                    height: addMealSize,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(addMealSize / 2),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMeal())).then((value) {
                          setState(() {
                            meals = MenuStoragePreferences.getMeals();
                          });
                        });
                      },
                      child: Icon(
                        Icons.add,
                        color: Color.fromARGB(230, 65, 65, 65),
                      ),
                    )))
          ]),
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: accentColor,
          child: Center(
              child: ListView.builder(
            itemCount: meals.keys.toList().length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(bottom: 5, top: 5),
                child: ListTile(
                  key: Key('$index'),
                  title: Text("${meals.keys.toList()[index]}"),
                  trailing: GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: () {
                      mealListLogic.delete(meals.keys.toList()[index]);
                      setState(() {
                        meals = MenuStoragePreferences.getMeals();
                      });
                    },
                  ),
                ),
              );
            },
          )),
        ),
      ),
    );
  }
}
