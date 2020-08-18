import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class Baselocal {
  static connexion() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'meetball.db'),
      onCreate: (db, version) async {
        db.execute(
          "CREATE TABLE ColorBack (color TEXT)",
        );
        db.execute(
          "CREATE TABLE Connect (email TEXT, password TEXT)",
        );
        Map<String, dynamic> image = {"color": "true"};
        await db.insert("ColorBack", image);
      },
      version: 1,
    );
    return await database;
  }

  newperso(String email, String password) async {
    final Database db = await connexion();
    Map<String, dynamic> personne = {"email": email, "password": password};
     await db.insert("Connect", personne);

      await db.insert("Connect", personne);
    List tkt = await db.query('Connect');

    if (tkt.isNotEmpty) {
      // ici on as jamais été connecter
      Map<String, dynamic> personne = {"email": email, "password": password};

      await db.insert("Connect", personne);
    } else {
      // ici on as déje des données dans la table il faut la nétoyer puis réécrire
      await db.execute("DROP TABLE IF EXISTS Connect");
       Map<String, dynamic> personne = {"email": email, "password": password};

      await db.insert("Connect", personne);
    }
  }

  connect() async {
    List<dynamic> personne = [] ;

    final Database db = await connexion();

    List tkt = await db.query('Connect');
    int nombre = tkt.length - 1;
  if(nombre >= 0){

    personne.add(
        {"email": tkt[nombre]['email'], "password": tkt[nombre]['password']});
  }
    

    return personne;
  }
  deconnect() async {
    List<dynamic> personne = [];

    final Database db = await connexion();

 await db.delete('Connect');
    

    return personne;
  }

   valColor() async { 
    String mode = "false"; 
    final Database db = await connexion();
    List tkt = await db.query('ColorBack');
    if (tkt[0]['color'].toString() == "true" ){
      mode = "true";
    }
    return mode;
  }

 mise_a_jour() async {
 final Database db = await connexion();
    List tkt = await db.query('ColorBack');

  if(tkt.isNotEmpty){
    if(tkt[0]['color'] == "true"){
         Map<String, dynamic> image = {"color": "false"};
    await db.update("ColorBack", image);
    }else{
 Map<String, dynamic> image = {"color": "true"};
    await db.update("ColorBack", image);
    }

  }else{
    Map<String, dynamic> image = {"color": "false"};
    await db.insert("ColorBack", image);
  }
  }
}
