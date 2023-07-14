// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';

class EditShoppingListItem extends StatefulWidget {
  final String currentName;
  final String currentAmount;
  final String title;
  final int index;

  EditShoppingListItem(
      this.currentName, this.currentAmount, this.title, this.index,
      {super.key});

  @override
  State<EditShoppingListItem> createState() => _EditShoppingListItemState();
}

class _EditShoppingListItemState extends State<EditShoppingListItem> {
  Map shoppingLists = {};
  Map shoppingList = {};
  var textFieldErrorText = null;

  void initState() {
    super.initState();
    shoppingLists = ShoppingListPreferences.getShoppingLists();
    shoppingList = shoppingLists[widget.title];
  }

  @override
  Widget build(BuildContext context) {
    final itemName = TextEditingController(text: widget.currentName);
    final amount = TextEditingController(text: widget.currentAmount);
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 245, 245),
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromARGB(230, 65, 65, 65)),
          title: const Text('Add an Item to list',
              style: TextStyle(color: Color.fromARGB(230, 65, 65, 65))),
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
        ),
        body: Center(
            child: Column(children: [
          Container(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                  controller: itemName,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter the item name",
                    errorText: textFieldErrorText,
                    focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent)),
                  ))),
          Container(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                  controller: amount,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter the amount",
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purpleAccent))))),
          Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text("Edit item"),
              onPressed: () {
                editItem(widget.index, itemName.text, amount.text);
                Navigator.pop(context);
              },
            ),
          )
        ])));
  }

  void editItem(int index, String newName, String newAmount) {
    Map<String, List<dynamic>> newShoppingList = {};
    List oldlistKeys = shoppingList.keys.toList();
    List listKeys = shoppingList.keys.toList();
    listKeys[index] = newName;
    for (int i = 0; i < listKeys.length; i++) {
      if (listKeys[i] == newName) {
        bool checkValue = shoppingList[oldlistKeys[i]]![1];
        newShoppingList[listKeys[i]] = [newAmount, checkValue];
      } else {
        newShoppingList[listKeys[i]] = shoppingList[listKeys[i]]!;
      }
    }

    shoppingList.clear();
    for (final String idx in listKeys) {
      shoppingList[idx] = newShoppingList[idx]!;
    }

    shoppingLists[widget.title] = shoppingList;
    ShoppingListPreferences.setShoppingLists(shoppingLists);
  }
}
