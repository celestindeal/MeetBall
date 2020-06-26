import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';
import 'models/Model_match.dart';

class Profil_renctontre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(builder: (context, child, model) {
      return Container(
          child: model.afficher_lieu
              ? Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Presentation(),
                  ],
                )
              : Scaffold(
                  appBar: AppBar(
                    title: Text("Rencontre"),
                    backgroundColor: Colors.indigo,
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                changeBrightness() {
                                  DynamicTheme.of(context).setBrightness(
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Brightness.light
                                          : Brightness.dark);
                                  Baselocal().mise_a_jour();
                                }

                                return Center(
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.grey,
                                      ),
                                      child: Center(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Mode d'affichage:",
                                                      softWrap: true,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .display2),
                                                  RaisedButton(
                                                      child: Text("normale"),
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
                                                  child: Text(
                                                      "POLITIQUE DE CONFIDENTIALITÉ"),
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
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          '/Avis',
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                },
                                                child: Text('Nous contacter',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .display3),
                                              ),
                                              RaisedButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Center(
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    'Es-tu sûr de vraiment vouloir te déconnecter ?',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .display1),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: <
                                                                      Widget>[
                                                                    RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            'non')),
                                                                    RaisedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await ScopedModel.of<LoginModel>(context)
                                                                              .Deconnection();
                                                                          await Baselocal()
                                                                              .deconnect();
                                                                          Navigator.pushNamedAndRemoveUntil(
                                                                              context,
                                                                              '/',
                                                                              (Route<dynamic> route) => false);
                                                                        },
                                                                        child: Text(
                                                                            'oui')),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Text('Déconnexion',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .display3),
                                              ),
                                              ScopedModel.of<LoginModel>(
                                                          context)
                                                      .devellopeur
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.pushNamedAndRemoveUntil(
                                                                context,
                                                                '/avisDev',
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false);
                                                          },
                                                          child: Container(
                                                            height: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                10),
                                                            child: Center(
                                                              child: Text(
                                                                  'avisDev',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            ScopedModel.of<
                                                                        ImgModel>(
                                                                    context)
                                                                .Img();
                                                            ScopedModel.of<
                                                                        TerrainModel>(
                                                                    context)
                                                                .TerrainDev();
                                                            Navigator.pushNamedAndRemoveUntil(
                                                                context,
                                                                '/lieuDev',
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false);
                                                          },
                                                          child: Container(
                                                            height: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                10),
                                                            child: Center(
                                                              child: Text(
                                                                  'lieuDev',
                                                                  style: Theme.of(
                                                                          context)
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
                  // backgroundColor: Colors.black,
                  body: Center(
                    child: CircularProgressIndicator(),
                  )));
    });
  }
}

