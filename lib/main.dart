// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/shopping_list/shopping_lists_view.dart';
import 'screens/menu/menu_view.dart';
import 'screens/meal_list/meal_list_view.dart';
import 'globals.dart';
import 'firebase_options.dart';

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({super.key});
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

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  await MenuStoragePreferences.init();

  runApp(ShoppingListApp());
}
