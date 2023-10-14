// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';
import 'package:test_app/logic/meal_list_logic.dart';
import 'package:test_app/logic/models/meal.dart';

class EditMealView extends StatefulWidget {
  final String name;
  const EditMealView(this.name, {super.key});

  @override
  State<EditMealView> createState() => _EditMealViewState();
}

class _EditMealViewState extends State<EditMealView> {
  late TextEditingController nameController;
  late MealListLogic mealListLogic;
  Map<String, dynamic> ingredients = {};
  Map<String, Container> ingredientInputs = {};
  int ingredientIndex = 0;

  @override
  void initState() {
    super.initState();
    mealListLogic = MealListLogic();
    nameController = TextEditingController(text: widget.name);
    Map meals = MenuStoragePreferences.getMeals();
    ingredients = meals[widget.name];

    for (int i = 0; i < ingredients.length; i++) {
      ingredientInputs[ingredients.keys.toList()[i]] = addIngredient(i);
    }
  }

  var ingredientTECs = <TextEditingController>[];

  Container addIngredient(int index) {
    var ingredientController =
        TextEditingController(text: ingredients.keys.toList()[index]);
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
                  ingredients.remove(index.toString());
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
          title: const Text('Edit meal',
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
                        itemCount: ingredients.length,
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
              child: Text("Edit meal"),
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
            ),
          )
        ])));
  }
}
