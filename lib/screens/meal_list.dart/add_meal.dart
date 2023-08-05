// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_app/logic/meal_list_logic.dart';
import 'package:test_app/logic/models/meal.dart';

class AddMeal extends StatefulWidget {
  const AddMeal({super.key});

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  final mealName = TextEditingController();
  final amount = TextEditingController();
  late MealListLogic mealListLogic;

  @override
  void initState() {
    super.initState();
    mealListLogic = MealListLogic();
  }

  var textFieldErrorText = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 245, 245),
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromARGB(230, 65, 65, 65)),
          title: const Text('Add a meal',
              style: TextStyle(color: Color.fromARGB(230, 65, 65, 65))),
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
        ),
        body: Center(
            child: Column(children: [
          Container(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                  controller: mealName,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Name",
                    errorText: textFieldErrorText,
                    focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent)),
                  ))),
          Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: Text("Add Item to list"),
              onPressed: () {
                Meal meal = Meal(name: mealName.text);
                mealListLogic.addMeal(meal);
                setState(() {});
                //Navigator.pop(context); Automatic return to list on button pressed, not always helpful
              },
            ),
          )
        ])));
  }
}
