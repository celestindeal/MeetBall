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
    title: Center( child : Text( ScopedModel.of<LoginModel>(context).pseudo),),
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
                                      child:  Text("normale"),
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
          int ans = int.parse(ok.split('}')[1].split('-')[0]);
          int mois = int.parse(ok.split('-')[1].split('-')[0]);
          int jour = int.parse(ok.split('-')[1].split('/')[0]);
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
                            backgroundImage: affImage
                                ? NetworkImage(model.img)
                                : FileImage(image),
                            radius: MediaQuery.of(context).size.width / 6,
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          height: MediaQuery.of(context).size.width / 3,
                          width: MediaQuery.of(context).size.width / 3,
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
                                        Text(model.nom,
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3),
                                        Text(model.prenom,
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3),
                                        Text(model.email,
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3),
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
                          if (chnagecouleur) {
                            chnagecouleur = false;
                          } else {
                            chnagecouleur = true;
                          }
                          return GestureDetector(
                            onTap: () async {
                              ScopedModel.of<GameModel>(context).lieu =
                                  model.participation[i]['lieu'];
                              ScopedModel.of<GameModel>(context).id_rencontre =
                                  model.participation[i]['id_rencontre'];
                              ScopedModel.of<ImgModel>(context).Img();
                              ScopedModel.of<GameModel>(context).Terrain();
                              ScopedModel.of<GameModel>(context).Commentaire();
                              await ScopedModel.of<LoginModel>(context)
                                  .Personne_propose(
                                      model.participation[i]['id_rencontre']);
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
                                                          "le " +
                                                              model.participation[
                                                                  i]['jour'] +
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
                                                      Text(
                                                          "Vous avez invité " +
                                                              model.participation[
                                                                      i]
                                                                  ['inviter'] +
                                                              " personne(s)",
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2),
                                                    ]),
                                              ]),
                                          RaisedButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Center(
                                                      child: Flexible(
                                                        child: Container(
                                                         width: MediaQuery.of(context).size.width/1.3,
                                                         color: Colors.white,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Flexible(
                                                                      child: Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .start,
                                                                          children: <
                                                                              Widget>[
                                                                            Center(
                                                                              child: Text(
                                                                                  "Es-tu sûr de vraiment vouloir annuler la rencontre prévue le " +
                                                                                      model.participation[i]['jour'] +
                                                                                      " à " +
                                                                                      model.participation[i]['heure'],
                                                                                  softWrap: true,
                                                                                  textAlign: TextAlign.center,
                                                                                  style: Theme.of(context).textTheme.display3),
                                                                            ),
                                                                            Text(
                                                                                "Il y a " +
                                                                                    model.participation[i]['nom_j'] +
                                                                                    " personne(s) qui seront là",
                                                                                softWrap: true,
                                                                                style: Theme.of(context).textTheme.display3),
                                                                            Text(
                                                                                "Vous avez invité " +
                                                                                    model.participation[i]['inviter'] +
                                                                                    " personne(s)",
                                                                                softWrap: true,
                                                                                style: Theme.of(context).textTheme.display3),
                                                                          ]),
                                                                    ),
                                                                  ]),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: <
                                                                    Widget>[
                                                                  RaisedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop();
                                                                      },
                                                                      child: Text(
                                                                          'non')),
                                                                  RaisedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        await ScopedModel.of<GameModel>(context).Sup_participation(
                                                                            model.participation[i]
                                                                                [
                                                                                'inviter'],
                                                                            model.participation[i]
                                                                                [
                                                                                'id'],
                                                                            model.participation[i]
                                                                                [
                                                                                'id_rencontre']);
                                                                        ScopedModel.of<LoginModel>(
                                                                                context)
                                                                            .Participation();
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop();
                                                                      },
                                                                      child: Text(
                                                                          'oui')),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Text("Annuler"),
                                          ),
                                        ]))),
                          );
                        })
                    : Text("tu n'a pas de rencontre de prevue"),
              ]);
        })));
  }
}
