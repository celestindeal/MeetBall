import 'dart:convert';
import 'dart:io';
import 'package:meetballl/db.dart';
import 'package:meetballl/profVisiteur.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LoginModel extends Model {
  var id = "";
  var img = "";
  var pseudo = "";
  var email = "";
  var nom = "";
  var prenom = "";
  var password = "";
  var age = "";
  var club = "";
  var niveau = "";
  List profilvisiteur;
  bool emailvalide = true;
  bool pseudovalide = true;
    bool emailvalideModif = true;
  bool pseudovalideModif = true;
  bool faux_pseudo = true;
  var description = "";
  bool loging = false;
  bool retour_Profil = false;
  bool affmodif = true;
  List participent = [];
  Map profVisiteur = {};
  double noteVisiteur = 0;
  double noteprofil = 0;

  bool visiteur = false;
  bool boParticipation;
  String nombreIviter;
  List participation = [];
  List participationvisiteur = [];

  List lisAvisDev = [];
  bool devellopeur = false;

  bool dark = false;

  changeMode() {
    if (dark) {
      dark = false;
    } else {
      dark = true;
    }
    notifyListeners();
  }

  Future<String> Connexion(String temail, String tpassword) async {
    String url = 'http://51.210.103.151/post_connexion.php';
    String json = '{"email":"$temail"}';
    Response response = await post(url, body: json);

    var data = jsonDecode(response.body);

    int n = 0;
    id = "";
    img = "";
    pseudo = "";
    email = "";
    nom = "";
    prenom = "";
    password = "";
    age = "";
    club = "";
    niveau = "";
    description = "";
    var tailledata = data.length;
    bool validation = true;
    notifyListeners();
    while (tailledata > n && validation == true) {
      if (data[n]['email'] == temail) {
        faux_pseudo =
            false; // quant faux_ pseudo passe a false ça veux dire que le pseudo est bon mais pas les password
        if (data[n]['password'] == tpassword) {
          id = data[n]['id'];
          img = data[n]['photo'];
          pseudo = data[n]['pseudo'];
          email = data[n]['email'];
          nom = data[n]['nom'];
          prenom = data[n]['prenom'];
          password = data[n]['password'];
          age = data[n]['age'];
          club = data[n]['club'];
          niveau = data[n]['niveaux'];
          description = data[n]['message'];

          var urle = 'http://51.210.103.151/post_note.php';
          String jsone = '{"pseudo":"$pseudo"}';
          Response responsee = await post(urle, body: jsone);
          var datanote = jsonDecode(responsee.body);
          double note = 0;
          if (datanote.length == 0) {
            noteprofil = 5;
          } else {
            for (var i = 0; i < datanote.length; i++) {
              note = note + int.parse(datanote[i]['note']);
            }
            noteprofil = note / datanote.length;
          }

          validation = false;
          loging = true;
          // ajout dans la base de donner sqlite l'email et le mots de passe pour la connection automatique
          Baselocal().newperso(email, password);
          // si c'est l'un deux deux dévellopeur afficher les obption dévelloper
          if (id == "6" || id == "46") {
            devellopeur = true;
            LieuDev();
          }
        }
      }
      n++;
    }
    if (loging == false) {
      //  SnackBar(content: Text("yes"),);
      loging = true;
      retour_Profil = true;
      // avec retour_Profil = false un afficher la page de chargement
    }
    // première mise à jour de la page
    notifyListeners();
    // recherche les participation de notre joueur
    ParticipationProil();
    return " fin de fonction";
  }

  Future<String> ParticipationProil() async {
    // objectif faire les liste des participation de notre joueur dans la variable participation
    participation.clear();
    var url = 'http://51.210.103.151/post_verfparticipation.php';
    String json = '{"pseudo":"$pseudo"}';
    Response response = await post(url, body: json);
    var data_participation = jsonDecode(response.body);

    var url1 = 'http://51.210.103.151/get_match.php';
    http.Response response1 = await http.get(url1);
    var data_rencontre = jsonDecode(response1.body);
    int tailledata = data_participation.length;
    int taillerencontre = data_rencontre.length;

    // on fait le tours des la table participation
    for (var i = 0; i < tailledata; i++) {
      //si les pseudo sont identique sais que tu participe à la rencomtre

      if (pseudo == data_participation[i]['pseudo']) {
        // donc avec l'id de la rencontre on retrouve cette rencontre
        for (var n = 0; n < taillerencontre; n++) {
          if (data_participation[i]['ID_rencontre'] ==
              data_rencontre[n]['id']) {
            // et on stoke les info dans la liste participation
            Map<String, dynamic> participation_1 = {
              "id": data_participation[i]['id'],
              "jour": data_rencontre[n]['jours'],
              "heure": data_rencontre[n]['heure'],
              "nom_j": data_rencontre[n]['nombre_j'],
              "id_rencontre": data_participation[i]['ID_rencontre'],
              "lieu": data_rencontre[n]['lieu'],
              "pseudo": data_rencontre[n]['per']
            };
            participation.add(participation_1);
          }
        }
      }
    }
    img;
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> ParticipationProilVisiteur(String pseudo) async {
    // objectif faire les liste des participation de notre joueur dans la variable participation
    participationvisiteur.clear();
    var url = 'http://51.210.103.151/post_verfparticipation.php';
    String json = '{"pseudo":"$pseudo"}';
    Response response = await post(url, body: json);
    var data_participation = jsonDecode(response.body);

    var url1 = 'http://51.210.103.151/get_match.php';
    http.Response response1 = await http.get(url1);
    var data_rencontre = jsonDecode(response1.body);
    int tailledata = data_participation.length;
    int taillerencontre = data_rencontre.length;

    // on fait le tours des la table participation
    for (var i = 0; i < tailledata; i++) {
      //si les pseudo sont identique sais que tu participe à la rencomtre

      if (pseudo == data_participation[i]['pseudo']) {
        // donc avec l'id de la rencontre on retrouve cette rencontre
        for (var n = 0; n < taillerencontre; n++) {
          if (data_participation[i]['ID_rencontre'] ==
              data_rencontre[n]['id']) {
            // et on stoke les info dans la liste participation
            Map<String, dynamic> participation_1 = {
              "id": data_participation[i]['id'],
              "jour": data_rencontre[n]['jours'],
              "heure": data_rencontre[n]['heure'],
              "nom_j": data_rencontre[n]['nombre_j'],
              "id_rencontre": data_participation[i]['ID_rencontre'],
              "lieu": data_rencontre[n]['lieu'],
              "pseudo": data_rencontre[n]['per']
            };
            participationvisiteur.add(participation_1);
          }
        }
      }
    }

    // maintenante faire la parti notation
    var urle = 'http://51.210.103.151/post_note.php';
    String jsone = '{"pseudo":"$pseudo"}';
    Response responsee = await post(urle, body: jsone);
    var datanote = jsonDecode(responsee.body);
    double note = 0;
    if (datanote.length == 0) {
      noteVisiteur = 5;
    } else {
      for (var i = 0; i < datanote.length; i++) {
        note = note + int.parse(datanote[i]['note']);
      }
      noteVisiteur = note / datanote.length;
    }

    img;
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> Postinscritpion(
      String pseudo,
      String email,
      String nom,
      String prenom,
      String password,
      String jour,
      String club,
      String niveaux,
      String description,
      String image) async {
    String url = 'http://51.210.103.151/post_inscription.php';
    String json =
        '{"pseudo":"$pseudo","email":"$email","nom":"$nom","prenom":"$prenom","password":"$password","jour":"$jour","club":"$club","niveaux":"$niveaux","description":"$description","photo":"$image"}'; // make POST request
    Response response = await post(url, body: json);
    String body = response.body;
    Connexion(email, password);
    return body;
  }

  Future<String> Deconnection() {
    id = "";
    img = "";
    pseudo = "";
    email = "";
    nom = "";
    prenom = "";
    password = "";
    age = "";
    club = "";
    niveau = "";
    description = "";
    faux_pseudo = true;
    loging = false;
    retour_Profil = false;
  }

  Future<String> Modif(
      String pseudo,
      String email,
      String nom,
      String prenom,
      String password,
      String jour,
      String club,
      String niveaux,
      String description,
      String id) async {
    String url = 'http://51.210.103.151/post_modif.php';
    int idd = int.parse(id);
    affmodif = false;
    String json =
        '{"pseudo":"$pseudo","email":"$email","nom":"$nom","prenom":"$prenom","password":"$password","jour":"$jour","club":"$club","niveaux":"$niveaux","description":"$description","id":"$idd"}'; // make POST request

    Response response = await post(url, body: json);
    String body = response.body;
    Connexion(email, password);
    affmodif = false;
    return body;
  }

  Future<String> Verification_email(email_verifier, pseudo) async {
    // objectif quand on as une incription on verifi les pseudo et les email pour de pas avoir de doublon
    // si l'email est déjà pris emailvalide = false
    // si le pseudo est déjà pris pseudovalide = false
    var url = 'http://51.210.103.151/get.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    emailvalide = true;
    pseudovalide = true;
    var tailledata = data.length;
    int n = 0;

    while (tailledata > n && emailvalide == true) {
      if (email_verifier == data[n]['email']) {
        emailvalide = false;
      }
      n++;
    }
    n = 0;
    while (tailledata > n && pseudovalide == true) {
      if (pseudo == data[n]['pseudo']) {
        pseudovalide = false;
      }
      n++;
    }

    notifyListeners();
    return " fin de fonction";
  }

    Future<String> Verification_email_modif(email_verifier, pseudo_verifier) async {
    // objectif quand on as une incription on verifi les pseudo et les email pour de pas avoir de doublon
    // si l'email est déjà pris emailvalide = false
    // si le pseudo est déjà pris pseudovalide = false
    var url = 'http://51.210.103.151/get.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    emailvalideModif = true;
    pseudovalideModif = true;
    var tailledata = data.length;
    int n = 0;

    while (tailledata > n && emailvalide == true) {
      if (email_verifier == data[n]['email'] && email_verifier != email) {
        emailvalideModif = false;
      }
      n++;
    }
    n = 0;
    while (tailledata > n && pseudovalide == true ) {
      if (pseudo_verifier == data[n]['pseudo']&& pseudo_verifier != pseudo) {
        pseudovalideModif = false;
      }
      n++;
    }

    notifyListeners();
    return " fin de fonction";
  }

  Future<String> Personne_propose(String idrencontre) async {
    // objectif faire la liste des participant d'une rencontre et s'avoir si notre joueur participe à cette rencontre
    // si boParticipatoin = true  le joueur participe déja à la rencontre
    boParticipation = false;

    var url = 'http://51.210.103.151/get.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    var tailledata = data.length;
    participent.clear();
    int n = 0;

    var url2 = 'http://51.210.103.151/get_participation.php';
    http.Response response2 = await http.get(url2);
    var data2 = jsonDecode(response2.body);
    var tailledata2 = data2.length;

    for (var i = 0; i < tailledata2; i++) {
      if (idrencontre == data2[i]['ID_rencontre']) {
        n = 0;
        while (tailledata > n) {
          if (data[n]['pseudo'] == data2[i]['pseudo']) {
            participent.add(data[n]);
            if (data[n]['pseudo'] == pseudo) {
              boParticipation = true;
            }
          }
          n++;
        }
      }
    }

    notifyListeners();
    return " fin de fonction";
  }

  Future<String> LieuDev() async {
    var url = 'http://51.210.103.151/get_avisDev.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    lisAvisDev = data;
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> ChangeImage(String image) async {
    String url = 'http://51.210.103.151/post_changeImage.php';
    int idd = int.parse(id);
    affmodif = false;
    String json = '{"id":"$id","image":"$image"}';
    Response response = await post(url, body: json);
    String body = response.body;
    Connexion(email, password);
    affmodif = false;
    img =
        "https://cdn.futura-sciences.com/buildsv6/images/wide1920/6/5/2/652a7adb1b_98148_01-intro-773.jpg";
    notifyListeners();
    return body;
  }

  Future<String> Envoienote(String note, String personnenoter) async {
    String url = 'http://51.210.103.151/post_notenew.php';
    String json =
        '{"pseudo":"$pseudo","personnenoter":"$personnenoter","note":"$note"}';
    Response response = await post(url, body: json);
    String body = response.body;
    notifyListeners();
    return body;
  }

  Future<String> ProfilVisiteur() async {
    var url = 'http://51.210.103.151/get.php';
    http.Response response = await http.get(url);
     profilvisiteur = jsonDecode(response.body);
   
    notifyListeners();
    return " fin de fonction";
  }
}
