// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class EditShoppingListItem extends StatefulWidget {
  final String currentName;
  final String currentAmount;
  Map<String, List> shoppingLists;
  final int index;

EditShoppingListItem(
      this.currentName, this.currentAmount, this.shoppingLists, this.index,
      {super.key});

  @override
  State<EditShoppingListItem> createState() => _EditShoppingListItemState();
}

class _EditShoppingListItemState extends State<EditShoppingListItem> {
  var textFieldErrorText = null;

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
    Map<String, List<dynamic>> newShoppingLists = {};
    List<String> oldlistKeys = widget.shoppingLists.keys.toList();
    List<String> listKeys = widget.shoppingLists.keys.toList();
    listKeys[index] = newName;
    for (int i = 0; i < listKeys.length; i++)
    {
      if (listKeys[i] == newName)
      {
        bool checkValue = widget.shoppingLists[oldlistKeys[i]]![1];
        newShoppingLists[listKeys[i]] = [newAmount, checkValue];
      }
      else{
      newShoppingLists[listKeys[i]] = widget.shoppingLists[listKeys[i]]!;
      }
    }

    widget.shoppingLists.clear();
    for (final String idx in listKeys)
    {
      widget.shoppingLists[idx] = newShoppingLists[idx]!;
    }

  }
}
