// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:test_app/screens/shopping_list/shopping_lists_view.dart';
import 'screens/menu/menu_view.dart';
import 'screens/meal_list.dart/meal_list_view.dart';
import 'globals.dart';

class ShoppingListApp extends StatelessWidget {
  ShoppingListApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List widgetOptions = [ShoppingListHome(), MenuHome(), CalenderHome()];

    return Scaffold(
        body: widgetOptions.elementAt(_index),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          selectedItemColor: Colors.purple,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), label: shoppingListsName),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined), label: menuName),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined), label: mealListName),
          ],
          currentIndex: _index,
          onTap: _onItemTapped,
        ));
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ShoppingListPreferences.init();

  runApp(ShoppingListApp());
}
