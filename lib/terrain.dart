import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'appBar.dart';
import 'drawer.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_img.dart';
import 'models/Model_terrain.dart';

class Terrain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TerrainModel>(
        builder: (context, child, model) {
      return Container(
          child: model.afficher
              ? Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Presentation_terrain(),
                  ],
                )
              : Scaffold(
                  appBar: headerNav(context),
                  persistentFooterButtons: <Widget>[
                    Footer(),
                  ],
                  drawer: Darwer(),
                  // backgroundColor: Colors.black54,
                  body: Center(
                    child: CircularProgressIndicator(),
                  )));
    });
  }
}

class Presentation_terrain extends StatelessWidget {
  int nombre_tour = 0;
  String lien;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: headerNav(context),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        drawer: Darwer(),
        // backgroundColor: Colors.black54,
        body: ScopedModelDescendant<TerrainModel>(
            builder: (context, child, model) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: model.taille_terrain,
              itemBuilder: (context, i) {
                bool premierT = true;
                if (i > 0) {
                  premierT = false;
                }
                return premierT
                    ? Column(
                        children: <Widget>[
                          Center(
                            child: RaisedButton(
                                child: Text("Ajouter une terrain"),
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/Ajout_terrain',
                                      (Route<dynamic> route) => false);
                                }),
                          ),
                          Center(
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.grey,
                                  ),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ScopedModelDescendant<ImgModel>(
                                            builder: (context, child, img) {
                                          int nombre_tour = 0;
                                          String lien1 = "";
                                          String lien2 = "";
                                          String lien3 = "";
                                          String lien4 = "";
                                          while (img.taille_img > nombre_tour) {
                                            if (model.data_terrain[i]['id'] ==
                                                img.data_img[nombre_tour]
                                                    ["id_lieu"]) {
                                              if (lien1 == "") {
                                                lien1 =
                                                    img.data_img[nombre_tour]
                                                        ["lien"];
                                              } else if (lien2 == "") {
                                                lien2 =
                                                    img.data_img[nombre_tour]
                                                        ["lien"];
                                              } else if (lien3 == "") {
                                                lien3 =
                                                    img.data_img[nombre_tour]
                                                        ["lien"];
                                              } else if (lien4 == "") {
                                                lien4 =
                                                    img.data_img[nombre_tour]
                                                        ["lien"];
                                              }
                                            }
                                            nombre_tour++;
                                          }
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      print("ontap");
                                                      return showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                                    child:
                                                                    PhotoView(
                                                                    imageProvider:
                                                                        NetworkImage(
                                                                          '$lien1'),
                                                                  ));
                                                                
                                                          });
                                                    },
                                                    child:  Container(
                                                      color: Colors.red,
                                                     // child: Image.network(
                                                     //é   '$lien1', width: (MediaQuery.of(    context).size .width * (4 / 5)),
                                                 //     ),
                                                    ),
                                                  ),
                                                  new Image.network(
                                                    '$lien2',
                                                    width:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (4 / 5)),
                                                  ),
                                                  new Image.network(
                                                    '$lien3',
                                                    width:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (4 / 5)),
                                                  ),
                                                  new Image.network(
                                                    '$lien4',
                                                    width:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (4 / 5)),
                                                  ),
                                                ]),
                                          );
                                        }),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                        model.data_terrain[i]
                                                            ['nom'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text(
                                                        model.data_terrain[i]
                                                            ['adresse'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text(
                                                        model.data_terrain[i]
                                                            ['ville'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text(
                                                        model.data_terrain[i]
                                                                ['nom_t'] +
                                                            " terrain(s) disponible(s)",
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text(
                                                        model.data_terrain[i]
                                                            ['sol'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text(
                                                        model.data_terrain[i]
                                                            ['ouverture'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                  ]),
                                            ]),
                                        Center(
                                          child: RaisedButton(
                                            onPressed: () async {
                                              String value = model
                                                  .data_terrain[i]['url']
                                                  .toString();
                                              //const url = const value;
                                              if (await canLaunch(value)) {
                                                await launch(value);
                                              } else {
                                                print(value);
                                              }
                                            },
                                            child: Text('Y aller'),
                                          ),
                                        ),
                                      ])))
                        ],
                      )
                    : Center(
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
                                  ScopedModelDescendant<ImgModel>(
                                      builder: (context, child, img) {
                                    int nombre_tour = 0;
                                    String lien1 = "";
                                    String lien2 = "";
                                    String lien3 = "";
                                    String lien4 = "";
                                    while (img.taille_img > nombre_tour) {
                                      if (model.data_terrain[i]['id'] ==
                                          img.data_img[nombre_tour]
                                              ["id_lieu"]) {
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
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Image.network(
                                              '$lien1',
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (4 / 5)),
                                            ),
                                            new Image.network(
                                              '$lien3',
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (4 / 5)),
                                            ),
                                            new Image.network(
                                              '$lien2',
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (4 / 5)),
                                            ),
                                            new Image.network(
                                              '$lien4',
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (4 / 5)),
                                            ),
                                          ]),
                                    );
                                  }),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(model.data_terrain[i]['nom'],
                                                  softWrap: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display2),
                                              Text(
                                                  model.data_terrain[i]
                                                      ['adresse'],
                                                  softWrap: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display2),
                                              Text(
                                                  model.data_terrain[i]
                                                      ['ville'],
                                                  softWrap: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display2),
                                              Text(
                                                  model.data_terrain[i]
                                                          ['nom_t'] +
                                                      " terrain(s) disponible(s)",
                                                  softWrap: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display2),
                                              Text(model.data_terrain[i]['sol'],
                                                  softWrap: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display2),
                                              Text(
                                                  model.data_terrain[i]
                                                      ['ouverture'],
                                                  softWrap: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display2),
                                            ]),
                                      ]),
                                  Center(
                                    child: RaisedButton(
                                      onPressed: () async {
                                        String value = model.data_terrain[i]
                                                ['url']
                                            .toString();
                                        //const url = const value;
                                        if (await canLaunch(value)) {
                                          await launch(value);
                                        } else {
                                          print(value);
                                        }
                                      },
                                      child: Text('Y aller'),
                                    ),
                                  ),
                                ])));
              });
        }));
  }
}
