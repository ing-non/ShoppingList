// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';

class AddShoppingList extends StatefulWidget {
  Map shoppingLists = {};
  final Function() notifyParent;
  AddShoppingList(this.notifyParent, {super.key});
  @override
  State<AddShoppingList> createState() => _AddShoppingListState();
}

class _AddShoppingListState extends State<AddShoppingList> {
  final shoppingListName = TextEditingController();
  var textFieldErrorText = null;
  @override

  void dispose(){
    shoppingListName.dispose();
    super.dispose();
  }
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
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text("Add new Shopping List"),
              onPressed: () async {
                addShoppingList();
                Navigator.pop(
                    context);
              },
            ),
          )
        ],
      ),
    );
  }

  void addShoppingList() async {
    widget.shoppingLists = ShoppingListPreferences.getShoppingLists();
    widget.shoppingLists[shoppingListName.text] = {};
    await ShoppingListPreferences.setShoppingLists(widget.shoppingLists);
    setState(() {
    });
  }
}
