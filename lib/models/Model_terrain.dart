import 'dart:convert';
import 'dart:core';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class TerrainModel extends Model {
  var vaDataTerrain = [];
  var inDataTerrainDev = [];
  int tailleTerrain = 0;
  int tailleTerrainDev = 0;
  bool afficher = false;
  bool afficherDev = false;

  bool nomVerifier = true;

  Future<String> terrain() async {
    // pour la recherche des terrains nous avons ici la list de tout les terrain visible par les utilisateurs
    var url = 'http://51.210.103.151/get_terrain.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    vaDataTerrain = data;
    tailleTerrain = data.length;
    afficher = true;
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> terrainDev() async {
    var url = 'http://51.210.103.151/get_terrain_dev.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    inDataTerrainDev = data;
    tailleTerrainDev = data.length;
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> verificationNom(String nomEcrit) async {
    var url = 'http://51.210.103.151/get_terrain_nom.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);

    nomVerifier = true;
    bool obtimisation = false;
    int nombre = data.length;
    for (var i = 0; i < nombre && obtimisation == false; i++) {
      if (nomEcrit == data[i]) {
        nomVerifier = false;
        obtimisation = true;
      }
    }
    return " fin de fonction";
  }

  Future<String> ajouterTerrain(
      String nom,
      String adresse,
      String ville,
      int nombreTerrain,
      String image1,
      String image2,
      String image3,
      String image4,
      String sol,
      String ouverture,
      String urlgoogle,
      String urlwaze) async {
    var url = 'http://51.210.103.151/post_terrain.php';
    String json =
        '{"nom":"$nom","adresse":"$adresse","ville":"$ville","nombre_terrain":"$nombreTerrain","image1":"$image1","image2":"$image2","image3":"$image3","image4":"$image4","sol":"$sol","ouverture":"$ouverture","urlgoogle":"$urlgoogle","urlwaze":"$urlwaze"}'; // make POST request

    Response response = await post(url, body: json);
    String body = response.body;
    return body;
  }
}
