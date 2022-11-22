// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:math';

String menuName = "Menu";

Map allTimeMenus = {
  DateTime.utc(2022, 10, 17): [
    "Soup",
    "Bolognese",
    "Pancakes",
    "Potatoes",
    "Salmon",
    "Carbonarra",
    "Chicken"
  ],
  DateTime.utc(2022, 10, 24): [
    "Chicken",
    "Bolognese",
    "Carbonarra",
    "Potatoes",
    "Salmon",
    "Pancakes",
    "Soup"
  ]
};

class MenuHome extends StatefulWidget {
  const MenuHome({super.key});

  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  PageController pageViewController = PageController();
  @override
  void initState() {
    super.initState();
    pageViewController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  final dtNow = DateTime.now();
  static double addListSize = 56;
  final List weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  final List meals = [
    "Salmon",
    "Bolognese",
    "Carbonarra",
    "Potatoes",
    "Chicken",
    "Pancakes",
    "Soup"
  ];

  var random = Random();

  DateTime startDateToMonday(DateTime start) {
    while (true) {
      if (start.weekday != 1) {
        start = start.subtract(Duration(days: 1));
      } else {
        break;
      }
    }
    return start;
  }

  List createWeeklyMenu(List weekdays, List meals) {
    List menu = [];
    for (int i = 0; i < weekdays.length; i++) {
      menu.add(meals[Random().nextInt(7)]);
    }
    return menu;
  }

  void allTimeMenu(DateTime start) {
    List weeklyMenu = [];
    for (int i = 0; i < 2; i++) {
      weeklyMenu = createWeeklyMenu(weekdays, meals);
      if (!allTimeMenus.containsKey(start)) {
        allTimeMenus[start] = weeklyMenu;
      } else {
        allTimeMenus[start.add(Duration(days: 7))] = weeklyMenu;
      }
    }
    pageViewController =
        PageController(initialPage: allTimeMenus.keys.toList().length - 2);
  }

  @override
  Widget build(BuildContext context) {
    DateTime start =
        startDateToMonday(DateTime.utc(dtNow.year, dtNow.month, dtNow.day));
    allTimeMenu(start);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          title: Text(
            menuName,
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
      body: PageView(controller: pageViewController, children: [
        for (final date in allTimeMenus.keys.toList())
          ListView(children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "${date.day}.${date.month}.${date.year} - ${date.add(Duration(days: 6)).day}.${date.add(Duration(days: 6)).month}.${date.add(Duration(days: 6)).year}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            for (int i = 0; i < 7; i++)
              ListTile(
                leading: Text(
                    "${weekdays[i]}, ${date.add(Duration(days: i)).day}-${date.add(Duration(days: i)).month}-${date.add(Duration(days: i)).year}"),
                trailing: Text("${allTimeMenus[date][i]}"),
              )
          ]),
      ]),
    );
  }
}
