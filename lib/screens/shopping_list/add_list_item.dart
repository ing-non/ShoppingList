// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';

class AddShoppingListItem extends StatefulWidget {
  String title;
  final Function notifyParent;
  AddShoppingListItem(this.title, {super.key, required this.notifyParent});

  @override
  State<AddShoppingListItem> createState() => _AddShoppingListItemState();
}

class _AddShoppingListItemState extends State<AddShoppingListItem> {
  Map shoppingLists = {};
  Map shoppingList = {};
  final itemName = TextEditingController();
  final amount = TextEditingController();
  var textFieldErrorText = null;

  @override
  void initState() {
    super.initState();
    shoppingLists = ShoppingListPreferences.getShoppingLists();
    shoppingList = shoppingLists[widget.title];
  }

  @override
  void dispose() {
    itemName.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: Text("Add Item to list"),
              onPressed: () async {
                addItem();
                //Navigator.pop(context); Automatic return to list on button pressed, not always helpful
              },
            ),
          )
        ])));
  }

  int checkItemName() {
    if (shoppingList.containsKey(itemName.text)) {
      setState(() {
        textFieldErrorText = "Please enter an item name that is not used!";
      });
      return 0;
    }
    setState(() {
      textFieldErrorText = null;
    });
    return 1;
  }

  void addItem() async {
    if (checkItemName() == 0) {
      return;
    } else {
      shoppingList[itemName.text] = [amount.text, false];
      itemName.clear();
      amount.clear();

      shoppingLists[widget.title] = shoppingList;
      ShoppingListPreferences.setShoppingLists(shoppingLists);
      widget.notifyParent();
    }
  }
}
