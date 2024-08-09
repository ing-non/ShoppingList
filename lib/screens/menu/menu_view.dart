// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';
import 'package:test_app/logic/menu_view_logic.dart';
import 'package:test_app/services/mealRepository.dart';
import 'package:test_app/services/menuRepository.dart';
import '../../logic/models/meal.dart';

String menuName = "Menu";

class MenuHome extends StatefulWidget {
  const MenuHome({super.key});

  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  MealRepository mealRepository = MealRepository();
  MenuRepository menuRepository = MenuRepository();
  MenuViewLogic menuViewLogic = MenuViewLogic();

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
    menuViewLogic = MenuViewLogic();
    mainColor = globalMainColor;
    accentColor = globalAccentColor;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: menuViewLogic.getIndexOfCurrentWeekFromMenus(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int page = snapshot.data ?? -1;
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
              body: StreamBuilder<QuerySnapshot>(
                  stream: menuRepository.getMenus(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List menuList = snapshot.data!.docs;
                      return Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ScrollConfiguration(
                              behavior: ScrollBehavior(),
                              child: GlowingOverscrollIndicator(
                                axisDirection: AxisDirection.right,
                                color: accentColor,
                                child: PageView.builder(
                                  scrollDirection: Axis.horizontal,
                                  controller: PageController(initialPage: page),
                                  itemCount: menuList.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot document = menuList[index];
                                    String menuDocID = document.id;
                                    Map<String, dynamic> data =
                                        document.data() as Map<String, dynamic>;
                                    return ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Text(
                                                "${data["startDate"].toDate().day}.${data["startDate"].toDate().month}.${data["startDate"].toDate().year}  - ${data["endDate"].toDate().day}.${data["endDate"].toDate().month}.${data["endDate"].toDate().year}",
                                                style: TextStyle(fontSize: 22),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        menuRepository
                                                            .deleteMenu(
                                                                menuDocID);
                                                      },
                                                      child:
                                                          Icon(Icons.delete)),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          for (int i = 0; i < 7; i++)
                                            FutureBuilder<DocumentSnapshot>(
                                                future:
                                                    mealRepository.getMealByID(
                                                        data["mealIDs"][i]),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    DocumentSnapshot document =
                                                        snapshot.data!;
                                                    final mealData = document
                                                            .data()
                                                        as Map<String, dynamic>;
                                                    return ListTile(
                                                      leading: Text(
                                                          "${weekdays[i]} ${data["startDate"].toDate().add(Duration(days: i)).day}.${data["startDate"].toDate().add(Duration(days: i)).month}.${data["startDate"].toDate().add(Duration(days: i)).year}",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      trailing: Text(
                                                          "${mealData["name"]}",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    );
                                                  } else {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                })
                                        ]);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: mainColor),
                                  child: Text("Create Menu for next Week"),
                                  onPressed: () {
                                    menuViewLogic.createMenu();
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
