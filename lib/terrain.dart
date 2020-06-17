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
        body: SingleChildScrollView(
          child: ScopedModelDescendant<TerrainModel>(
              builder: (context, child, model) {
            return Column(
              children: <Widget>[
                Center(
                  child: RaisedButton(
                      child: Text("Ajouter une terrain"),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            '/Ajout_terrain', (Route<dynamic> route) => false);
                      }),
                ),
                Center(
                  child: RaisedButton(
                      child: Text("terrain le plus proche"),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            '/Terrainpro', (Route<dynamic> route) => false);
                      }),
                ),
                Center(
                  child: RaisedButton(
                      child: Text("recherhcer"),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            '/Terrainrecherche', (Route<dynamic> route) => false);
                      }),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: model.taille_terrain,
                    itemBuilder: (context, i) {
                     
                      return Center(
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
                                          if (lien1 == "") {
                                            return Container();
                                          } else {
                                            return Container(
                                              color: Colors.transparent,
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2,
                                                child: PageView.builder(
                                                  controller: PageController(
                                                      viewportFraction: 0.8),
                                                  itemCount: 4,
                                                  itemBuilder:
                                                      (BuildContext context,
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
                                                                      child:
                                                                          PhotoView(
                                                                    imageProvider:
                                                                        NetworkImage(
                                                                            image),
                                                                  ));
                                                                });
                                                          },
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            color: Colors
                                                                .transparent,
                                                            child:
                                                                Image.network(
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
                                              } 
                                            },
                                            child: Text('Y aller'),
                                          ),
                                        ),
                                      ])));
                    }),
              ],
            );
          }),
        ));
  }
}
