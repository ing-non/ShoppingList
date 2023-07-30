// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';
import 'package:test_app/logic/menu_view_logic.dart';
import '../../logic/models/meal.dart';

String menuName = "Menu";

class MenuHome extends StatefulWidget {
  const MenuHome({super.key});

  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  late PageController pageViewController;
  late MenuViewLogic menuViewLogic;
  late Map? meals;
  late Map allTimeMenus;
  final dtNow = DateUtils.dateOnly(DateTime.now());
  late Color mainColor;
  late Color accentColor;
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
    meals = MenuStoragePreferences.getMeals();
    allTimeMenus = MenuStoragePreferences.getAllTimeMenusPerWeek();

    menuViewLogic = MenuViewLogic(allTimeMenus);
    pageViewController = PageController(
        initialPage: menuViewLogic.getIndexOfCurrentWeekFromAllTimeMenus());
    MenuStoragePreferences.addMeal(
        Meal(name: "test2", ingredients: {"ing": "3g"}));

    mainColor = globalMainColor;
    accentColor = globalAccentColor;
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
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
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.right,
                color: accentColor,
                child: PageView(controller: pageViewController, children: [
                  for (final date in allTimeMenus.keys.toList())
                    ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                "${DateTime.parse(date).day}.${DateTime.parse(date).month}.${DateTime.parse(date).year} - ${DateTime.parse(date).add(Duration(days: 6)).day}.${DateTime.parse(date).add(Duration(days: 6)).month}.${DateTime.parse(date).add(Duration(days: 6)).year}",
                                style: TextStyle(fontSize: 20),
                              ),
                              if (dtNow.compareTo(DateTime.parse(date)) <
                                  0) ...[
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                        onTap: () {
                                          menuViewLogic.deleteMenu(
                                              pageViewController.page);
                                          setState(() {});
                                        },
                                        child: Icon(Icons.delete)),
                                  ),
                                )
                              ]
                            ],
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
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                  child: Text("Create Menu for next Week"),
                  onPressed: () {
                    menuViewLogic.createMenu();
                    setState(() {});
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
