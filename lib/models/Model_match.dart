import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class GameModel extends Model {
  var vaDataGame = [];

  int taille = 0;

  var vaRencontreVisualiser;
  bool afficher = false;
  bool boAfficherLieu = false;
  List lisCommentaire = [];
  bool scrool = true;

  var vaAdresseLieu;
  var vaUrlLieu;
  var vaUrlwazeLieu;
  var vaCommentaireLieu;
  var vaNomLieu;
  var vavilleLieu;
  var vaIdTerrain;
  String terrainrencontre = "";
  int nombre = 0;
  int mmax = 15;
  int lastmmax = 0;
  // variable de sélection des la rencontre pour la page profil rencontre
  String lieu = "";
  String inIdRencontre;
  int nombJoueur;
  String daterencontre = " ";
  String heurerencontre = " ";
//pour le calendar

  Map<DateTime, List> events = {};
  final selectedDay = DateTime.now();

  // variable pour rajouter un match
  String date = "Date";
  String time = "Heure";
// variable pour les commentaire

  void initState() {}

  Future<String> match() async {
    var url = 'http://51.210.103.151/get_match_future.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    vaDataGame = data;
    taille = data.length;
    afficher = true;
    notifyListeners();
    return " fin de fonction";
  }

  Future<String> matchCalendar() async {
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

  Future<String> ajoutMatch(String lieu, String date, String heure,
      String strinNombreJoueur, String pseudo) async {
    afficher = false;
    String url = 'http://51.210.103.151/post_match.php';
    String json =
        '{"lieu":"$lieu","date":"$date","heure":"$heure","nombre_joueur":"$strinNombreJoueur","pseudo":"$pseudo"}'; // make POST request
    Response response = await post(url, body: json);
    String body = response.body;
    return body;
  }

  Future<String> terrain() async {
    var url = 'http://51.210.103.151/get_terrain.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    bool validation = true;
    int inNombreTour = data.length;
    int n = 0;
    while (inNombreTour > n && validation == true) {
      if ((data[n]['nom'].toString() + " ") == lieu.toString()) {
        vaAdresseLieu = data[n]['adresse'];
        vaUrlLieu = data[n]['url'];
        vaUrlwazeLieu = data[n]['urlwaze'];
        vaCommentaireLieu = data[n]['commentaire'];
        vaNomLieu = data[n]['ville'];
        vavilleLieu = data[n]['nom_t'];
        vaIdTerrain = data[n]['id'];

        validation = false;
      }
      if ((data[n]['nom'].toString()) == lieu.toString()) {
        vaAdresseLieu = data[n]['adresse'];
        vaCommentaireLieu = data[n]['commentaire'];
        vaNomLieu = data[n]['ville'];
        vavilleLieu = data[n]['nom_t'];
        vaIdTerrain = data[n]['id'];
        vaUrlLieu = data[n]['url'];
        vaUrlwazeLieu = data[n]['urlwaze'];

        validation = false;
      }
      n++;
    }
    boAfficherLieu = true;
    notifyListeners();
    return " fin de fonction";
  }

  participation(int inIdRencontre, String pseudo, int inNomInviter) async {
    String url = 'http://51.210.103.151/post_participation.php';
    String json =
        '{"id_rencontre":"$inIdRencontre","nombre_joueur":"$inNomInviter","pseudo":"$pseudo"}'; // make POST request
    Response response = await post(url, body: json);
    String body = response.body;
    return body;
  }

  commentaire() async {
    var url = 'http://51.210.103.151/post_commentaire_rencontre.php';
    String json =
        '{"id_rencontre":"$inIdRencontre","date":"0"}'; // make POST request

    if (lisCommentaire.isNotEmpty) {
      print(lisCommentaire[lisCommentaire.length - 1]['date']);
      String date = lisCommentaire[lisCommentaire.length - 1]['date'];
      json = '{"id_rencontre":"$inIdRencontre","date":"$date"}';
    }
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
      lisCommentaire.clear();
      var vaNombreTour = list.length;
      int n = 0;
      while (vaNombreTour > n) {
        // if ((list[n]['stirnIdrencontre'].toString()) == inIdRencontre && (vaNombreTour - n) < mmax) {
        // avant il y avais cette condition mais je comprent pas comment elle fonctionne
        if ((list[n]['id_rencontre'].toString()) == inIdRencontre &&
            (vaNombreTour - n) < mmax) {
          lisCommentaire.add(list[n]);
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

  ajouterCommentaire(String commentaire, String pseudo) async {
    String url = 'http://51.210.103.151/post_commentaire.php';
    String json =
        '{"id_rencontre":"$inIdRencontre","commentaire":"$commentaire","pseudo":"$pseudo"}'; // make POST request
    Response response = await post(url, body: json);
    String body = response.body;
    return body;
  }

  supParticipation(int stirnIdrencontre, String pseudo, int nomInviter) async {
    String url = 'http://51.210.103.151/post_sup_participation.php';

    String json =
        '{"id_rencontre":"$stirnIdrencontre","pseudo":"$pseudo","inviter":"$nomInviter"}'; // make POST request

    Response response = await post(url, body: json);
    String body = response.body;
    return body;
  }

  supCommentaire(
    int id,
  ) async {
    String url = 'http://51.210.103.151/post_sup_commentaire.php';

    String json = '{"id":"$id"}'; // make POST request
    Response response = await post(url, body: json);
    String body = response.body;
    return body;
  }

  initdate(String newdate, String newtime) async {
    date = newdate;
    time = newtime;
    notifyListeners();
    return;
  }
}
