import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';
import 'models/Model_match.dart';

var now = new DateTime.now();
bool rencontre = true;
bool chnagecouleur = false;

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModel>(builder: (context, child, model) {
      return Container(
        child: model.loging == false
            ? Scaffold(
                persistentFooterButtons: <Widget>[
                    Footer(),
                  ],
                body: Center(
                  child: CircularProgressIndicator(),
                ))
            : model.retour_Profil
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Center(
                            child: model.faux_pseudo
                                ? Text("ton email est faux",
                                    style: Theme.of(context).textTheme.display1)
                                : Text("ton password est faux",
                                    style:
                                        Theme.of(context).textTheme.display1)),
                        Center(
                            child: RaisedButton(
                          onPressed: () {
                            ScopedModel.of<LoginModel>(context).Deconnection();
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (Route<dynamic> route) => false);
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF0D47A1),
                                  Color(0xFF1976D2),
                                  Color(0xFF42A5F5),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Text('nouveaux test',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ))
                      ])
                : Presentation(),
      );
    });
  }
}

class Presentation extends StatefulWidget {
  @override
  _PresentationState createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {
  File image;

  String base64Image = "";

  bool affImage = true;

  @override
  Widget build(BuildContext context) {
    mis_ajour() {
      affImage = false;
    }

    Future<void> _choisirimage(BuildContext context) {
      bool aff = true;
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return aff
                  ? SingleChildScrollView(
                      child: ListBody(children: <Widget>[
                      GestureDetector(
                        child: Text("galerie"),
                        onTap: () async {
                          image = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            aff = false;
                          });

                          List<int> imageBytes = image.readAsBytesSync();
                          base64Image = await base64Encode(imageBytes);
                          await ScopedModel.of<LoginModel>(context)
                              .ChangeImage(base64Image);

                          mis_ajour();
                          Navigator.of(context).pop();
                        },
                      ),
                      Padding(padding: EdgeInsets.all(8.0)),
                      GestureDetector(
                        child: Text("caméra"),
                        onTap: () async {
                          image = await ImagePicker.pickImage(
                              source: ImageSource.camera);
                          setState(() {
                            aff = false;
                          });

                          List<int> imageBytes = image.readAsBytesSync();
                          base64Image = base64Encode(imageBytes);
                          await ScopedModel.of<LoginModel>(context)
                              .ChangeImage(base64Image);

                          mis_ajour();
                          Navigator.of(context).pop();
                        },
                      )
                    ]))
                  // : Center(
                  //     child: Container(
                  //       height: MediaQuery.of(context).size.height/3,
                  //       width: MediaQuery.of(context).size.width/3,
                  //       child: CircularProgressIndicator(),
                  //       child: Text("data"),
                  //     ),
                  //   );
                  : SingleChildScrollView(
                      child: ListBody(children: <Widget>[
                      Text(
                          "Merci de patienter le temps de l'envoie de votre photo",
                          softWrap: true,
                          style: Theme.of(context).textTheme.display3),
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 3,
                        child: CircularProgressIndicator(),
                      )
                    ]));
            }));
          });
    }

    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(ScopedModel.of<LoginModel>(context).pseudo),
          ),
          backgroundColor: Colors.indigo,
          leading: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/Ajout_match');
              }),
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
        body: SingleChildScrollView(child:
            ScopedModelDescendant<LoginModel>(builder: (context, child, model) {
          if (model.participation.length == 0) {
            rencontre = false;
          } else {
            rencontre = true;
          }
// calcule de l'age
          var ms = (new DateTime.now()).millisecondsSinceEpoch;
          String ok = "}" + model.age + "/";
          int jour = int.parse(ok.split('}')[1].split('-')[0]);
          int mois = int.parse(ok.split('-')[1].split('-')[0]);

            String placement = jour.toString() + '-'+ mois.toString() + '-';
          int ans = int.parse(ok.split(placement)[1].split('/')[0]);

          var mst = new DateTime.utc(ans, mois, jour, 20, 18, 04)
              .millisecondsSinceEpoch;
          int ageAnne = ((ms - mst) / (365 * 24 * 3600 * 1000)).toInt();
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return affImage
                                        ? Container(
                                            child: PhotoView(
                                            imageProvider:
                                                NetworkImage(model.img),
                                          ))
                                        : Container(
                                            child: PhotoView(
                                            imageProvider: FileImage(image),
                                          ));
                                  });
                            },
                            onLongPress: () {
                              _choisirimage(context);
                            },
                            child: CircleAvatar(
                              radius:
                                  (MediaQuery.of(context).size.width / 6) + 5,
                              backgroundColor: Colors.indigo,
                              child: CircleAvatar(
                                backgroundImage: affImage
                                    ? NetworkImage(model.img)
                                    : FileImage(image),
                                radius: MediaQuery.of(context).size.width / 6,
                              ),
                            )),
                        Container(
                          color: Colors.transparent,
                          height: MediaQuery.of(context).size.width / 4,
                          width: MediaQuery.of(context).size.width / 4,
                        )
                      ],
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 1.8,
                              height: MediaQuery.of(context).size.height / 3,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          height: 50,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(model.prenom + " ",
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display3),
                                            Text(model.nom,
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display3),
                                          ],
                                        ),
                                        Text(ageAnne.toString() + " ans",
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3),
                                        Text(model.club,
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3),
                                        Text(model.niveau,
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3),
                                        Container(
                                          height: 10,
                                        ),
                                        Text(model.description,
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3),
                                      ]),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                        child: Text('Modifier le profil'),
                        onPressed: () {
                          model.affmodif = true;
                          Navigator.pushNamedAndRemoveUntil(context, '/modif',
                              (Route<dynamic> route) => false);
                        }),
                    RaisedButton(
                        child: Text("organiser une rencontre"),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              '/Ajout_match', (Route<dynamic> route) => false);
                        }),
                  ],
                ),
                Divider(color: Colors.grey[300]),
                Center(
                    child: Text("Rencontre à venir",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: Theme.of(context).textTheme.display4)),
                rencontre
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: model.participation.length,
                        itemBuilder: (context, i) {
                          // calcule du temps avant le match
                          var ms = (new DateTime.now()).millisecondsSinceEpoch;
                          String ok ="}" + model.participation[i]['jour'] + "/";
                          int jour = int.parse(ok.split('}')[1].split('-')[0]);
                          int mois = int.parse(ok.split('-')[1].split('-')[0]);
                          String placement = jour.toString() + '-'+ mois.toString() + '-';
                          int ans =int.parse(ok.split(placement)[1].split('/')[0]);

                          var mst =
                              new DateTime.utc(ans, mois, jour, 20, 18, 04)
                                  .millisecondsSinceEpoch;
                          int tkt = ((mst - ms) / (24 * 3600 * 1000)).toInt();
                          String tempsavantmatch;
                          if (tkt < 2) {
                            tempsavantmatch = "aujoud'hui";
                          } else {
                            tempsavantmatch =
                                "dans " + tkt.toString() + " jour(s)";
                          }

                          if (chnagecouleur) {
                            chnagecouleur = false;
                          } else {
                            chnagecouleur = true;
                          }
                          return GestureDetector(
                            onTap: () async {
                              // on sélection la rencontre choisir

                              ScopedModel.of<GameModel>(context).lieu =
                                  model.participation[i]['lieu'];
                              ScopedModel.of<GameModel>(context).id_rencontre =
                                  model.participation[i]['id_rencontre'];
                              ScopedModel.of<GameModel>(context).nombJoueur =
                                  int.parse(model.participation[i]['nom_j']
                                      .toString());
                              ScopedModel.of<GameModel>(context).daterencontre =
                                  model.participation[i]['jour'];
                              ScopedModel.of<GameModel>(context)
                                      .heurerencontre =
                                  model.participation[i]['heure'];

                              // on prepare les image terrain et commentaire pour la page profil rencontre
                              ScopedModel.of<ImgModel>(context).Img();
                              ScopedModel.of<GameModel>(context).Terrain();

                              ScopedModel.of<GameModel>(context).Commentaire();

                              await ScopedModel.of<LoginModel>(context)
                                  .Personne_propose(
                                      model.participation[i]['id_rencontre']);

                              // await ScopedModel.of<LoginModel>(context).Personne_propose( model.participation[i]['id_rencontre']);

                              Navigator.pushNamed(
                                  context, '/Profil_renctontre');
                            },
                            child: Center(
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: chnagecouleur
                                          ? Colors.indigo
                                          : Colors.amber[900],
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                          "Cette rencontre est prevue ",
                                                          textAlign:
                                                              TextAlign.center,
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2),
                                                      Text(
                                                          tempsavantmatch +
                                                              " à " +
                                                              model.participation[
                                                                  i]['heure'],
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2),
                                                      Text(
                                                          "Il y a " +
                                                              model.participation[
                                                                  i]['nom_j'] +
                                                              " personne(s) qui seront là",
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2),
                                                    ]),
                                              ]),
                                          // RaisedButton(
                                          //   onPressed: () {
                                          //     showDialog(
                                          //         context: context,
                                          //         builder:
                                          //             (BuildContext context) {
                                          //           return Center(
                                          //             child: Flexible(
                                          //               child: Container(
                                          //                 width: MediaQuery.of(
                                          //                             context)
                                          //                         .size
                                          //                         .width /
                                          //                     1.3,
                                          //                 color: Colors.white,
                                          //                 child: Column(
                                          //                   mainAxisSize:
                                          //                       MainAxisSize
                                          //                           .min,
                                          //                   children: <Widget>[
                                          //                     Row(
                                          //                         mainAxisAlignment:
                                          //                             MainAxisAlignment
                                          //                                 .start,
                                          //                         children: <
                                          //                             Widget>[
                                          //                           Flexible(
                                          //                             child: Column(
                                          //                                 mainAxisAlignment: MainAxisAlignment
                                          //                                     .start,
                                          //                                 children: <
                                          //                                     Widget>[
                                          //                                   Center(
                                          //                                     child: Text("Es-tu sûr de vraiment vouloir annuler la rencontre prévue le " + model.participation[i]['jour'] + " à " + model.participation[i]['heure'], softWrap: true, textAlign: TextAlign.center, style: Theme.of(context).textTheme.display3),
                                          //                                   ),
                                          //                                   Text("Il y a " + model.participation[i]['nom_j'] + " personne(s) qui seront là",
                                          //                                       softWrap: true,
                                          //                                       style: Theme.of(context).textTheme.display3),
                                          //                                   Text("Vous avez invité " + model.participation[i]['inviter'] + " personne(s)",
                                          //                                       softWrap: true,
                                          //                                       style: Theme.of(context).textTheme.display3),
                                          //                                 ]),
                                          //                           ),
                                          //                         ]),
                                          //                     Row(
                                          //                       mainAxisAlignment:
                                          //                           MainAxisAlignment
                                          //                               .spaceEvenly,
                                          //                       children: <
                                          //                           Widget>[
                                          //                         RaisedButton(
                                          //                             onPressed:
                                          //                                 () {
                                          //                               Navigator.of(context)
                                          //                                   .pop();
                                          //                             },
                                          //                             child: Text(
                                          //                                 'non')),
                                          //                         RaisedButton(
                                          //                             onPressed:
                                          //                                 () async {
                                          //                               await ScopedModel.of<GameModel>(context).Sup_participation(
                                          //                                   model.participation[i]['inviter'],
                                          //                                   model.participation[i]['id'],
                                          //                                   model.participation[i]['id_rencontre']);
                                          //                               // recalcul des participation pour le nouvelle affichage
                                          //                               ScopedModel.of<LoginModel>(context)
                                          //                                   .ParticipationProil();
                                          //                               Navigator.of(context)
                                          //                                   .pop();
                                          //                             },
                                          //                             child: Text(
                                          //                                 'oui')),
                                          //                       ],
                                          //                     )
                                          //                   ],
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //           );
                                          //         });
                                          //   },
                                          //   child: Text("Annuler"),
                                          // ),
                                        ]))),
                          );
                        })
                    : Text("tu n'a pas de rencontre de prevue"),
              ]);
        })));
  }
}
