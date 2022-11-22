// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class EditShoppingListItem extends StatefulWidget {
  String title = "";
  Map<String, Map<String, List<dynamic>>> shoppingLists = {};
  EditShoppingListItem(this.title, this.shoppingLists, {super.key});

  @override
  State<EditShoppingListItem> createState() => _EditShoppingListItemState();
}

class _EditShoppingListItemState extends State<EditShoppingListItem> {
  @override
  Widget build(BuildContext context) {
    final itemName = TextEditingController(text: widget.title);
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
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent)),
                  ))),
          Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text("Edit List"),
              onPressed: () {
                editItem(itemName.text);
                Navigator.pop(context);
              },
            ),
          )
        ])));
  }

  void editItem(String newName) {
    Map<String, Map<String, List<dynamic>>> newShoppingLists = {};
    List oldkeyList = widget.shoppingLists.keys.toList();
    List keyList = widget.shoppingLists.keys.toList();
    int index = calcIndex(newName, keyList);
    keyList[index] = newName;

    for (int i = 0; i < keyList.length; i++) {
      newShoppingLists[keyList[i]] = widget.shoppingLists[oldkeyList[i]]!;
    }

    widget.shoppingLists.clear();
    for (final String idx in keyList) {
      widget.shoppingLists[idx] = newShoppingLists[idx]!;
    }
  }

  int calcIndex(String newName, List keyList) {
    int index = 0;
    while (true) {
      if (widget.title == keyList[index]) {
        return index;
      }
      index++;
    }
  }
}
