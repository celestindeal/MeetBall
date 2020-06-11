import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/material.dart';




class Baselocal {

  static connexion()async{
    print("on passe dans la fonction");
      final  Future<Database> database = openDatabase(join(await getDatabasesPath(), 'basket.db'),
        onCreate: (db, version) async{
        db.execute(
          "CREATE TABLE ColorBack (color TEXT)",
        );
         Map<String,dynamic> image ={"color":"true"};
           await db.insert("ColorBack", image );
      },
      version: 1,
      );
  return await database;
}


 static valColor()async{
  final Database db = await connexion();
    List tkt = await db.query('ColorBack');
 return tkt[0]['color']; 
 }
 


 static mise_a_jour(String color)async{
  final Database db = await connexion();
  await db.delete('ColorBack');
  Map<String,dynamic> image ={"color":color};
  await db.insert("ColorBack", image );
 return" tkt[0]['color']"; 
 }

}