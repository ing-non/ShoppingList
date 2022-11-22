// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

String mealListName = "Meal list";

class CalenderHome extends StatefulWidget {
  const CalenderHome({super.key});

  @override
  State<CalenderHome> createState() => _CalenderHomeState();
}

class _CalenderHomeState extends State<CalenderHome> {
  @override
  static double addListSize = 56;
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
                    width: addListSize,
                    height: addListSize,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(addListSize / 2),
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Container()))
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: Icon(
                        Icons.add,
                        color: Color.fromARGB(230, 65, 65, 65),
                      ),
                    )))
          ]),
      body: Center(
        child: Text(mealListName),
      ),
    );
  }
}
