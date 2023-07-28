// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:test_app/globals.dart';

String menuName = "Menu";

class MenuHome extends StatefulWidget {
  const MenuHome({super.key});

  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  late PageController pageViewController;
  late Random random;
  late List<String>? meals;
  late Map allTimeMenus;
  final dtNow = DateTime.now();
  final List weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  @override
  void initState() {
    super.initState();
    random = Random();
    meals = MenuStoragePreferences.getMenus();
    allTimeMenus = MenuStoragePreferences.getAllTimeMenusPerWeek();
    pageViewController =
        PageController(initialPage: allTimeMenus.keys.toList().length);
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }


  DateTime setStartDateToMonday(DateTime start) {
    while (true) 
    {
      if (start.weekday != 1) 
      {
        start = start.subtract(Duration(days: 1));
      } 
      else 
      {
        break;
      }
    }
    return start;
  }

  List createWeeklyMenu(List<String>? meals) {
    List menu = [];
    for (int i = 0; i < 7; i++) {
      menu.add(meals![Random().nextInt(7)]);
    }
    return menu;
  }

  void allTimeMenu(DateTime startDate) {
    List weeklyMenu = [];
    for (int i = 0; i < 2; i++) {
      weeklyMenu = createWeeklyMenu(meals);
      if (!allTimeMenus.containsKey(startDate)) {
        allTimeMenus[startDate.toString()] = weeklyMenu;
      } else {
        allTimeMenus[startDate.add(Duration(days: 7))] = weeklyMenu;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate =
        setStartDateToMonday(DateTime.utc(dtNow.year, dtNow.month, dtNow.day));
    allTimeMenu(startDate);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 245, 245, 245),
        title: Text(
          menuName,
          style: TextStyle(color: Color.fromARGB(230, 65, 65, 65)),
        ),
        elevation: 0,
      ),
      body: PageView(controller: pageViewController, children: [
        for (final date in allTimeMenus.keys.toList())
          ListView(children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "${DateTime.parse(date).day}.${DateTime.parse(date).month}.${DateTime.parse(date).year} - ${DateTime.parse(date).add(Duration(days: 6)).day}.${DateTime.parse(date).add(Duration(days: 6)).month}.${DateTime.parse(date).add(Duration(days: 6)).year}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            for (int i = 0; i < 7; i++)
              ListTile(
                leading: Text(
                    "${weekdays[i]}, ${DateTime.parse(date).add(Duration(days: i)).day}-${DateTime.parse(date).add(Duration(days: i)).month}-${DateTime.parse(date).add(Duration(days: i)).year}"),
                trailing: Text("${allTimeMenus[date][i]}"),
              )
          ]),
      ]),
    );
  }
}
