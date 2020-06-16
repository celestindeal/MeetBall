import 'dart:convert';
import 'dart:io';
import 'package:meetballl/db.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LoginModel extends Model {
  var id = "";
  var img = "";
  var pseudo = "";
  var email = "";
  var numero = "";
  var password = "";
  var age = "";
  var club = "";
  var niveau = "";
  bool emailvalide = true;
  bool pseudovalide = true;
  bool faux_pseudo = true;
  var description = "";
  bool loging = false;
  bool retour_Profil = false;
  bool affmodif = true;
  var visiter_img;
  var visiter_pseudo;
  var visiter_numero;
  var visiter_age;
  var visiter_club;
  var visiter_niveau;
  var visiter_description;
  bool visiteur = false;
  bool boParticipation;
  String nombreIviter;
  List participation = [];
  List lisAvisDev = [];
  bool devellopeur = false;

  bool dark = false;

changeMode(){
  if(dark){
      dark =false;
     }else{
      dark =true;
     }
     notifyListeners();
}


  Future<String> Connexion(String temail, String tpassword) async {
    var url = 'http://51.210.103.151/get.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    int n = 0;
    id = "";
    img = "";
    pseudo = "";
    email = "";
    numero = "";
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
          numero = data[n]['numero'];
          password = data[n]['password'];
          age = data[n]['age'];
          club = data[n]['club'];
          niveau = data[n]['niveaux'];
          description = data[n]['message'];
          validation = false;
          loging = true;
          Baselocal().newperso(email, password);
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
    }

    
 
    notifyListeners();
    Participation();
    return " fin de fonction";
  }

  Future<String> Participation() async {
    participation.clear();
    var url = 'http://51.210.103.151/get_participation.php';
    http.Response response = await http.get(url);
    var data_participation = jsonDecode(response.body);
    var url1 = 'http://51.210.103.151/get_rencontre.php';
    http.Response response1 = await http.get(url1);
    var data_rencontre = jsonDecode(response1.body);
    int tailledata = data_participation.length;
    int taillerencontre = data_rencontre.length;
    for (var i = 0; i < tailledata; i++) {
      if (pseudo == data_participation[i]['pseudo']) {

        for (var n = 0; n < taillerencontre; n++) {
          if (data_participation[i]['ID_rencontre'] ==
              data_rencontre[n]['id']) {
            Map<String, dynamic> participation_1 = {
              "id": data_participation[i]['id'],
              "jour": data_rencontre[n]['jours'],
              "heure": data_rencontre[n]['heure'],
              "nom_j": data_rencontre[n]['nombre_j'],
              "inviter": data_participation[i]['inviter'],
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

  Future<String> Postinscritpion(
      String pseudo,
      String email,
      String telephone,
      String password,
      String jour,
      String club,
      String niveaux,
      String description,
      String image) async {
    String url = 'http://51.210.103.151/post_inscription.php';
    String json =
        '{"pseudo":"$pseudo","email":"$email","telephone":"$telephone","password":"$password","jour":"$jour","club":"$club","niveaux":"$niveaux","description":"$description","photo":"$image"}'; // make POST request
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
    numero = "";
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
      String telephone,
      String password,
      String jour,
      String club,
      String niveaux,
      String description,
      String photo,
      String id) async {
    String url = 'http://51.210.103.151/post_modif.php';
    int idd = int.parse(id);
    affmodif = false;
    String json =
        '{"pseudo":"$pseudo","email":"$email","telephone":"$telephone","password":"$password","jour":"$jour","club":"$club","niveaux":"$niveaux","description":"$description","lieu_photo":"$img","photo":"$photo","id":"$idd"}'; // make POST request
    Response response = await post(url, body: json);
    String body = response.body;
    Connexion(email, password);
    affmodif = false;
    return body;
  }

  Future<String> Verification_email(email_verifier, pseudo) async {
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

  Future<String> Personne_propose(String tpseudo) async {
    boParticipation = false;
    var url = 'http://51.210.103.151/get.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    bool validation = true;
    var tailledata = data.length;
    int n = 0;
    while (tailledata > n && validation == true) {
      if (data[n]['pseudo'] == tpseudo) {
        visiter_img = data[n]['photo'];
        visiter_pseudo = data[n]['pseudo'];
        visiter_numero = data[n]['numero'];
        visiter_age = data[n]['age'];
        visiter_club = data[n]['club'];
        visiter_niveau = data[n]['niveaux'];
        visiter_description = data[n]['message'];
        validation = false;
        if (tpseudo == pseudo) {
          visiteur = false;
        } else {
          visiteur = true;
        }
      }
      n++;
    }
    if (visiteur == true) {
      var url = 'http://51.210.103.151/get_participation.php';
      http.Response response = await http.get(url);
      var data = jsonDecode(response.body);
      bool validation = true;
      var tailledata = data.length;
      n = 0;
      while (tailledata > n) {
        if (pseudo == data[n]['pseudo']) nombreIviter = data[n]['inviter'];
        boParticipation = true;
        n++;
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
    img= "https://cdn.futura-sciences.com/buildsv6/images/wide1920/6/5/2/652a7adb1b_98148_01-intro-773.jpg";
    notifyListeners();
    return body;
  }
}
