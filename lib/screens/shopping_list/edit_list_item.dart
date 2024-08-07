// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';
import 'package:test_app/services/shoppingListRepository.dart';

class EditShoppingListItem extends StatefulWidget {
  final String currentName;
  final String currentAmount;
  final String listDocID;
  final String itemDocID;

  const EditShoppingListItem(
      this.listDocID, this.itemDocID, this.currentName, this.currentAmount,
      {super.key});

  @override
  State<EditShoppingListItem> createState() => _EditShoppingListItemState();
}

class _EditShoppingListItemState extends State<EditShoppingListItem> {
  var textFieldErrorText = null;

  ShoppingListRepository shoppingListRepository = ShoppingListRepository();

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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: Text("Edit item"),
              onPressed: () {
                shoppingListRepository.editShoppingListItem(widget.listDocID,
                    widget.itemDocID, itemName.text, amount.text);
                Navigator.pop(context);
              },
            ),
          )
        ])));
  }
}