class Presentation extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final key_commentainer = GlobalKey<FormState>();
  String com;
  int nombre_inviter;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rencontre"),
        backgroundColor: Colors.indigo,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Mode d'affichage:",
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2),
                                      RaisedButton(
                                          child: Text("normale"),
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
                                      child:
                                          Text("POLITIQUE DE CONFIDENTIALITÉ"),
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
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/Avis',
                                          (Route<dynamic> route) => false);
                                    },
                                    child: Text('Nous contacter',
                                        style: Theme.of(context)
                                            .textTheme
                                            .display3),
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Center(
                                              child: Container(
                                                color: Colors.white,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                        'Es-tu sûr de vraiment vouloir te déconnecter ?',
                                                        textAlign:
                                                            TextAlign.center,
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
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('non')),
                                                        RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              await ScopedModel
                                                                      .of<LoginModel>(
                                                                          context)
                                                                  .Deconnection();
                                                              await Baselocal()
                                                                  .deconnect();
                                                              Navigator.pushNamedAndRemoveUntil(
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .display3),
                                  ),
                                  ScopedModel.of<LoginModel>(context)
                                          .devellopeur
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        '/avisDev',
                                                        (Route<dynamic>
                                                                route) =>
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
                                                ScopedModel.of<ImgModel>(
                                                        context)
                                                    .Img();
                                                ScopedModel.of<TerrainModel>(
                                                        context)
                                                    .TerrainDev();
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        '/lieuDev',
                                                        (Route<dynamic>
                                                                route) =>
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
      // backgroundColor: Colors.black,
      body: ScopedModelDescendant<LoginModel>(builder: (context, child, login) {
        return ScopedModelDescendant<GameModel>(
            builder: (context, child, model) {
          return ScopedModelDescendant<ImgModel>(
              builder: (context, child, img) {
            int nombre_tour = 0;
            String lien1 = "";
            String lien2 = "";
            String lien3 = "";
            String lien4 = "";
// dans la boucle while je fait le tours de tous les images de la bases de donner avec img.data et quand les id correspond je met les lien dans les variables pour les afficher plus tard
            while (img.taille_img > nombre_tour) {
              if (model.id_terrain == img.data_img[nombre_tour]["id_lieu"]) {
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
            return SingleChildScrollView(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Text("lieu de la rencontre",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.display4),

// ce container contient les information sur le lieu
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.indigo,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Nom ",
                                      softWrap: true,
                                      style:
                                          Theme.of(context).textTheme.display2),
                                  Text("adresse",
                                      softWrap: true,
                                      style:
                                          Theme.of(context).textTheme.display2),
                                  Text("ville",
                                      softWrap: true,
                                      style:
                                          Theme.of(context).textTheme.display2),
                                  Text("nombre de terrain",
                                      softWrap: true,
                                      style:
                                          Theme.of(context).textTheme.display2),
                                ]),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(model.lieu,
                                      softWrap: true,
                                      style:
                                          Theme.of(context).textTheme.display2),
                                  Text(model.adresse_lieu,
                                      softWrap: true,
                                      style:
                                          Theme.of(context).textTheme.display2),
                                  Text(model.nom_t_lieu,
                                      softWrap: true,
                                      style:
                                          Theme.of(context).textTheme.display2),
                                  Text(model.ville_lieu,
                                      softWrap: true,
                                      style:
                                          Theme.of(context).textTheme.display2),
                                ]),
                          ]),
                    ),
// cette colone afficher les images du lieu
                    Container(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.8),
                          itemCount: 4,
                          itemBuilder: (BuildContext context, int itemIndex) {
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
                                        builder: (BuildContext context) {
                                          return Container(
                                              child: PhotoView(
                                            imageProvider: NetworkImage(image),
                                          ));
                                        });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.transparent,
                                    child: Image.network(
                                      image,
                                    ),
                                  ));
                            }
                          },
                        ),
                      ),
                    ),
// ce container affiche le profil de la personne qui à proposer la rencontre
                    Center(
                        child: Text("Participants",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context).textTheme.display4)),

                    ScopedModelDescendant<LoginModel>(
                        builder: (context, child, login) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: login.participent.length,
                          itemBuilder: (context, i) {
                            var ms =
                                (new DateTime.now()).millisecondsSinceEpoch;
                            String ok = "}" + login.participent[i]['age'] + "/";
                            int ans = int.parse(ok.split('}')[1].split('-')[0]);
                            int mois =
                                int.parse(ok.split('-')[1].split('-')[0]);
                            int jour =
                                int.parse(ok.split('-')[1].split('/')[0]);
                            var mst =
                                new DateTime.utc(ans, mois, jour, 20, 18, 04)
                                    .millisecondsSinceEpoch;
                            int ageAnne =
                                ((ms - mst) / (365 * 24 * 3600 * 1000)).toInt();
                            return GestureDetector(
                              onTap: () { print( ScopedModel.of<LoginModel>(context)
                                        .pseudo
                                        .toString());
                                print(login.participent[i]['pseudo'] );
                               
                                if (login.participent[i]['pseudo'] ==
                                    ScopedModel.of<LoginModel>(context)
                                        .pseudo
                                        .toString()) {
                                          print("yes");
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/Profil',
                                      (Route<dynamic> route) => false);
                                } else {
                                  ScopedModel.of<LoginModel>(context)
                                      .profVisiteur = login.participent[i];
                                  Navigator.pushNamed(
                                      context, '/ProfilVisiteur');
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.indigo,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(login.participent[i]['pseudo'],
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display3),
                                    Text(ageAnne.toString() + " ans",
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display3),
                                  ],
                                ),
                              ),
                            );
                          });
                    }),

