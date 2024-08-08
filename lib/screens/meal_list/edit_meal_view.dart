// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/logic/models/ingredient.dart';
import 'package:test_app/services/mealRepository.dart';

class EditMealView extends StatefulWidget {
  final String name;
  final String mealDocID;
  const EditMealView(this.mealDocID, this.name, {super.key});

  @override
  State<EditMealView> createState() => _EditMealViewState();
}

class _EditMealViewState extends State<EditMealView> {
  late TextEditingController nameController;
  MealRepository mealRepository = MealRepository();
  var ingredientTECs = <TextEditingController>[];

  var textFieldErrorText = null;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);

    mealRepository.getIngredients(widget.mealDocID).forEach((element) {
      for (var doc in element.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        ingredientTECs.add(TextEditingController(text: data["name"]));
      }
    });
  }

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
                StreamBuilder<QuerySnapshot>(
                    stream: mealRepository.getIngredients(widget.mealDocID),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List ingredientList = snapshot.data!.docs;
                        return Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: ListView.builder(
                                itemCount: ingredientTECs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                                controller:
                                                    ingredientTECs[index],
                                                style: TextStyle(fontSize: 18),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: "Ingredient",
                                                  errorText: textFieldErrorText,
                                                  focusedErrorBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red)),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black26),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .purpleAccent)),
                                                )),
                                          ),
                                          GestureDetector(
                                            child: Icon(Icons.close),
                                            onTap: () {
                                              setState(() {
                                                ingredientTECs.removeAt(index);
                                              });
                                            },
                                          )
                                        ],
                                      ));
                                }),
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
                Container(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                        child: Text("Add ingredient"),
                        onPressed: () {
                          setState(() {
                            ingredientTECs.add(TextEditingController());
                          });
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
                mealRepository.deleteIngredients(widget.mealDocID);
                mealRepository.editMeal(widget.mealDocID, nameController.text);
                for (var ing in ingredientTECs) {
                  Ingredient ingredient = Ingredient(ing.text, DateTime.now());
                  mealRepository.addIngredient(widget.mealDocID, ingredient);
                }
                Navigator.pop(context);
              },
            ),
          )
        ])));
  }
}
