import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'footer.dart';
import 'models/Model_img.dart';
import 'models/Model_terrain.dart';

class LieuDev extends StatefulWidget {
  @override
  _LieuDevState createState() => _LieuDevState();
}

class _LieuDevState extends State<LieuDev> {
  double douTaille;
  supprimer_lieu(String id){
     var url = 'http://51.210.103.151/post_terrain.php';
    String json =
        '{"id":"$id"}'; 
    return " fin de fonction";
  }
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width <
        MediaQuery.of(context).size.height) {
      setState(() {
        douTaille = MediaQuery.of(context).size.width;
      });
    } else {
      setState(() {
        douTaille = MediaQuery.of(context).size.width;
      });
    }
    return Scaffold(
        // backgroundColor: Colors.black54,
         appBar: AppBar(
    title: Text("MeetBall"),
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
        body: ScopedModelDescendant<TerrainModel>(
            builder: (context, child, model) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: model.taille_terrainDev,
              itemBuilder: (context, i) {
                if (model.data_terrainDev[i]['auto'] == "1") {
                  return Center(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                    child: Text(
                                        "afficher",
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display4)),
                                RaisedButton(onPressed: (){}, child: Text("annuler l'affichage")),
                                RaisedButton(onPressed: (){supprimer_lieu(model.data_terrainDev[i]['id']);}, child: Text("suprimer")),
                                ScopedModelDescendant<ImgModel>(
                                    builder: (context, child, img) {
                                  int nombre_tour = 0;
                                  String lien1 = "";
                                  String lien2 = "";
                                  String lien3 = "";
                                  String lien4 = "";
                                  while (img.taille_img > nombre_tour) {
                                    if (model.data_terrainDev[i]['id'] ==
                                        img.data_img[nombre_tour]["id_lieu"]) {
                                      if (lien1 == "") {
                                        lien1 =
                                            img.data_img[nombre_tour]["lien"];
                                      } else if (lien2 == "") {
                                        lien2 =
                                            img.data_img[nombre_tour]["lien"];
                                      } else if (lien3 == "") {
                                        lien3 =
                                            img.data_img[nombre_tour]["lien"];
                                      } else if (lien4 == "") {
                                        lien4 =
                                            img.data_img[nombre_tour]["lien"];
                                      }
                                    }
                                    nombre_tour++;
                                  }
                                  return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Image.network(
                                                '$lien1',
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    (2 / 5)),
                                              ),
                                              new Image.network(
                                                '$lien3',
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    (2 / 5)),
                                              ),
                                            ]),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Image.network(
                                                '$lien2',
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    (2 / 5)),
                                              ),
                                              new Image.network(
                                                '$lien4',
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    (2 / 5)),
                                              ),
                                            ])
                                      ]);
                                }),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("Nom ",
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text("adresse",
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text("ville",
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text("nombre de terrain",
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                          ]),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                                model.data_terrainDev[i]['nom'],
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text(
                                                model.data_terrainDev[i]
                                                    ['adresse'],
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text(
                                                model.data_terrainDev[i]
                                                    ['ville'],
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text(
                                                model.data_terrainDev[i]
                                                    ['nom_t'],
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                          ]),
                                    ])
                              ])));
                } else {
                  return Center(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                 Center(
                        child: Text("pas afficher",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context).textTheme.display4)),

                            RaisedButton(onPressed: (){},child: Text("ajouter")),
                                RaisedButton(onPressed: (){supprimer_lieu(model.data_terrainDev[i]['id']);}, child: Text("suprimer")),
                                ScopedModelDescendant<ImgModel>(
                                    builder: (context, child, img) {
                                  int nombre_tour = 0;
                                  String lien1 = "";
                                  String lien2 = "";
                                  String lien3 = "";
                                  String lien4 = "";
                                  while (img.taille_img > nombre_tour) {
                                    if (model.data_terrainDev[i]['id'] ==
                                        img.data_img[nombre_tour]["id_lieu"]) {
                                      if (lien1 == "") {
                                        lien1 =
                                            img.data_img[nombre_tour]["lien"];
                                      } else if (lien2 == "") {
                                        lien2 =
                                            img.data_img[nombre_tour]["lien"];
                                      } else if (lien3 == "") {
                                        lien3 =
                                            img.data_img[nombre_tour]["lien"];
                                      } else if (lien4 == "") {
                                        lien4 =
                                            img.data_img[nombre_tour]["lien"];
                                      }
                                    }
                                    nombre_tour++;
                                  }
                                  return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Image.network(
                                                '$lien1',
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    (2 / 5)),
                                              ),
                                              new Image.network(
                                                '$lien3',
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    (2 / 5)),
                                              ),
                                            ]),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Image.network(
                                                '$lien2',
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    (2 / 5)),
                                              ),
                                              new Image.network(
                                                '$lien4',
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    (2 / 5)),
                                              ),
                                            ])
                                      ]);
                                }),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("Nom ",
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text("adresse",
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text("ville",
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text("nombre de terrain",
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                          ]),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                                model.data_terrainDev[i]['nom'],
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text(
                                                model.data_terrainDev[i]
                                                    ['adresse'],
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text(
                                                model.data_terrainDev[i]
                                                    ['ville'],
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text(
                                                model.data_terrainDev[i]
                                                    ['nom_t'],
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                          ]),
                                    ])
                              ])));
                }
              });
        }));
  }
}
