import 'package:flutter/material.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Model_img.dart';
import '../models/Model_match.dart';

List lieupro = [];

class TerrainRecherche extends StatefulWidget {
  @override
  _TerrainRechercheState createState() => _TerrainRechercheState();
}

double lat2 = 0;
double lon2 = 0;
double lon1;
double lat1;
double ditanceCourt = 1000000;

class _TerrainRechercheState extends State<TerrainRecherche> {
  List lisTerrain = [];
  bool init = true;
  bool afficher = true;
  Widget build(BuildContext context) {
    if (init) {
      setState(() {
        // ignore: unnecessary_statements
        lisTerrain;
      });
      init = false;
    }

    terrainre(String terrainre) async {
      List contruction = [];
      if (ScopedModel.of<TerrainModel>(context).vaDataTerrain.isEmpty) {
        await ScopedModel.of<TerrainModel>(context).terrain();
      }

      lisTerrain.clear();
      if (terrainre.isEmpty) {
        // quand l'utilisateur viens d'appuyer mais qu'il n'a rien écrit on passe ici et on affiche tous
        lisTerrain = [];
      } else {
        // on vas regarder mot pare mot si on a des lettre on commun avec la recherche
        int plusG = 0;
        for (var i = 0;
            i < ScopedModel.of<TerrainModel>(context).tailleTerrain;
            i++) {
          int nombre = 0;
          nombre = comparestring(
              terrainre.toUpperCase(),
              ScopedModel.of<TerrainModel>(context)
                  .vaDataTerrain[i]['ville']
                  .toUpperCase());
          if (nombre > 0 && nombre > (plusG - 2)) {
            plusG = nombre;
            // ici le lieu doit être affiche il vas dans construction
            Map tkt = {
              'contruiction':
                  ScopedModel.of<TerrainModel>(context).vaDataTerrain[i],
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
          if (nombreplus >= (plusG - 1)) {
            lisTerrain.add(contruction[place]['contruiction']);
          }
          contruction.removeAt(place);
        }
      }
      setState(() {
        // ignore: unnecessary_statements
        lisTerrain;
      });
      afficher = true;
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Rechercher un playground"),
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
                style: Theme.of(context).textTheme.headline3,
                decoration: const InputDecoration(
                  hintText: 'Trouver un playground',
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
                      itemCount: lisTerrain.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Center(
                                        child: Container(
                                            padding: const EdgeInsets.all(20),
                                            margin: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: Colors.grey,
                                            ),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  ScopedModelDescendant<
                                                          ImgModel>(
                                                      builder: (context, child,
                                                          img) {
                                                    int inNombreTour = 0;
                                                    String lien1 = "";
                                                    String lien2 = "";
                                                    String lien3 = "";
                                                    String lien4 = "";
                                                    while (img.inTailleImg >
                                                        inNombreTour) {
                                                      if (lisTerrain[i]['id'] ==
                                                          img.vaDataImg[
                                                                  inNombreTour]
                                                              ["id_lieu"]) {
                                                        if (lien1 == "") {
                                                          lien1 = img.vaDataImg[
                                                                  inNombreTour]
                                                              ["lien"];
                                                        } else if (lien2 ==
                                                            "") {
                                                          lien2 = img.vaDataImg[
                                                                  inNombreTour]
                                                              ["lien"];
                                                        } else if (lien3 ==
                                                            "") {
                                                          lien3 = img.vaDataImg[
                                                                  inNombreTour]
                                                              ["lien"];
                                                        } else if (lien4 ==
                                                            "") {
                                                          lien4 = img.vaDataImg[
                                                                  inNombreTour]
                                                              ["lien"];
                                                        }
                                                      }
                                                      inNombreTour++;
                                                    }
                                                    if (lien1 == "") {
                                                      return Container();
                                                    } else {
                                                      return Container(
                                                        color:
                                                            Colors.transparent,
                                                        child: SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              1.5,
                                                          child:
                                                              PageView.builder(
                                                            controller:
                                                                PageController(
                                                                    viewportFraction:
                                                                        1),
                                                            itemCount: 4,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int itemIndex) {
                                                              String image = "";
                                                              switch (
                                                                  itemIndex) {
                                                                case 0:
                                                                  {
                                                                    image =
                                                                        lien1;
                                                                  }
                                                                  break;
                                                                case 1:
                                                                  {
                                                                    image =
                                                                        lien2;
                                                                  }
                                                                  break;
                                                                case 2:
                                                                  {
                                                                    image =
                                                                        lien3;
                                                                  }
                                                                  break;
                                                                case 3:
                                                                  {
                                                                    image =
                                                                        lien4;
                                                                  }
                                                                  break;
                                                                default:
                                                              }
                                                              if (image == "") {
                                                                return Container();
                                                              } else {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    return showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return Container(
                                                                              child: GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: PhotoView(
                                                                                    imageProvider: NetworkImage(image),
                                                                                  )));
                                                                        });
                                                                  },
                                                                  child: Image
                                                                      .network(
                                                                    image,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                  lisTerrain[i]
                                                                      ['nom'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  lisTerrain[i][
                                                                      'adresse'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  lisTerrain[i]
                                                                      ['ville'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  lisTerrain[i][
                                                                          'nom_t'] +
                                                                      " terrain(s) disponible(s)",
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  lisTerrain[i]
                                                                      ['sol'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  lisTerrain[i][
                                                                      'ouverture'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  lisTerrain[i][
                                                                      'commentaire'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                            ]),
                                                      ]),
                                                  Center(
                                                    child: RaisedButton(
                                                      onPressed: () async {
                                                        return showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                  title: Text(
                                                                      'Ouvrir avec'),
                                                                  content:
                                                                      SingleChildScrollView(
                                                                          child:
                                                                              ListBody(children: <Widget>[
                                                                    GestureDetector(
                                                                      child: Text(
                                                                          "Google map"),
                                                                      onTap:
                                                                          () async {
                                                                        String
                                                                            value =
                                                                            lisTerrain[i]['url'].toString();
                                                                        //const url = const value;
                                                                        if (await canLaunch(
                                                                            value)) {
                                                                          await launch(
                                                                              value);
                                                                        }
                                                                      },
                                                                    ),
                                                                    Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8.0)),
                                                                    GestureDetector(
                                                                      child: Text(
                                                                          "Waze"),
                                                                      onTap:
                                                                          () async {
                                                                        String
                                                                            value =
                                                                            lisTerrain[i]['urlwaze'].toString();
                                                                        //const url = const value;
                                                                        if (await canLaunch(
                                                                            value)) {
                                                                          await launch(
                                                                              value);
                                                                        }
                                                                      },
                                                                    )
                                                                  ])));
                                                            });
                                                      },
                                                      child: Text('Y aller'),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: RaisedButton(
                                                      onPressed: () async {
                                                        ScopedModel.of<GameModel>(
                                                                    context)
                                                                .terrainrencontre =
                                                            lisTerrain[i]['nom']
                                                                .toString();
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/TerrainRencontre');
                                                      },
                                                      child: Text(
                                                          'Rencontre à venir'),
                                                    ),
                                                  ),
                                                ]))),
                                  );
                                });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 20,
                            child: Center(
                              child: Text(
                                  lisTerrain[i]['nom'] +
                                      " (" +
                                      lisTerrain[i]['ville'] +
                                      ')',
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.headline3),
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
