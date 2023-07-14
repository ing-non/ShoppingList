// ignore_for_file: prefer_const_constructors
import 'package:test_app/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditShoppingList extends StatefulWidget {
  String title = "";
  final ValueChanged<String> onTitleChanged;
  EditShoppingList(this.title, {super.key, required this.onTitleChanged});

  @override
  State<EditShoppingList> createState() => _EditShoppingListState();
}

class _EditShoppingListState extends State<EditShoppingList> {
    Map shoppingLists = {};
  @override
  void initState()
  {
    super.initState();
    shoppingLists = ShoppingListPreferences.getShoppingLists();
  }  

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
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text("Edit List"),
              onPressed: () {
                editItem(itemName.text);
                Navigator.pop(context);
                widget.onTitleChanged(itemName.text);
              },
            ),
          )
        ])));
  }

  void editItem(String newName) {
    Map newShoppingLists = {};
    List oldkeyList = shoppingLists.keys.toList();
    List keyList = shoppingLists.keys.toList();
    int index = calcIndex(newName, keyList);
    keyList[index] = newName;

    for (int i = 0; i < keyList.length; i++) {
      newShoppingLists[keyList[i]] = shoppingLists[oldkeyList[i]]!;
    }

    shoppingLists = {};
    for (String idx in keyList) {
      shoppingLists[idx] = newShoppingLists[idx]!;
    }
    ShoppingListPreferences.setShoppingLists(shoppingLists);
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
