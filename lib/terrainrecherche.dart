import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:meetballl/Ajout_terrain.dart';
import 'package:meetballl/db.dart';
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
  @override
  List terrain = [];
  bool init = true;
  bool afficher = true;
  Widget build(BuildContext context) {
    if (init) {
      setState(() {
        terrain;
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
      await ScopedModel.of<TerrainModel>(context).Terrain();
      terrain.clear();
      if (terrainre.isEmpty) {
        // quand l'utilisateur viens d'appuyer mais qu'il n'a rien écrit on passe ici et on affiche tous
        terrain = [];
      } else {
        // on vas regarder mot pare mot si on a des lettre on commun avec la recherche
        for (var i = 0;
            i < ScopedModel.of<TerrainModel>(context).taille_terrain;
            i++) {
          int nombre = 0;
          nombre = comparestring(
              terrainre.toUpperCase(),
              ScopedModel.of<TerrainModel>(context)
                  .data_terrain[i]['ville']
                  .toUpperCase());
          if (nombre > 0) {
            // ici le lieu doit être affiche il vas dans construction
            Map tkt = {
              'contruiction':
                  ScopedModel.of<TerrainModel>(context).data_terrain[i],
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
          terrain.add(contruction[place]['contruiction']);
          contruction.removeAt(place);
        }
      }
      setState(() {
        terrain;
      });
      afficher = true;
    }

    return Scaffold(
        appBar: AppBar(
    title: Text("Rechercher un playground"),
    backgroundColor: Colors.indigo,
    leading: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/Ajout_match', (Route<dynamic> route) => false);
        }),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                changeBrightness() {
                  DynamicTheme.of(context).setBrightness(
                      Theme.of(context).brightness == Brightness.dark
                          ? Brightness.light
                          : Brightness.dark);
                  if (couleur) {
                    couleur = false;
                  } else {
                    couleur = true;
                  }
                  Baselocal().mise_a_jour();
                }

                return Center(
                  child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey,
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Mode d'affichage:",
                                      softWrap: true,
                                      style:
                                          Theme.of(context).textTheme.display2),
                                  RaisedButton(
                                      child: couleur
                                          ? Text("dark")
                                          : Text("normale"),
                                      onPressed: () async {
                                        changeBrightness();
                                      }),
                                ],
                              ),
                              RaisedButton(
                                  child: Text(
                                      "CONDITIONS GÉNÉRALES D’UTILISATION"),
                                  onPressed: () async {
                                    if (await canLaunch(
                                        "http://51.210.103.151/conditions.php")) {
                                      await launch(
                                          "http://51.210.103.151/conditions.php");
                                    }
                                  }),
                              RaisedButton(
                                  child: Text("POLITIQUE DE CONFIDENTIALITÉ"),
                                  onPressed: () async {
                                    if (await canLaunch(
                                        "http://51.210.103.151/confidentialite.php")) {
                                      await launch(
                                          "http://51.210.103.151/confidentialite.php");
                                    }
                                  }),
                              RaisedButton(
                                  child: Text("FAQ"),
                                  onPressed: () async {
                                    if (await canLaunch(
                                        "http://51.210.103.151/FAQ.php")) {
                                      await launch(
                                          "http://51.210.103.151/FAQ.php");
                                    }
                                  }),
                              RaisedButton(
                                onPressed: () async {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      '/Avis', (Route<dynamic> route) => false);
                                },
                                child: Text('Nous contacter',
                                    style:
                                        Theme.of(context).textTheme.display3),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                color: Colors.indigo),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                    'Es-tu sûr de vraiment vouloir te déconnecter ?',
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .display1),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    RaisedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('non')),
                                                    RaisedButton(
                                                        onPressed: () async {
                                                          await ScopedModel.of<
                                                                      LoginModel>(
                                                                  context)
                                                              .Deconnection();
                                                          await Baselocal()
                                                              .deconnect();
                                                          Navigator
                                                              .pushNamedAndRemoveUntil(
                                                                  context,
                                                                  '/',
                                                                  (Route<dynamic>
                                                                          route) =>
                                                                      false);
                                                        },
                                                        child: Text('oui')),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Text('Déconnexion',
                                    style:
                                        Theme.of(context).textTheme.display3),
                              ),
                              ScopedModel.of<LoginModel>(context).devellopeur
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/avisDev',
                                                (Route<dynamic> route) =>
                                                    false);
                                          },
                                          child: Container(
                                            height: (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10),
                                            child: Center(
                                              child: Text('avisDev',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display3),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            ScopedModel.of<ImgModel>(context)
                                                .Img();
                                            ScopedModel.of<TerrainModel>(
                                                    context)
                                                .TerrainDev();
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/lieuDev',
                                                (Route<dynamic> route) =>
                                                    false);
                                          },
                                          child: Container(
                                            height: (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10),
                                            child: Center(
                                              child: Text('lieuDev',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      )),
                );
              });
            },
          );
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
                cursorColor: Colors.black54,
                style: TextStyle(
                    color: Colors.black54, decorationColor: Colors.black54),
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
                      itemCount: terrain.length,
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
                                                    int nombre_tour = 0;
                                                    String lien1 = "";
                                                    String lien2 = "";
                                                    String lien3 = "";
                                                    String lien4 = "";
                                                    while (img.taille_img >
                                                        nombre_tour) {
                                                      if (terrain[i]['id'] ==
                                                          img.data_img[
                                                                  nombre_tour]
                                                              ["id_lieu"]) {
                                                        if (lien1 == "") {
                                                          lien1 = img.data_img[
                                                                  nombre_tour]
                                                              ["lien"];
                                                        } else if (lien2 ==
                                                            "") {
                                                          lien2 = img.data_img[
                                                                  nombre_tour]
                                                              ["lien"];
                                                        } else if (lien3 ==
                                                            "") {
                                                          lien3 = img.data_img[
                                                                  nombre_tour]
                                                              ["lien"];
                                                        } else if (lien4 ==
                                                            "") {
                                                          lien4 = img.data_img[
                                                                  nombre_tour]
                                                              ["lien"];
                                                        }
                                                      }
                                                      nombre_tour++;
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
                                                              2,
                                                          child:
                                                              PageView.builder(
                                                            controller:
                                                                PageController(
                                                                    viewportFraction:
                                                                        0.8),
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
                                                                Container();
                                                              } else {
                                                                return GestureDetector(
                                                                    onTap: () {
                                                                      return showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return Container(
                                                                                child: PhotoView(
                                                                              imageProvider: NetworkImage(image),
                                                                            ));
                                                                          });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      color: Colors
                                                                          .transparent,
                                                                      child: Image
                                                                          .network(
                                                                        image,
                                                                      ),
                                                                    ));
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
                                                                  terrain[i]
                                                                      ['nom'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                              Text(
                                                                  terrain[i][
                                                                      'adresse'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                              Text(
                                                                  terrain[i]
                                                                      ['ville'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                              Text(
                                                                  terrain[i][
                                                                          'nom_t'] +
                                                                      " terrain(s) disponible(s)",
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                              Text(
                                                                  terrain[i]
                                                                      ['sol'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                              Text(
                                                                  terrain[i][
                                                                      'ouverture'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
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
                                                                            terrain[i]['url'].toString();
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
                                                                            terrain[i]['urlwaze'].toString();
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
                                                            terrain[i]['nom']
                                                                .toString();
                                                        Navigator.pushNamedAndRemoveUntil(
                                                            context,
                                                            '/TerrainRencontre',
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
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
                              child: Text(terrain[i]['nom'] + " (" +terrain[i]['ville'] + ')'  ,
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
