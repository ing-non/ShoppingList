// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';
import 'package:test_app/logic/meal_list_logic.dart';
import 'package:test_app/logic/models/meal.dart';

class AddMeal extends StatefulWidget {
  const AddMeal({super.key});

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  final nameController = TextEditingController();
  late MealListLogic mealListLogic;
  int ingredientIndex = 0;
  Map<String, Container> ingredientInputs = {};

  @override
  void initState() {
    super.initState();
    mealListLogic = MealListLogic();
    ingredientInputs[ingredientIndex.toString()] =
        (addIngredient(ingredientIndex));
  }

  var ingredientTECs = <TextEditingController>[];

  Container addIngredient(int index) {
    var ingredientController = TextEditingController();
    ingredientTECs.add(ingredientController);
    return Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                  controller: ingredientController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Ingredient",
                    errorText: textFieldErrorText,
                    focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent)),
                  )),
            ),
            GestureDetector(
              child: Icon(Icons.close),
              onTap: () {
                setState(() {
                  ingredientInputs.remove(index.toString());
                });
              },
            )
          ],
        ));
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
              padding:
                  EdgeInsets.only(left: 30, top: 20, right: 30, bottom: 20),
              child: TextFormField(
                  controller: nameController,
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
            padding: EdgeInsets.only(left: 20, top: 30),
            alignment: Alignment.centerLeft,
            child: Text(
              "Ingredients",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(230, 65, 65, 65)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child:
                Divider(color: Color.fromARGB(255, 85, 85, 85), thickness: 1),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: ListView.builder(
                        itemCount: ingredientInputs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ingredientInputs.values.toList()[index];
                        }),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                        child: Text("Add ingredient"),
                        onPressed: () {
                          ingredientIndex += 1;
                          setState(() =>
                              ingredientInputs[ingredientIndex.toString()] =
                                  (addIngredient(ingredientIndex)));
                        })),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: Text("Add Item to list"),
              onPressed: () {
                Map<String, String> ingredients = {};
                for(var i in ingredientTECs)
                {
                  ingredients[i.text] = "500g"; 
                }
                Meal meal = Meal(name: nameController.text, ingredients: ingredients);
                mealListLogic.addMeal(meal);
                setState(() {});
                //Navigator.pop(context); Automatic return to list on button pressed, not always helpful
              },
            ),
          )
        ])));
  }
}
