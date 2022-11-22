// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_app/screens/shopping_list/shopping_lists_view.dart';
import 'screens/menu/menu_view.dart';
import 'screens/meal_list.dart/meal_list_view.dart';

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

  int idxShoppingLists = 0;
  int idxMenus = 1;

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List widgetOptions = [
      ShoppingListHome(shoppingLists),
      MenuHome(),
      CalenderHome()
    ];

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


Map<String, Map<String, List>> shoppingLists = {
  'firstShoppingList': test,
  'secondShoppingList': test,
  'thirdShoppingList': test2,
  'thiardShopppingList': test3,
  'thirdShfopppingList': test2,
  'thirdShopfppingList': test2,
  'thirdShoppfpingList': test2,
};

Map<String, List> test = {
  'f': ["400g", false],
  'bar': ["400g", false],
  'asd': ["400g", false],
  'df': ["500g", false],
  'dsaf': ["400g", false],
  'a': ["400g", false],
  'ad': ["400g", false],
  'foo': ["400g", true],
};

Map<String, List> test2 = {
  'df': ["500g", false],
  'dasdff': ["500g", false],
};

Map<String, List> test3 = {
  'df': ["500g", false],
};

void main() {
  runApp(ShoppingListApp());
}
