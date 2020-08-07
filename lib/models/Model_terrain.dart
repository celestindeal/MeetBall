import 'dart:convert';
import 'dart:core';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class TerrainModel extends Model {
  var data_terrain = [];
  var data_terrainDev = [];
  int taille_terrain = 0;
  int taille_terrainDev = 0;
  bool afficher = false;
  bool nom_verifier = true;

  Future<String> Terrain() async {
    var url = 'http://51.210.103.151/get_terrain.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    data_terrain = data;
    taille_terrain = data.length;
    afficher = true;
    notifyListeners();
    return " fin de fonction";
  }


  Future<String> TerrainDev() async {
    var url = 'http://51.210.103.151/get_terrain.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    data_terrainDev = data;
    taille_terrainDev = data.length;
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> Verification_nom(String nom_ecrit) async {
    print('fonction');

    var url = 'http://51.210.103.151/get_terrain_nom.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    print(data.length);
    
    nom_verifier = true;
    bool obtimisation = false;
    int nombre = data.length;
    for (var i = 0; i < nombre && obtimisation == false; i++) {
      print(data[i]);
      if(nom_ecrit == data[i]){
        nom_verifier = false;
        obtimisation = true;
      }
    }
    print('fonction');
    return " fin de fonction";
  }

  Future<String> AjouterTerrain(String nom, String adresse, String ville,
      int nombre_terrain, String image1,String image2, String image3,String image4,String sol, String ouverture) async {
    var url = 'http://51.210.103.151/post_terrain.php';
    String json =
        '{"nom":"$nom","adresse":"$adresse","ville":"$ville","nombre_terrain":"$nombre_terrain","image1":"$image1","image2":"$image2","image3":"$image3","image4":"$image4","sol":"$sol","ouverture":"$ouverture"}'; // make POST request

    Response response = await post(url, body: json);
    String body = response.body;
 
    return body;

    notifyListeners();
    return " fin de fonction";
  }
}
