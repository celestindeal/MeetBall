import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class   GameModel extends Model {
  var data_game = [] ;
  String lieu = "";
  int taille = 0;
  String id_rencontre;
  var rencontre_visualiser;
  bool afficher = false;
  bool afficher_lieu = false;
  List commentaire = [];
  var adresse_lieu ;
  var nom_t_lieu;
  var ville_lieu;
  var id_terrain;

  


    
  
  Future<String> Match() async{
    var url = 'http://51.210.103.151/get_match.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    data_game = data; 
    taille = data.length;
    afficher = true;
  notifyListeners();
return " fin de fonction" ;
}

Future<String> Ajout_match (String lieu , String date, String heure, String nombre_joueur ,String pseudo) async{
  afficher = false;
  String url = 'http://51.210.103.151/post_match.php';
  String json ='{"lieu":"$lieu","date":"$date","heure":"$heure","nombre_joueur":"$nombre_joueur","pseudo":"$pseudo"}';  // make POST request
  Response response = await post(url,  body: json);  
  String body = response.body;
  print('reponse ajouter un match .................................................................');
  print(body);
   print('reponse.................................................................');
  return body;
  }


Future<String> Terrain() async{
    var url = 'http://51.210.103.151/get_terrain.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    bool validation = true;
    int nombre_tour = data.length;
    int n = 0;
     while  (nombre_tour > n && validation == true){
       if ((data[n]['nom'].toString()+" ")==lieu.toString()){
        adresse_lieu = data[n]['adresse'] ;
        nom_t_lieu = data[n]['ville'];
        ville_lieu = data[n]['nom_t'] ;
        id_terrain =data[n]['id'] ; 
       
        validation = false;
       }
       if ((data[n]['nom'].toString())==lieu.toString()){
        adresse_lieu = data[n]['adresse'] ;
        nom_t_lieu = data[n]['ville'];
        ville_lieu = data[n]['nom_t'] ;
        id_terrain =data[n]['id'] ; 
       
        validation = false;
       }
       n++;
     }
    afficher_lieu = true;
  notifyListeners();
return " fin de fonction" ;
}


Participation(int nom_inviter,bool mediateur, String pseudo)async{
  String url = 'http://51.210.103.151/post_participation.php';
  String json ='{"id_rencontre":"$id_rencontre","nombre_joueur":"$nom_inviter","pseudo":"$pseudo","mediateur":"$mediateur"}';  // make POST request
  Response response = await post(url,  body: json);  
  String body = response.body;
  print('reponse participation.................................................................');
  print(body);
   print('fin reponse.................................................................');
  return body;

}
Commentaire()async{
  commentaire.clear();
  print('commantauire');
  var url = 'http://51.210.103.151/get_commentaire.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
  List list  = data as List;
    print('yeziofbzgRUIVBUIREQBVUQERGUBBENOIMerobiOBnomnoimnoinqtrngtr');
    var nombre_tour = list.length;
    print(nombre_tour);
    int n = 0;
    while  (nombre_tour > n){
       if ((data[n]['id_rencontre'].toString())==id_rencontre){
       commentaire.add(data[n]);
       }
       n++;
     }
  notifyListeners();
return " fin de fonction" ;
}
Ajouter_ommentaire(String commentaire ,String pseudo)async{
  String url = 'http://51.210.103.151/post_commentaire.php';
  String json ='{"id_rencontre":"$id_rencontre","commentaire":"$commentaire","pseudo":"$pseudo"}';  // make POST request
  Response response = await post(url,  body: json);  
  String body = response.body;
  print('reponse commanet ier.................................................................');
  print(body);
   print('fin reponse.................................................................');
  return body;
}
 Sup_participation(String inviter,String id,String id_rencontre)async{
  String url = 'http://51.210.103.151/post_sup_participation.php';
  String json ='{"id_rencontre":"$id_rencontre","id_participation":"$id","inviter":"$inviter"}';  // make POST request
  Response response = await post(url,  body: json);  
  String body = response.body;
  print('reponse commanet ier.................................................................');
  print(body);
   print('fin reponse.................................................................');
  return body;
 }
}


