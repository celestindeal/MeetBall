import 'dart:convert';
import 'package:meetballl/db.dart';
import 'package:scoped_model/scoped_model.dart';
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
  List profilvisiteur = [];
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
  int page = 1;
  bool participationProilfuture= true;
  bool participationProilfutureVisiteur= true;


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

    List data = jsonDecode(response.body);
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
          noteprofil = num.parse(noteprofil.toStringAsFixed(2));
          validation = false;
          loging = true;
          // ajout dans la base de donner sqlite l'email et le mots de passe pour la connection automatique
          Baselocal().newperso(email, password);
          // si c'est l'un deux deux dévellopeur afficher les obption dévelloper
          devellopeur = false;
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
    var url;
    if (participationProilfuture) {
      url = 'http://51.210.103.151/post_verfparticipation.php';
    } else {
      url = 'http://51.210.103.151/post_verfparticipationPass.php';
    }
 
    String json = '{"pseudo":"$pseudo"}';
        Response response = await post(url, body: json);
    var data_rencontre = jsonDecode(response.body);
    for (var n = 0; n < data_rencontre.length; n++) {
      // et on stoke les info dans la liste participation
      Map<String, dynamic> participation_1 = {
        // "id": data_participation[i]['id'],
        "jour": data_rencontre[n]['jours'],
        "heure": data_rencontre[n]['heure'],
        "nom_j": data_rencontre[n]['nombre_j'],
        // "id_rencontre": data_participation[i]['ID_rencontre'],
        "id_rencontre": data_rencontre[n]['id'],
        "lieu": data_rencontre[n]['lieu'],
        "pseudo": data_rencontre[n]['per']
      };
      participation.add(participation_1);
    }
    img;
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> ParticipationProilVisiteur(String pseudo) async {
    // objectif faire les liste des participation de notre joueur dans la variable participation







participationvisiteur.clear();
    var url;
    if (participationProilfutureVisiteur) {
      url = 'http://51.210.103.151/post_verfparticipation.php';
    } else {
      url = 'http://51.210.103.151/post_verfparticipationPass.php';
    }
 
    String json = '{"pseudo":"$pseudo"}';
    Response response = await post(url, body: json);
    var data_rencontre = jsonDecode(response.body);
    for (var n = 0; n < data_rencontre.length; n++) {
      // et on stoke les info dans la liste participation
      Map<String, dynamic> participation_1 = {
        // "id": data_participation[i]['id'],
        "jour": data_rencontre[n]['jours'],
        "heure": data_rencontre[n]['heure'],
        "nom_j": data_rencontre[n]['nombre_j'],
        // "id_rencontre": data_participation[i]['ID_rencontre'],
        "id_rencontre": data_rencontre[n]['id'],
        "lieu": data_rencontre[n]['lieu'],
        "pseudo": data_rencontre[n]['per']
      };
      participationvisiteur.add(participation_1);
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
      noteVisiteur = (note / datanote.length);
    }
    noteVisiteur = num.parse(noteVisiteur.toStringAsFixed(2));
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
    niveaux = 'aucun';
    description = 'description';
    club = 'club';
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
      String newpseudo,
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
        '{"pseudo":"$newpseudo","email":"$email","nom":"$nom","prenom":"$prenom","password":"$password","jour":"$jour","club":"$club","niveaux":"$niveaux","description":"$description","id":"$idd"}'; // make POST request

    Response response = await post(url, body: json);
    String body = response.body;

    if (newpseudo != pseudo) {
      url = 'http://51.210.103.151/post_newpseudo.php';
      String json =
          '{"pseudo":"$pseudo","newpseudo":"$newpseudo"}'; // make POST request

      Response response = await post(url, body: json);
    }
    Connexion(email, password);
    affmodif = false;
    return body;
  }

  Future<String> Verification_inscription(email_verifier, pseudo) async {
    // objectif quand on as une incription on verifi les pseudo et les email pour de pas avoir de doublon
    // si l'email est déjà pris emailvalide = false
    // si le pseudo est déjà pris pseudovalide = false
    String url =
        'http://51.210.103.151/post_connexion_pseudo.php'; // vérification pseudo
    String json = '{"pseudo":"$pseudo"}';
    Response response = await post(url, body: json);
    List listpersonne = jsonDecode(response.body);
    if (listpersonne.isEmpty) {
      pseudovalide = true;
    } else {
      pseudovalide = false;
    }

    url = 'http://51.210.103.151/post_connexion.php'; // vérification pseudo
    json = '{"email":"$email_verifier"}';
    response = await post(url, body: json);
    listpersonne = jsonDecode(response.body);
    if (listpersonne.isEmpty) {
      emailvalide = true;
    } else {
      emailvalide = false;
    }

    notifyListeners();
    return " fin de fonction";
  }

  Future<String> Verification_email_modif(
      email_verifier, pseudo_verifier) async {
    // objectif quand on as une incription on verifi les pseudo et les email pour de pas avoir de doublon
    // si l'email est déjà pris emailvalide = false
    // si le pseudo est déjà pris pseudovalide = false
    emailvalideModif = true;
    pseudovalideModif = true;
    String url =
        'http://51.210.103.151/post_connexion_pseudo.php'; // vérification pseudo
    String json = '{"pseudo":"$pseudo_verifier"}';
    Response response = await post(url, body: json);
    List listpersonne = jsonDecode(response.body);
    if (listpersonne.isNotEmpty && pseudo_verifier != pseudo) {
      pseudovalideModif = false;
    }

    url = 'http://51.210.103.151/post_connexion.php'; // vérification email
    json = '{"email":"$email_verifier"}';
    response = await post(url, body: json);
    listpersonne = jsonDecode(response.body);
    if (listpersonne.isNotEmpty && email_verifier != email) {
      emailvalideModif = false;
    }
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> Personne_propose(String idrencontre) async {
    // objectif faire la liste des participant d'une rencontre et s'avoir si notre joueur participe à cette rencontre
    // si boParticipatoin = true  le joueur participe déja à la rencontre
    boParticipation = false;
    participent.clear();
    String url = 'http://51.210.103.151/post_participation_id.php';
    String json = '{"id":"$idrencontre"}';
    Response response = await post(url,
        body: json); // on reçoit tous les participation de cette rencontre
    List listparticipant = jsonDecode(response.body);

    for (var i = 0; i < listparticipant.length; i++) {
      String url =
          'http://51.210.103.151/post_connexion_pseudo.php'; // pour chaque participation on vas recherche le profil de la personne
      String pseudo_joueur = listparticipant[i]['pseudo'];
      String json = '{"pseudo":"$pseudo_joueur"}';
      Response response = await post(url, body: json);
      

      List listpersonne = jsonDecode(response.body);

      participent.add(listpersonne[0]);
      print(pseudo_joueur);
      print(pseudo);

      if (pseudo_joueur == pseudo) {
        boParticipation = true;
        print('1');
      }
      print('........');
    }
    print(boParticipation);
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
    // objectif changer la photo d'un utilisateur
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

  Future<String> Envoienote(String note, String personnenoter,String id_rencontre) async {
    String url = 'http://51.210.103.151/post_notenew.php';
    String json =
        '{"pseudo":"$pseudo","personnenoter":"$personnenoter","note":"$note","id":"$id_rencontre"}';
    Response response = await post(url, body: json);
    String body = response.body;
    notifyListeners();
    return body;
  }

  Future<String> ProfilVisiteur() async {
    // ici on as tous les profil pour la recherhce d'un profil visiteur
    var url = 'http://51.210.103.151/get.php';
    http.Response response = await http.get(url);
    profilvisiteur = jsonDecode(response.body);

    notifyListeners();
    return " fin de fonction";
  }
}
