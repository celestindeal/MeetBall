import 'dart:math';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:meetballl/models/Model_match.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

double ditanceCourt = 1000000;
String tkt = "location";
List lieupro = [];
bool chnagecouleur = false;

class TerrainPro extends StatefulWidget {
  @override
  _TerrainProState createState() => _TerrainProState();
}

double lat2 = 0;
double lon2 = 0;
double lon1;
double lat1;

class _TerrainProState extends State<TerrainPro> {
  @override
  Widget build(BuildContext context) {
    terrain() async {
      List contruction = [];
      var location = new Location();
      var currentLocation = await location.getLocation();
      lat1 = currentLocation.latitude;
      lon1 = currentLocation.longitude;

      for (var i = 0;
          i < ScopedModel.of<TerrainModel>(context).taille_terrain;
          i++) {
        String lieu = "";
        lieu = ScopedModel.of<TerrainModel>(context)
            .data_terrain[i]['url']
            .toString();
        if (await canLaunch(lieu)) {
          String valueString =
              "/" + lieu.toString().split('@')[1].split('/')[0];
          int nombrecar = valueString.length;
          String valuelieu = valueString.substring(0, nombrecar - 1);
          lat2 = double.parse(valuelieu.toString().split('/')[1].split(',')[0]);
          lon2 = double.parse(valuelieu.toString().split(',')[1]);
          //double x = (lon2 - lon1) * cos(0.5 * (lat2 + lat1));
          //double y = lat2 - lat1;
          // double distance = 1.852 * 60 * sqrt((x * x + y * y));
          double distance = 6371 *
              acos((sin(lat1 * (pi / 180)) * sin(lat2 * (pi / 180))) +
                  (cos(lat1 * (pi / 180)) *
                      cos(lat2 * (pi / 180)) *
                      cos(lon1 * (pi / 180) - lon2 * (pi / 180))));

          Map tkt = {
            'contruiction':
                ScopedModel.of<TerrainModel>(context).data_terrain[i],
            "distance": distance
          };
          contruction.add(tkt);
        }
      }
      int copie = contruction.length;
// objatif classer les lieu dans l'ordre
      for (var i = 0; i < copie; i++) {
        double nombreplus = 10000;
        int place;
        for (var n = 0; n < contruction.length; n++) {
          if (contruction[n]['distance'] <= nombreplus) {
            nombreplus = contruction[n]['distance'];
            place = n;
          }
        }
        lieupro.add(contruction[place]);
        contruction.removeAt(place);
      }
      return lieupro;
    }

    return Scaffold(
        appBar: AppBar(
    title: Text("Playground à coté"),
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
        backgroundColor: back,
        body:  FutureBuilder<dynamic>(
          future: terrain(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return AffImage();
            } else {
              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
              );
            }
          },
        ));
  }
}

class AffImage extends StatefulWidget {
  @override
  _AffImageState createState() => _AffImageState();
}

class _AffImageState extends State<AffImage> {
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, i) {
          if (chnagecouleur) {
            chnagecouleur = false;
          } else {
            chnagecouleur = true;
          }
          return Center(
              child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: chnagecouleur ? Colors.indigo : Colors.amber[900],
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            " Vous êtes à " +
                                lieupro[i]['distance']
                                    .toStringAsFixed(3)
                                    .toString() +
                                "Km",
                            softWrap: true,
                            style: Theme.of(context).textTheme.display2),
                        ScopedModelDescendant<ImgModel>(
                            builder: (context, child, img) {
                          int nombre_tour = 0;
                          String lien1 = "";
                          String lien2 = "";
                          String lien3 = "";
                          String lien4 = "";
                          while (img.taille_img > nombre_tour) {
                            if (lieupro[i]['contruiction']['id'] ==
                                img.data_img[nombre_tour]["id_lieu"]) {
                              if (lien1 == "") {
                                lien1 = img.data_img[nombre_tour]["lien"];
                              } else if (lien2 == "") {
                                lien2 = img.data_img[nombre_tour]["lien"];
                              } else if (lien3 == "") {
                                lien3 = img.data_img[nombre_tour]["lien"];
                              } else if (lien4 == "") {
                                lien4 = img.data_img[nombre_tour]["lien"];
                              }
                            }
                            nombre_tour++;
                          }
                          if (lien1 == "") {
                            return Container();
                          } else {
                            return Container(
                              color: Colors.transparent,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 1.5,
                                child: PageView.builder(
                                  controller:
                                      PageController(viewportFraction: 1),
                                  itemCount: 4,
                                  itemBuilder:
                                      (BuildContext context, int itemIndex) {
                                    String image = "";
                                    switch (itemIndex) {
                                      case 0:
                                        {
                                          image = lien1;
                                        }
                                        break;
                                      case 1:
                                        {
                                          image = lien2;
                                        }
                                        break;
                                      case 2:
                                        {
                                          image = lien3;
                                        }
                                        break;
                                      case 3:
                                        {
                                          image = lien4;
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
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                      child: PhotoView(
                                                    imageProvider:
                                                        NetworkImage(image),
                                                  ));
                                                });
                                          },
                                          child:  Image.network(
                                              image, width: MediaQuery.of(context)
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(lieupro[i]['contruiction']['nom'],
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                    Text(lieupro[i]['contruiction']['adresse'],
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                    Text(lieupro[i]['contruiction']['ville'],
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                    Text(
                                        lieupro[i]['contruiction']['nom_t'] +
                                            " terrain(s) disponible(s)",
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                    Text(lieupro[i]['contruiction']['sol'],
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                    Text(
                                        lieupro[i]['contruiction']['ouverture'],
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                            Text(
                                        lieupro[i]['contruiction']['commentaire'],
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                  ]),
                            ]),
                        Center(
                          child: RaisedButton(
                            onPressed: () async {
                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text('Ouvrir avec'),
                                        content: SingleChildScrollView(
                                            child: ListBody(children: <Widget>[
                                          GestureDetector(
                                            child: Text("Google map"),
                                            onTap: () async {
                                              String value = lieupro[i]
                                                      ['contruiction']['url']
                                                  .toString();
                                              //const url = const value;
                                              if (await canLaunch(value)) {
                                                await launch(value);
                                              }
                                            },
                                          ),
                                          Padding(padding: EdgeInsets.all(8.0)),
                                          GestureDetector(
                                            child: Text("Waze"),
                                            onTap: () async {

                                              String value = lieupro[i]
                                                          ['contruiction']
                                                      ['urlwaze']
                                                  .toString();
                                              //const url = const value;
                                              if (await canLaunch(value)) {
                                                await launch(value);
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
                              ScopedModel.of<GameModel>(context)
                                      .terrainrencontre =
                                  lieupro[i]['contruiction']['nom'];
                                  Navigator.pushNamed(context, '/TerrainRencontre');
                                  
                            },
                            child: Text('Rencontre à venir'),
                          ),
                        ),
                      ])));
        });
  }
}