// proposer une participation
                    // Center(
                    //     child: Text("Tu veux participer",
                    //         textAlign: TextAlign.center,
                    //         softWrap: true,
                    //         style: Theme.of(context).textTheme.display4)),
                    // Form(
                    //   key: _formKey,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       login.visiteur
                    //           ? login.boParticipation
                    //               ? Text(
                    //                   "tu partcipe déja à cette rencontre et tu as inviter " +
                    //                       login.nombreIviter.toString() +
                    //                       " personne(s)",
                    //                   textAlign: TextAlign.center)
                    //               : Text(
                    //                   "si tu veux participer à cette renconte tu peux  mes un joueur et valide et si tu est avec t'es pote note nombre que vous être ",
                    //                   textAlign: TextAlign.center)
                    //           : Text(
                    //               "c'est toi qui à proposer cette rencontre si ça à changer combien personne invite-tu ",
                    //               textAlign: TextAlign.center),
                    //       TextFormField(
                    //         keyboardType: TextInputType.number,
                    //         maxLength: 2,
                    //         cursorColor: Colors.black,
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             decorationColor: Colors.white),
                    //         decoration: const InputDecoration(
                    //           hintText: 'combien être vous',
                    //           hintStyle: TextStyle(color: Colors.white),
                    //         ),
                    //         validator: (value) {
                    //           if (value.isEmpty) {
                    //             return 'Please enter some text';
                    //           }
                    //           return null;
                    //         },
                    //         onChanged: (value) {
                    //           nombre_inviter = int.parse(value);
                    //         },
                    //       ),
                    //       Center(
                    //         child: Padding(
                    //           padding:
                    //               const EdgeInsets.symmetric(vertical: 16.0),
                    //           child: RaisedButton(
                    //             onPressed: () async {
                    //               if (_formKey.currentState.validate()) {
                    //                 await ScopedModel.of<GameModel>(context)
                    //                     .Participation(
                    //                   nombre_inviter,
                    //                   login.visiteur,
                    //                   login.pseudo,
                    //                 );
                    //                 ScopedModel.of<LoginModel>(context)
                    //                     .Participation();
                    //                 model.afficher = false;
                    //                 ScopedModel.of<GameModel>(context).Match();
                    //                 Navigator.pushNamedAndRemoveUntil(
                    //                     context,
                    //                     '/Match',
                    //                     (Route<dynamic> route) => false);
                    //               }
                    //             },
                    //             child: Text('comfirmer'),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

//affichage des commentaires
                    Column(
                      children: <Widget>[
                        Center(
                            child: Text("Commentaire",
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: Theme.of(context).textTheme.display4)),
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.commentaire.length,
                              itemBuilder: (context, i) {
                                bool message;
                                if (model.commentaire[i]['pseudo'].toString() ==
                                    ScopedModel.of<LoginModel>(context)
                                        .pseudo
                                        .toString()) {
                                  message = true;
                                } else {
                                  message = false;
                                }
                                return Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: message
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            constraints: BoxConstraints(
                                                minWidth: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    5,
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.1),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: message
                                                  ? Colors.indigo
                                                  : Colors.amber[900],
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                    model.commentaire[i]
                                                        ['commentaire'],
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .display3),
                                                Text(model.commentaire[i]
                                                    ['pseudo']),
                                                Text(model.commentaire[i]
                                                    ['date']),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                    Container(
                      height: 100,
                    ),
                    // formulaire pour commenter
                    Form(
                      key: key_commentainer,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            color: Colors.indigo,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              style: TextStyle(
                                  color: Colors.black,
                                  decorationColor: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Ecrivez un message...',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                com = value;
                              },
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: RaisedButton(
                                onPressed: () async {
                                  if (key_commentainer.currentState
                                      .validate()) {
                                    await ScopedModel.of<GameModel>(context)
                                        .Ajouter_ommentaire(com, login.pseudo);
                                    ScopedModel.of<GameModel>(context)
                                        .Commentaire();
                                  }
                                },
                                child: Text('commenter'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
            );
          });
        });
      }),
    );
  }
}
