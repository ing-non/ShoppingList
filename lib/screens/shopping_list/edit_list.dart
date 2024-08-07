// ignore_for_file: prefer_const_constructors

import 'package:test_app/globals.dart';
import 'package:flutter/material.dart';
import 'package:test_app/services/shoppingListRepository.dart';

class EditShoppingList extends StatefulWidget {
  final String docID;
  final String title;
  const EditShoppingList(this.docID, this.title, {super.key});

  @override
  State<EditShoppingList> createState() => _EditShoppingListState();
}

class _EditShoppingListState extends State<EditShoppingList> {
  Map shoppingLists = {};
  ShoppingListRepository shoppingListRepository = ShoppingListRepository();

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
                shoppingListRepository.editShoppingList(widget.docID, itemName.text);
                Navigator.pop(context);
              },
            ),
          )
        ])));
  }
}
