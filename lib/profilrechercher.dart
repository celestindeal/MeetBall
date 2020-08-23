import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:scoped_model/scoped_model.dart';

List lieupro = [];

class ProfilRecherche extends StatefulWidget {
  @override
  _ProfilRechercheState createState() => _ProfilRechercheState();
}

double lat2 = 0;
double lon2 = 0;
double lon1;
double lat1;
double ditanceCourt = 1000000;

class _ProfilRechercheState extends State<ProfilRecherche> {
  @override
  List profilvisiteur = [];
  bool init = true;
  bool afficher = true;
  Widget build(BuildContext context) {
    if (init) {
      setState(() {
        profilvisiteur;
      });
      init = false;
    }

    comparestring(String mot1, String mot2) {
      // on compparre deux mots si il ont des lettre en commun on renvoie un nombre sinon on renvoie 0
      int taille1 = mot1.length;
      int taille2 = mot2.length;
      int compare = 0;
      for (var i = 0; i < taille1; i++) {
        String lettre1 = mot1[i];
        bool ok = mot2.contains(lettre1);
        if (ok) {
          compare++;
        }
      }
      return compare;
    }

    terrainre(String terrainre) async {
      List contruction = [];
      if (ScopedModel.of<LoginModel>(context).profilvisiteur.isEmpty) {
        await ScopedModel.of<LoginModel>(context).ProfilVisiteur();
      }

      profilvisiteur.clear();
      if (terrainre.isEmpty) {
        // quand l'utilisateur viens d'appuyer mais qu'il n'a rien écrit on passe ici et on affiche tous
        profilvisiteur = [];
      } else {
        // on vas regarder mot pare mot si on a des lettre on commun avec la recherche
        int plusG = 0;
        for (var i = 0;
            i < ScopedModel.of<LoginModel>(context).profilvisiteur.length;
            i++) {
          int nombre = 0;
          nombre = comparestring(
              terrainre.toUpperCase(),
              ScopedModel.of<LoginModel>(context)
                  .profilvisiteur[i]['pseudo']
                  .toUpperCase());
          if (nombre > 0 && nombre > (plusG - 1)) {
            plusG = nombre;

            // ici le lieu doit être affiche il vas dans construction
            Map tkt = {
              'contruiction':
                  ScopedModel.of<LoginModel>(context).profilvisiteur[i],
              "nombre": nombre
            };
            contruction.add(tkt);
          }
        }

        int copie = contruction.length;
        profilvisiteur.clear();
        // objatif classer les lieu dans l'ordre
        for (var i = 0; i < copie; i++) {
          int nombreplus = 0;
          int place;
          for (var n = 0; n < contruction.length; n++) {
            if (contruction[n]['nombre'] >= nombreplus) {
              nombreplus = contruction[n]['nombre'];
              place = n;
            }
          }
          if (nombreplus >= (plusG - 1)) {
            profilvisiteur.add(contruction[place]['contruiction']);
          }
          contruction.removeAt(place);
        }
      }
      setState(() {
        profilvisiteur;
      });
      afficher = true;
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Rechercher un joueur"),
          backgroundColor: Colors.indigo,
        ),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        backgroundColor: back,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Divider(color: Colors.grey),
              TextFormField(
                autocorrect: true,
                cursorColor: Colors.black,
                style: Theme.of(context).textTheme.display3,
                decoration: const InputDecoration(
                  hintText: 'Trouver un joueur',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (value) {
                  setState(() {
                    afficher = false;
                  });
                  terrainre(value);
                },
              ),
              Container(
                height: 30,
              ),
              afficher
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: profilvisiteur.length,
                      itemBuilder: (context, i) {
                        if (profilvisiteur[i]['pseudo'] ==
                            ScopedModel.of<LoginModel>(context).pseudo) {
                          return Container();
                        } else {
                          return GestureDetector(
                            onTap: () async {
                              await ScopedModel.of<LoginModel>(context)
                                  .ParticipationProilVisiteur(
                                      profilvisiteur[i]['pseudo']);
                              // on vas rechercher le profil de la personne selectionner
                              String pseudo = profilvisiteur[i]['pseudo'];
                              String url =
                                  'http://51.210.103.151/post_connexion_pseudo.php'; // vérification pseudo
                              String json = '{"pseudo":"$pseudo"}';
                              Response response = await post(url, body: json);
                              List listpersonne = jsonDecode(response.body);

                              ScopedModel.of<LoginModel>(context).profVisiteur =
                                  listpersonne[0];

                              Navigator.pushNamed(context, '/ProfilVisiteur');
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 20,
                              child: Center(
                                child: Text(
                                    profilvisiteur[i]['pseudo'] +
                                        " (" +
                                        profilvisiteur[i]['nom'] +
                                        " " +
                                        profilvisiteur[i]['prenom'] +
                                        ")",
                                    softWrap: true,
                                    style:
                                        Theme.of(context).textTheme.display3),
                              ),
                            ),
                          );
                        }
                      })
                  : CircularProgressIndicator(),
            ],
          ),
        ));
  }
}
