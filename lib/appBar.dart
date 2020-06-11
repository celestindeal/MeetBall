

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/Model_co.dart';





 
 AppBar headerNav(context,) {
  
 
  return AppBar(
    title: Text("BasketCopie"),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey,
                    ),
                    child:RaisedButton(child:Text("changer de mode"),
                      onPressed: (){
                        ScopedModel.of<LoginModel>(context).changeMode();
                        Navigator.of(context).pop();
                      })
                  ),
                );
              });
            },
          );
        },
      ),
    ],
  );
}
