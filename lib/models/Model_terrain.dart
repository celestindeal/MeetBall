import 'dart:convert';
import 'dart:core';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class TerrainModel extends Model {
  var data_terrain = [];
  var data_terrainDev = [];
  var nomlist = ["Not relevant"];
  int taille_terrain = 0;
  int taille_terrainDev = 0;
  bool afficher = false;

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

  Future<String> List() async {
    var url = 'http://51.210.103.151/get_terrain.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    int n = 0;
    taille_terrain = data.length;
    nomlist.clear();
    while (taille_terrain > n) {
      nomlist.add(data[n]['nom']);
      n++;
    }
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> TerrainDev() async {
    var url = 'http://51.210.103.151/get_terrainDev.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    data_terrainDev = data;
    taille_terrainDev = data.length;
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> AjouterTerrain(String nom, String adresse, String ville,
      int nombre_terrain, String image, String sol, String ouverture) async {
    var url = 'http://51.210.103.151/post_terrain.php';
    String json =
        '{"nom":"$nom","adresse":"$adresse","ville":"$ville","nombre_terrain":"$nombre_terrain","image":"$image","sol":"$sol","ouverture":"$ouverture"}'; // make POST request
    Response response = await post(url, body: json);
    String body = response.body;
    return body;

    notifyListeners();
    return " fin de fonction";
  }
}
