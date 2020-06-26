import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'footer.dart';
import 'models/Model_terrain.dart';

class Terrain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TerrainModel>(
        builder: (context, child, model) {
      return Container(
          child: 
               Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Presentation_terrain(),
                  ],
                )
           );
    });
  }
}

class Presentation_terrain extends StatelessWidget {
  int nombre_tour = 0;
  String lien;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
    title:  Center( child : Text("Playground"),),
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
                                            color:Colors.white,
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                      Navigator.pushNamed(
                                      context, '/Terrainrecherche');
                },
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: new BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.indigo[900],
                        Colors.indigoAccent[700],
                        Colors.indigoAccent[400],
                        Colors.indigo,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search,
                    size: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                      Navigator.pushNamed(
                                      context, '/Terrainpro');
                },
                child: Container(
                 padding: const EdgeInsets.all(20.0),
                  decoration: new BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.indigo,
                        Colors.indigo[300],
                        Colors.indigo[100],
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ImageIcon(
     AssetImage('img/location.png',),
     size: MediaQuery.of(context).size.width * 0.4,
),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                                      context, '/Ajout_terrain');
                },
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: new BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                       Colors.indigo[900],
                        Colors.indigoAccent[700],
                        Colors.indigoAccent[400],
                        Colors.indigo,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: 
            ImageIcon(
     AssetImage('img/ajouterterrain.png',),
     size: MediaQuery.of(context).size.width * 0.4,

),
                  
                ),
              ),
            ],
          ),
        ));
  }
}
// ListView.builder(
//   physics: NeverScrollableScrollPhysics(),
//     shrinkWrap: true,
//     itemCount: model.taille_terrain,
//     itemBuilder: (context, i) {

//       return Center(
//               child: Container(
//                   padding: const EdgeInsets.all(5),
//                   margin: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20.0),
//                     color: Colors.grey,
//                   ),
//                   child: Column(
//                       mainAxisAlignment:
//                           MainAxisAlignment.center,
//                       children: <Widget>[
//                         ScopedModelDescendant<ImgModel>(
//                             builder: (context, child, img) {
//                           int nombre_tour = 0;
//                           String lien1 = "";
//                           String lien2 = "";
//                           String lien3 = "";
//                           String lien4 = "";
//                           while (img.taille_img > nombre_tour) {
//                             if (model.data_terrain[i]['id'] ==
//                                 img.data_img[nombre_tour]
//                                     ["id_lieu"]) {
//                               if (lien1 == "") {
//                                 lien1 =
//                                     img.data_img[nombre_tour]
//                                         ["lien"];
//                               } else if (lien2 == "") {
//                                 lien2 =
//                                     img.data_img[nombre_tour]
//                                         ["lien"];
//                               } else if (lien3 == "") {
//                                 lien3 =
//                                     img.data_img[nombre_tour]
//                                         ["lien"];
//                               } else if (lien4 == "") {
//                                 lien4 =
//                                     img.data_img[nombre_tour]
//                                         ["lien"];
//                               }
//                             }
//                             nombre_tour++;
//                           }
//                           if (lien1 == "") {
//                             return Container();
//                           } else {
//                             return Container(
//                               color: Colors.transparent,
//                               child: SizedBox(
//                                 height: MediaQuery.of(context)
//                                         .size
//                                         .height /
//                                     2,
//                                 child: PageView.builder(
//                                   controller: PageController(
//                                       viewportFraction: 0.8),
//                                   itemCount: 4,
//                                   itemBuilder:
//                                       (BuildContext context,
//                                           int itemIndex) {
//                                     String image = "";
//                                     switch (itemIndex) {
//                                       case 0:
//                                         {
//                                           image = lien1;
//                                         }
//                                         break;
//                                       case 1:
//                                         {
//                                           image = lien2;
//                                         }
//                                         break;
//                                       case 2:
//                                         {
//                                           image = lien3;
//                                         }
//                                         break;
//                                       case 3:
//                                         {
//                                           image = lien4;
//                                         }
//                                         break;
//                                       default:
//                                     }
//                                     if (image == "") {
//                                       Container();
//                                     } else {
//                                       return GestureDetector(
//                                           onTap: () {
//                                             return showDialog(
//                                                 context:
//                                                     context,
//                                                 builder:
//                                                     (BuildContext
//                                                         context) {
//                                                   return Container(
//                                                       child:
//                                                           PhotoView(
//                                                     imageProvider:
//                                                         NetworkImage(
//                                                             image),
//                                                   ));
//                                                 });
//                                           },
//                                           child: Container(
//                                             width:
//                                                 MediaQuery.of(
//                                                         context)
//                                                     .size
//                                                     .width,
//                                             color: Colors
//                                                 .transparent,
//                                             child:
//                                                 Image.network(
//                                               image,
//                                             ),
//                                           ));
//                                     }
//                                   },
//                                 ),
//                               ),
//                             );
//                           }
//                         }),
//                         Row(
//                             mainAxisAlignment:
//                                 MainAxisAlignment.spaceEvenly,
//                             children: <Widget>[
//                               Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Text(
//                                         model.data_terrain[i]
//                                             ['nom'],
//                                         softWrap: true,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .display2),
//                                     Text(
//                                         model.data_terrain[i]
//                                             ['adresse'],
//                                         softWrap: true,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .display2),
//                                     Text(
//                                         model.data_terrain[i]
//                                             ['ville'],
//                                         softWrap: true,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .display2),
//                                     Text(
//                                         model.data_terrain[i]
//                                                 ['nom_t'] +
//                                             " terrain(s) disponible(s)",
//                                         softWrap: true,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .display2),
//                                     Text(
//                                         model.data_terrain[i]
//                                             ['sol'],
//                                         softWrap: true,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .display2),
//                                     Text(
//                                         model.data_terrain[i]
//                                             ['ouverture'],
//                                         softWrap: true,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .display2),
//                                   ]),
//                             ]),
//                         Center(
//                           child: RaisedButton(
//                             onPressed: () async {
//                               String value = model
//                                   .data_terrain[i]['url']
//                                   .toString();
//                               //const url = const value;
//                               if (await canLaunch(value)) {
//                                 await launch(value);
//                               }
//                             },
//                             child: Text('Y aller'),
//                           ),
//                         ),
//                         Center(
//                           child: RaisedButton(
//                             onPressed: () async {
//                             ScopedModel.of<GameModel>(context).terrainrencontre = model.data_terrain[i] ['nom'].toString() ;
//                                Navigator.pushNamedAndRemoveUntil(context, '/TerrainRencontre', (Route<dynamic> route) => false);
//                             },
//                             child: Text('Rencontre à venir'),
//                           ),
//                         ),
//                       ])));
//     }),
