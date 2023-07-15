// ignore_for_file: prefer_const_constructors

import 'package:test_app/globals.dart';
import 'package:flutter/material.dart';

class EditShoppingList extends StatefulWidget {
  final String title;
  final ValueChanged<String> onTitleChanged;
  const EditShoppingList(this.title, {super.key, required this.onTitleChanged});

  @override
  State<EditShoppingList> createState() => _EditShoppingListState();
}

class _EditShoppingListState extends State<EditShoppingList> {
  Map shoppingLists = {};
  @override
  void initState() {
    super.initState();
    shoppingLists = ShoppingListPreferences.getShoppingLists();
  }

  @override
  Widget build(BuildContext context) {
    final itemName = TextEditingController(text: widget.title);
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 245, 245),
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromARGB(230, 65, 65, 65)),
          title: const Text('Edit Shoppinglist',
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
                    hintText: "Enter the new list name",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent)),
                  ))),
          Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: Text("Edit List"),
              onPressed: () {
                editList(itemName.text);
                Navigator.pop(context);
                widget.onTitleChanged(itemName.text);
              },
            ),
          )
        ])));
  }

  void editList(String newName) {
    Map newShoppingLists = {};
    List oldkeyList = shoppingLists.keys.toList();
    List keyList = shoppingLists.keys.toList();
    int index = calcIndex(newName, oldkeyList);
    keyList[index] = newName;
    for (int i = 0; i < keyList.length; i++) {
      newShoppingLists[keyList[i]] = shoppingLists[oldkeyList[i]]!;
    }
    shoppingLists = newShoppingLists;
    ShoppingListPreferences.setShoppingLists(shoppingLists);
  }

  int calcIndex(String newName, List keyList) {
    for(int index = 0; index < keyList.length; index++) {
      if (widget.title == keyList[index]) {
        return index;
      }
    }
    return -1;
  }
}
