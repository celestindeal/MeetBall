import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';
import 'models/Model_match.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
                backgroundColor: back,
                body: Center(
                  child: CircularProgressIndicator(),
                ))
            : model.boRetourProfil
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Center(
                            child: model.boFauxPseudo
                                ? Text("ton email est faux",
                                    style:
                                        Theme.of(context).textTheme.headline1)
                                : Text("ton password est faux",
                                    style:
                                        Theme.of(context).textTheme.headline1)),
                        Center(
                            child: RaisedButton(
                          onPressed: () {
                            ScopedModel.of<LoginModel>(context).deconnection();
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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    misAjour() {
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

                          List<int> imageBytescompress =
                              await FlutterImageCompress.compressWithList(
                            imageBytes,
                            minHeight: 1920,
                            minWidth: 1080,
                            quality: 96,
                            rotate: 0,
                          );

                          base64Image = base64Encode(imageBytescompress);
                          await ScopedModel.of<LoginModel>(context)
                              .changeImage(base64Image);

                          misAjour();
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
                              .changeImage(base64Image);

                          misAjour();
                          Navigator.of(context).pop();
                        },
                      )
                    ]))
                  : SingleChildScrollView(
                      child: ListBody(children: <Widget>[
                      Text(
                          "Merci de patienter le temps de l'envoie de ta photo",
                          softWrap: true,
                          style: Theme.of(context).textTheme.headline3),
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 3,
                        child: CircularProgressIndicator(),
                      )
                    ]));
            }));
          });
    }

    void _onRefresh() async {
      ScopedModel.of<LoginModel>(context).ParticipationPr();

      _refreshController.refreshCompleted();
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(ScopedModel.of<LoginModel>(context).pseudo),
          backgroundColor: Colors.indigo,
          leading: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/Ajout_match');
              }),
          actions: <Widget>[
            IconButton(
              // icon: const Icon(Icons.settings),
              icon: const Icon(Icons.more_vert),

              onPressed: () {
                Navigator.pushNamed(context, '/parametre');
              },
            ),
          ],
        ),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        backgroundColor: back,
        body: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: ScopedModelDescendant<LoginModel>(
                builder: (context, child, model) {
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

              String placement = jour.toString() + '-' + mois.toString() + '-';
              int ans = int.parse(ok.split(placement)[1].split('/')[0]);

              var mst = new DateTime.utc(ans, mois, jour, 20, 18, 04)
                  .millisecondsSinceEpoch;
              double douAge = ((ms - mst) / (365 * 24 * 3600 * 1000));
              int ageAnne = douAge.toInt();
              return Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                    ),
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
                                                child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: PhotoView(
                                                  imageProvider:
                                                      NetworkImage(model.img),
                                                ),
                                              ))
                                            : Container(
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: PhotoView(
                                                      imageProvider:
                                                          FileImage(image),
                                                    )));
                                      });
                                },
                                onLongPress: () {
                                  _choisirimage(context);
                                },
                                child: CircleAvatar(
                                  radius:
                                      (MediaQuery.of(context).size.width / 6) +
                                          5,
                                  backgroundColor: Colors.indigo,
                                  child: CircleAvatar(
                                    backgroundImage: affImage
                                        ? NetworkImage(model.img)
                                        : FileImage(image),
                                    radius:
                                        MediaQuery.of(context).size.width / 6,
                                  ),
                                )),
                            Text(model.noteprofil.toString() + "/5",
                                softWrap: true,
                                style: Theme.of(context).textTheme.headline3),
                          ],
                        ),
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
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
                                            Row(
                                              children: <Widget>[
                                                Text(model.prenom + " ",
                                                    softWrap: true,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3),
                                                Text(model.nom,
                                                    softWrap: true,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3),
                                              ],
                                            ),
                                            Text(ageAnne.toString() + " ans",
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3),
                                            Text(model.club,
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3),
                                            Text(model.niveau,
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3),
                                            Container(
                                              height: 10,
                                            ),
                                            Text(model.description,
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3),
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
                              Navigator.pushNamed(context, '/modif');
                            }),
                        RaisedButton(
                            child: Text("organiser une rencontre"),
                            onPressed: () {
                              Navigator.pushNamed(context, '/Ajout_match');
                            }),
                      ],
                    ),
                    Divider(color: Colors.grey[300]),
                    Center(
                        child: Text("Rencontre",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context).textTheme.headline4)),
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: model.participationProilfuture
                                ? Colors.transparent
                                : Colors.grey,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2,
                          child: FlatButton(
                              child: Text("Rencontre fini"),
                              onPressed: () async {
                                ScopedModel.of<LoginModel>(context)
                                    .participationProilfuture = false;
                                ScopedModel.of<LoginModel>(context)
                                    .ParticipationPr();
                              }),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: model.participationProilfuture
                                ? Colors.grey
                                : Colors.transparent,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2,
                          child: FlatButton(
                              child: Text("Rencontre à venir"),
                              onPressed: () async {
                                ScopedModel.of<LoginModel>(context)
                                    .participationProilfuture = true;
                                ScopedModel.of<LoginModel>(context)
                                    .ParticipationPr();
                              }),
                        ),
                      ],
                    ),
                    rencontre
                        ? Expanded(
                            child: GestureDetector(
                              onHorizontalDragEnd: (details) {
                                setState(() {
                                  model.participationProilfuture =
                                      !model.participationProilfuture;
                                });
                              },
                              child: Container(
                                color: Colors.grey,
                                child: ListView.builder(
                                    // physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: model.participation.length,
                                    itemBuilder: (context, i) {
                                      // calcule du temps avant le match
                                      var ms = (new DateTime.now())
                                          .millisecondsSinceEpoch;
                                      String ok = "}" +
                                          model.participation[i]['jour'] +
                                          "/";
                                      int jour = int.parse(
                                          ok.split('}')[1].split('-')[0]);
                                      int mois = int.parse(
                                          ok.split('-')[1].split('-')[0]);
                                      String placement = jour.toString() +
                                          '-' +
                                          mois.toString() +
                                          '-';
                                      int ans = int.parse(
                                          ok.split(placement)[1].split('/')[0]);

                                      var mst = new DateTime.utc(
                                              ans, mois, jour, 20, 18, 04)
                                          .millisecondsSinceEpoch;

                                      String tempsavantmatch = 'bnokt';
                                      double tkt =
                                          ((mst - ms) / (24 * 3600 * 1000))
                                              .abs();

                                      if (ms >= mst) {
                                        // dans le passer

                                        tempsavantmatch = "il y as " +
                                            tkt.toInt().toString() +
                                            " jour(s) à " +
                                            model.participation[i]['heure'];
                                      } else {
                                        //dans le future
                                        if (tkt.toInt() == 0) {
                                          tempsavantmatch = "aujoud'hui à " +
                                              model.participation[i]['heure'];
                                        } else if (1 <= tkt && tkt < 2) {
                                          tempsavantmatch = "demain à " +
                                              model.participation[i]['heure'];
                                        } else {
                                          tempsavantmatch = "dans " +
                                              tkt.toInt().toString() +
                                              " jour(s) à " +
                                              model.participation[i]['heure'];
                                        }
                                      }
                                      if (chnagecouleur) {
                                        chnagecouleur = false;
                                      } else {
                                        chnagecouleur = true;
                                      }
                                      if (tkt >= 0) {
                                        return GestureDetector(
                                          onTap: () async {
                                            // on sélection la rencontre choisir

                                            ScopedModel.of<GameModel>(context)
                                                    .lieu =
                                                model.participation[i]['lieu'];
                                            ScopedModel.of<GameModel>(context)
                                                    .inIdRencontre =
                                                model.participation[i]
                                                    ['stirnIdrencontre'];
                                            ScopedModel.of<GameModel>(context)
                                                    .nombJoueur =
                                                int.parse(model.participation[i]
                                                        ['nom_j']
                                                    .toString());
                                            ScopedModel.of<GameModel>(context)
                                                    .daterencontre =
                                                model.participation[i]['jour'];
                                            ScopedModel.of<GameModel>(context)
                                                    .heurerencontre =
                                                model.participation[i]['heure'];
                                            ScopedModel.of<ImgModel>(context)
                                                .imageTerrainId(model
                                                    .participation[i]['lieu']);

                                            // on prepare les image terrain et commentaire pour la page profil rencontre
                                            ScopedModel.of<ImgModel>(context)
                                                .listImage();
                                            ScopedModel.of<GameModel>(context)
                                                .terrain();

                                            // ScopedModel.of<GameModel>(context)
                                            //     .Commentaire();

                                            await ScopedModel.of<LoginModel>(
                                                    context)
                                                .personnePropose(
                                                    model.participation[i]
                                                        ['stirnIdrencontre']);

                                            // await ScopedModel.of<LoginModel>(context).Personne_propose( model.participation[i]['stirnIdrencontre']);
                                            ScopedModel.of<GameModel>(context)
                                                .lisCommentaire
                                                .clear();
                                            ScopedModel.of<GameModel>(context)
                                                    .nombre =
                                                0; // sela premette de reconmmencer l'affichage
                                            await ScopedModel.of<GameModel>(
                                                    context)
                                                .commentaire();
                                            Navigator.pushNamed(
                                                context, '/Profil_renctontre');
                                          },
                                          child: Center(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  margin:
                                                      const EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    color: chnagecouleur
                                                        ? Colors.indigo
                                                        : Colors.amber[900],
                                                  ),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: <Widget>[
                                                              Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        "Cette rencontre est prevue ",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        softWrap:
                                                                            true,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline2),
                                                                    Text(
                                                                        tempsavantmatch,
                                                                        softWrap:
                                                                            true,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline2),
                                                                    Text(
                                                                        "Il y a " +
                                                                            model.participation[i][
                                                                                'nom_j'] +
                                                                            " personne(s) qui seront là",
                                                                        softWrap:
                                                                            true,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline2),
                                                                  ]),
                                                            ]),
                                                      ]))),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey,
                            child: Center(
                              child: Text("tu n'a pas de rencontre de prevue",
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.headline3),
                            ),
                          )),
                  ]);
            })));
  }
}
