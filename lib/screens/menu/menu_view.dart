// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:test_app/globals.dart';
import 'package:test_app/logic/createNewMenu.dart';

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
  final dtNow = DateUtils.dateOnly(DateTime.now());
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
    meals = MenuStoragePreferences.getMeals();
    allTimeMenus = MenuStoragePreferences.getAllTimeMenusPerWeek();
    pageViewController =
      PageController(initialPage: allTimeMenus.keys.toList().length);

    CreateNewMenu createMenu = CreateNewMenu(allTimeMenus);
    List weeklyMenu = createMenu.getWeeklyMenu(setStartDateToMonday(dtNow));
    allTimeMenus[setStartDateToMonday(dtNow).toString()] = weeklyMenu;

    MenuStoragePreferences.setAllTimeMenusPerWeek(allTimeMenus);
  }

  @override
    void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  DateTime setStartDateToMonday(DateTime startDate) {
    while (true) 
    {
      if (startDate.weekday != 1) 
      {
        startDate = startDate.subtract(Duration(days: 1));
      } 
      else 
      {
        break;
      }
    }
    return startDate;
  }

  @override
  Widget build(BuildContext context) {
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
