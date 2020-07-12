import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class GameModel extends Model {
  var data_game = [];

  int taille = 0;

  var rencontre_visualiser;
  bool afficher = false;
  bool afficher_lieu = false;
  List commentaire = [];
  bool scrool = true;

  var adresse_lieu;
  var url_lieu;
  var urlwaze_lieu;
  var commentaire_lieu;
  var nom_t_lieu;
  var ville_lieu;
  var id_terrain;
  String terrainrencontre = "";
  int nombre = 0;
  int mmax = 10;
  int lastmmax;
  // variable de sélection des la rencontre pour la page profil rencontre
  String lieu = "";
  String id_rencontre;
  int nombJoueur;
  String daterencontre = " ";
  String heurerencontre = " ";
  String organisateur = " ";
//pour le calendar

  Map<DateTime, List> events = {};
  final _selectedDay = DateTime.now();

  void initState() {}

  Future<String> Match() async {
    var url = 'http://51.210.103.151/get_match.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    data_game = data;
    taille = data.length;
    afficher = true;
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> MatchCalendar() async {
    events.clear();
    var url = 'http://51.210.103.151/get_match.php';
    http.Response response = await http.get(url);
    final data = jsonDecode(response.body);

    for (var i = 0; i < data.length; i++) {
      String ok = "}" + data[i]['jours'].toString() + "/";
      int jour = int.parse(ok.split('}')[1].split('-')[0]);
      int mois = int.parse(ok.split('-')[1].split('-')[0]);
      String placement = jour.toString() + '-' + mois.toString() + '-';
      int ans = int.parse(ok.split(placement)[1].split('/')[0]);
      final _selectedDay = DateTime.utc(ans, mois, jour, 20, 18, 00);

      List<dynamic> valider = [];
      valider.add(data[i]);
      if (events[_selectedDay] != null) {
        events.update(_selectedDay, (list) => list..add(data[i]));
      } else {
        events.addEntries([
          MapEntry(_selectedDay, valider),
        ]);
      }
    }
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> Ajout_match(String lieu, String date, String heure,
      String nombre_joueur, String pseudo) async {
    afficher = false;
    String url = 'http://51.210.103.151/post_match.php';
    String json =
        '{"lieu":"$lieu","date":"$date","heure":"$heure","nombre_joueur":"$nombre_joueur","pseudo":"$pseudo"}'; // make POST request
    Response response = await post(url, body: json);
    String body = response.body;
    return body;
  }

  Future<String> Terrain() async {
    var url = 'http://51.210.103.151/get_terrain.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    bool validation = true;
    int nombre_tour = data.length;
    int n = 0;
    while (nombre_tour > n && validation == true) {
      if ((data[n]['nom'].toString() + " ") == lieu.toString()) {
        adresse_lieu = data[n]['adresse'];
        url_lieu = data[n]['url'];
        urlwaze_lieu = data[n]['urlwaze'];
        commentaire_lieu = data[n]['commentaire'];
        nom_t_lieu = data[n]['ville'];
        ville_lieu = data[n]['nom_t'];
        id_terrain = data[n]['id'];

        validation = false;
      }
      if ((data[n]['nom'].toString()) == lieu.toString()) {
        adresse_lieu = data[n]['adresse'];
        commentaire_lieu = data[n]['commentaire'];
        nom_t_lieu = data[n]['ville'];
        ville_lieu = data[n]['nom_t'];
        id_terrain = data[n]['id'];
        url_lieu = data[n]['url'];
        urlwaze_lieu = data[n]['urlwaze'];

        validation = false;
      }
      n++;
    }
    afficher_lieu = true;
    notifyListeners();
    return " fin de fonction";
  }

  Participation(int id_rencontre, String pseudo, int nom_inviter) async {
    String url = 'http://51.210.103.151/post_participation.php';
    String json =
        '{"id_rencontre":"$id_rencontre","nombre_joueur":"$nom_inviter","pseudo":"$pseudo"}'; // make POST request
    Response response = await post(url, body: json);
    String body = response.body;
    return body;
  }

  Commentaire() async {
    var url = 'http://51.210.103.151/post_commentaire_rencontre.php';
    String json = '{"id_rencontre":"$id_rencontre"}'; // make POST request
    Response response = await post(url, body: json);
    var data;
    if (response.body.isNotEmpty) {
      data = jsonDecode(response.body);
    }
    List list = data as List;
    // on veux savoir des nouveaux commentaires

   // si il y as un nouveau message || l'on doit affiche plus de message 
    if (list.length > nombre || mmax > lastmmax) {
      lastmmax = mmax;
      commentaire.clear();
      var nombre_tour = list.length;
      int n = 0;
      while (nombre_tour > n) {
        if ((list[n]['id_rencontre'].toString()) == id_rencontre &&
            (nombre_tour - n) < mmax) {
          commentaire.add(list[n]);
        }
        n++;
      }
      // si il n'y a pas de commentaire on n'affiche pas les container avec les commentaire
      nombre = n;
      notifyListeners();
      // on déclanche le nouveau scroll en bas que si c'est pour un nouveau message et pas pour le nouvelle affichage des messages avec les plus vieux
      if (mmax < lastmmax) {
        scrool = true;
      }
    }

    return " fin de fonction";
  }

  Ajouter_ommentaire(String commentaire, String pseudo) async {
    String url = 'http://51.210.103.151/post_commentaire.php';
    String json =
        '{"id_rencontre":"$id_rencontre","commentaire":"$commentaire","pseudo":"$pseudo"}'; // make POST request
    Response response = await post(url, body: json);
    String body = response.body;
    return body;
  }

  Sup_participation(int id_rencontre, String pseudo, int nom_inviter) async {
    String url = 'http://51.210.103.151/post_sup_participation.php';

    String json =
        '{"id_rencontre":"$id_rencontre","pseudo":"$pseudo","inviter":"$nom_inviter"}'; // make POST request
    Response response = await post(url, body: json);
    String body = response.body;
    return body;
  }
}
