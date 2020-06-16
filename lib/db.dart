import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/material.dart';




class Baselocal {

  static connexion()async{
      final  Future<Database> database = openDatabase(join(await getDatabasesPath(), 'meetball.db'),
        onCreate: (db, version) async{
        db.execute(
          "CREATE TABLE ColorBack (color TEXT)",
        );
        db.execute(
          "CREATE TABLE Connect (email TEXT, password TEXT)",
        );
         Map<String,dynamic> image ={"color":"true"};
           await db.insert("ColorBack", image );
      },
      version: 1,
      );
  return await database;
}

 newperso(String email, String password)async{
   print('ajouter la connection dans la base de donnée');
    final Database db = await connexion();
    String table_name ='Connect';
   //  await db.execute("DELETE FROM SQLITE_SEQUENCE WHERE name='"+table_name+"';");

     Map<String, dynamic> personne =  {
          "email": email,
          "password":password
        };
        print(personne);
        
      await db.insert("Connect", personne);
    
 }
  connect()async{
     List<dynamic> personne = [];

    final Database db = await connexion();

    List tkt = await db.query('Connect');
    print(tkt);
  int nombre = tkt.length-1;


    personne.add({
          "email": tkt[nombre]['email'],
          "password": tkt[nombre]['password']
        }) ;
    print('123');

    return personne;
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