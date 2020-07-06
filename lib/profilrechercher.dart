
import 'package:flutter/material.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/Model_img.dart';
import 'models/Model_match.dart';

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
      await ScopedModel.of<LoginModel>(context).ProfilVisiteur();
      profilvisiteur.clear();
      if (terrainre.isEmpty) {
        // quand l'utilisateur viens d'appuyer mais qu'il n'a rien écrit on passe ici et on affiche tous
        profilvisiteur = [];
      } else {
        // on vas regarder mot pare mot si on a des lettre on commun avec la recherche
        for (var i = 0;
            i < ScopedModel.of<LoginModel>(context).profilvisiteur.length;
            i++) {
          int nombre = 0;
          nombre = comparestring(
              terrainre.toUpperCase(),
              ScopedModel.of<LoginModel>(context)
                  .profilvisiteur[i]['pseudo']
                  .toUpperCase());
          if (nombre > 0) {
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
          profilvisiteur.add(contruction[place]['contruiction']);
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
    title: Text("Rechercher un joueur"),
    backgroundColor: Colors.indigo,
  
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          sdialog(context);
        },
      ),
    ],
  ),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Divider(color: Colors.grey),
               TextFormField(
                      autocorrect: true,
                cursorColor: Colors.black,
                style: TextStyle(
                    color: Colors.black, decorationColor: Colors.black),
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
                        return GestureDetector(
                          onTap: () async{
                           await ScopedModel.of<LoginModel>(context).ParticipationProilVisiteur(profilvisiteur[i]['pseudo']);
                                    ScopedModel.of<LoginModel>(context) .profVisiteur = profilvisiteur[i];

                                    Navigator.pushNamed(context, '/ProfilVisiteur');
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 20,
                            child: Center(
                              child: Text(profilvisiteur[i]['pseudo'] +" ("+ profilvisiteur[i]['nom'] +" "+ profilvisiteur[i]['prenom'] + ")"  ,
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.display3),
                            ),
                          ),
                        );
                      })
                  : CircularProgressIndicator(),
            ],
          ),
        ));
  }
}
