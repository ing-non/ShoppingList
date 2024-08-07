// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';
import 'package:test_app/logic/models/shoppingList.dart';
import 'package:test_app/services/shoppingListRepository.dart';

class AddShoppingList extends StatefulWidget {
  AddShoppingList({super.key});
  @override
  State<AddShoppingList> createState() => _AddShoppingListState();
}

class _AddShoppingListState extends State<AddShoppingList> {
  final shoppingListName = TextEditingController();
  var textFieldErrorText = null;
  ShoppingListRepository shoppingListRepository = ShoppingListRepository();

  @override
  void dispose() {
    shoppingListName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromARGB(230, 65, 65, 65)),
        title: const Text('Add a shopping list',
            style: TextStyle(color: Color.fromARGB(230, 65, 65, 65))),
        backgroundColor: Color.fromARGB(255, 245, 245, 245),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: TextFormField(
                controller: shoppingListName,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter the list name",
                  errorText: textFieldErrorText,
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent)),
                )),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: Text("Add new Shopping List"),
              onPressed: () async {
                await shoppingListRepository.createShoppingList(ShoppingList(name: shoppingListName.text, order: 0, createdTime: DateTime.now()));
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
