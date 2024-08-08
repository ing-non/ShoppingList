// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';
import 'package:test_app/services/mealRepository.dart';
import 'add_meal_view.dart';
import 'edit_meal_view.dart';

String mealListName = "Meal list";

class CalenderHome extends StatefulWidget {
  const CalenderHome({super.key});

  @override
  State<CalenderHome> createState() => _CalenderHomeState();
}

class _CalenderHomeState extends State<CalenderHome> {
  static double addMealSize = 56;
  late Color mainColor;
  late Color accentColor;
  MealRepository mealRepository = MealRepository();

  @override
  void initState() {
    super.initState();
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
                                builder: (context) => AddMealView()));
                      },
                      child: Icon(
                        Icons.add,
                        color: Color.fromARGB(230, 65, 65, 65),
                      ),
                    )))
          ]),
      body: StreamBuilder<QuerySnapshot>(
          stream: mealRepository.getMeals(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List mealList = snapshot.data!.docs;
              return ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: accentColor,
                  child: Center(
                      child: ListView.builder(
                    itemCount: mealList.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = mealList[index];
                      String mealDocID = document.id;
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String mealText = data["name"];
                      return GestureDetector(
                        child: Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            child: ListTile(
                                key: Key('$index'),
                                title: Text(mealText),
                                trailing: GestureDetector(
                                  child: Icon(Icons.delete),
                                  onTap: () {
                                    mealRepository.deleteMeal(mealDocID);
                                  },
                                ))),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditMealView(mealDocID, mealText)));
                        },
                      );
                    },
                  )),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
