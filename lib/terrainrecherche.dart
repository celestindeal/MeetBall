import 'package:flutter/material.dart';
import 'package:meetballl/Ajout_terrain.dart';
import 'package:meetballl/appBar.dart';
import 'package:meetballl/drawer.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/Model_img.dart';

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
      print("fonction init");
      setState(() {
        terrain = ScopedModel.of<TerrainModel>(context).data_terrain;
      });
      init = false;
    }

    comparestring(String mot1, String mot2) {
      print("compare");
      int taille1 = mot1.length;
      int taille2 = mot2.length;
      int compare = 0;
      for (var i = 0; i < taille1; i++) {
        print("tour" + i.toString());
        String lettre1 = mot1[i];
        bool ok = mot2.contains(lettre1);
        if (ok) {
          compare++;
        }
      }
      return compare;
    }

    terrainre(String terrainre) async {
      await ScopedModel.of<TerrainModel>(context).Terrain();
      terrain.clear();
      if (terrainre.isEmpty) {
        terrain = ScopedModel.of<TerrainModel>(context).data_terrain;
      } else {
        for (var i = 0;
            i < ScopedModel.of<TerrainModel>(context).taille_terrain;
            i++) {
          int nombre = 0;
          print("vérification " +
              ScopedModel.of<TerrainModel>(context).data_terrain[i]['nom']);
          nombre = comparestring(terrainre,
              ScopedModel.of<TerrainModel>(context).data_terrain[i]['nom']);
              print("nombre");
              print(nombre);
          if (nombre > 0) {
            terrain.add(ScopedModel.of<TerrainModel>(context).data_terrain[i]);
          }
        }
      }

      setState(() {
        terrain;
      });
      afficher = true;
    }

    return Scaffold(
        appBar: headerNav(context),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        drawer: Darwer(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                cursorColor: Colors.black54,
                style: TextStyle(
                    color: Colors.white, decorationColor: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'terrain',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (value) {
                  setState(() {
                    afficher = false;
                  });
                  terrainre(value);
                },
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
                                  return Center(
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
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
                                                ScopedModelDescendant<ImgModel>(
                                                    builder:
                                                        (context, child, img) {
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
                                                      } else if (lien2 == "") {
                                                        lien2 = img.data_img[
                                                                nombre_tour]
                                                            ["lien"];
                                                      } else if (lien3 == "") {
                                                        lien3 = img.data_img[
                                                                nombre_tour]
                                                            ["lien"];
                                                      } else if (lien4 == "") {
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
                                                      color: Colors.transparent,
                                                      child: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            2,
                                                        child: PageView.builder(
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
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return Container(
                                                                              child: PhotoView(
                                                                            imageProvider:
                                                                                NetworkImage(image),
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
                                                                softWrap: true,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .display2),
                                                            Text(
                                                                terrain[i]
                                                                    ['adresse'],
                                                                softWrap: true,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .display2),
                                                            Text(
                                                                terrain[i]
                                                                    ['ville'],
                                                                softWrap: true,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .display2),
                                                            Text(
                                                                terrain[i][
                                                                        'nom_t'] +
                                                                    " terrain(s) disponible(s)",
                                                                softWrap: true,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .display2),
                                                            Text(
                                                                terrain[i]
                                                                    ['sol'],
                                                                softWrap: true,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .display2),
                                                            Text(
                                                                terrain[i][
                                                                    'ouverture'],
                                                                softWrap: true,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .display2),
                                                          ]),
                                                    ]),
                                                Center(
                                                  child: RaisedButton(
                                                    onPressed: () async {
                                                      String value = terrain[i]
                                                              ['url']
                                                          .toString();
                                                      //const url = const value;
                                                      if (await canLaunch(
                                                          value)) {
                                                        await launch(value);
                                                      }
                                                    },
                                                    child: Text('Y aller'),
                                                  ),
                                                ),
                                              ])));
                                });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 20,
                            child: Center(
                              child: Text(terrain[i]['nom'],
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.display2),
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
