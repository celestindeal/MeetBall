import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meetballl/profil_rencontre/affParticipation.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:meetballl/models/Model_match.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Presentation extends StatefulWidget {
  @override
  _PresentationState createState() => _PresentationState();
}

double largeur = 0.9;
double hauteur = 0.9;
double largeurMessage = 0;
double hauteurMessage = 200;
bool init = true;
bool initmove = true;

class _PresentationState extends State<Presentation> {
  final _formKey = GlobalKey<FormState>();

  final key_commentainer = GlobalKey<FormState>();

  ScrollController _scrollController = new ScrollController();

  String com;

  int nombre_inviter;
  bool aff_participent =
      false; // false = afficher tous les participent     true = afficher seulement trois participent

  @override
  Widget build(BuildContext context) {
    if (init) {
      init = false;
      setState(() {
        largeurMessage = MediaQuery.of(context).size.width * 0.4 / .15;
        hauteurMessage = MediaQuery.of(context).size.height * 0.35 / .15;
      });
    }

    String ok = "}" + ScopedModel.of<GameModel>(context).daterencontre + "/";
    String heure =
        "}" + ScopedModel.of<GameModel>(context).heurerencontre + "/";
    int jour = int.parse(ok.split('}')[1].split('-')[0]);
    int mois = int.parse(ok.split('-')[1].split('-')[0]);
    int heur = int.parse(heure.split('}')[1].split(':')[0]);
    String placement = jour.toString() + '-' + mois.toString() + '-';
    int ans = int.parse(ok.split(placement)[1].split('/')[0]);
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    var mst =
        new DateTime.utc(ans, mois, jour, heur, 00, 04).millisecondsSinceEpoch;
    double tkt = (mst - ms) / (3600 * 1000);
    final difference =
        DateTime(ans, mois, jour, heur).difference(DateTime.now()).inHours;
    String tempsavantmatch = tkt.round().toString() + " heures";

    // après une seconds les commentaire scroll sur le dernier commentaire publier

// calcul pour savoir si la rencontre est déja passer
// si difference est négative la rencontre est passer

    notation(String personnenoter, String id_rencontre) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                backgroundColor: Colors.transparent,
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                      height: MediaQuery.of(context).size.height / 5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Tu veux noter ' + personnenoter),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                iconSize:
                                    MediaQuery.of(context).size.width / 11,
                                icon: Icon(Icons.star_border),
                                color: Colors.yellow,
                                onPressed: () {
                                  ScopedModel.of<LoginModel>(context)
                                      .Envoienote(
                                          "1", personnenoter, id_rencontre);
                                  Navigator.of(context).pop();
                                },
                              ),
                              IconButton(
                                iconSize:
                                    MediaQuery.of(context).size.width / 11,
                                icon: Icon(Icons.star_border),
                                color: Colors.yellow,
                                onPressed: () {
                                  ScopedModel.of<LoginModel>(context)
                                      .Envoienote(
                                          "2", personnenoter, id_rencontre);
                                  Navigator.of(context).pop();
                                },
                              ),
                              IconButton(
                                iconSize:
                                    MediaQuery.of(context).size.width / 11,
                                icon: Icon(Icons.star_border),
                                color: Colors.yellow,
                                onPressed: () {
                                  ScopedModel.of<LoginModel>(context)
                                      .Envoienote(
                                          "3", personnenoter, id_rencontre);
                                  Navigator.of(context).pop();
                                },
                              ),
                              IconButton(
                                iconSize:
                                    MediaQuery.of(context).size.width / 11,
                                icon: Icon(Icons.star_border),
                                color: Colors.yellow,
                                onPressed: () {
                                  ScopedModel.of<LoginModel>(context)
                                      .Envoienote(
                                          "4", personnenoter, id_rencontre);
                                  Navigator.of(context).pop();
                                },
                              ),
                              IconButton(
                                iconSize:
                                    MediaQuery.of(context).size.width / 11,
                                icon: Icon(Icons.star_border),
                                color: Colors.yellow,
                                onPressed: () {
                                  ScopedModel.of<LoginModel>(context)
                                      .Envoienote(
                                          "5", personnenoter, id_rencontre);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ],
                      ));
                }));
          });
    }

    participationnote() async {
      List participent = ScopedModel.of<LoginModel>(context).participent;
      String id = ScopedModel.of<GameModel>(context).id_rencontre;
      List listpersonne = [];
      String url = 'http://51.210.103.151/post_note_id.php';
      for (var i = 0; i < participent.length; i++) {
        String pseudo_joueur = participent[i]['pseudo'];
        String json = '{"pseudo":"$pseudo_joueur","id":"$id"}';
        Response response = await post(url, body: json);
        List personne = jsonDecode(response.body);
        Map contruction = {'participent': participent[i], "note": personne};
        listpersonne.add(contruction);
      }
      return listpersonne;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          ScopedModel.of<GameModel>(context).lieu,
        ),
        backgroundColor: Colors.indigo,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.directions),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('Ouvrir avec'),
                        content: SingleChildScrollView(
                            child: ListBody(children: <Widget>[
                          GestureDetector(
                            child: Text("Google map"),
                            onTap: () async {
                              String value = ScopedModel.of<GameModel>(context)
                                  .url_lieu
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
                              String value = ScopedModel.of<GameModel>(context)
                                  .urlwaze_lieu
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
          ),
        ],
      ),
      persistentFooterButtons: <Widget>[
        Footer(),
      ],
      // backgroundColor: Colors.black,
      backgroundColor: back,
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
            while (img.imagelieu.length > nombre_tour) {
              if (lien1 == "") {
                lien1 = img.imagelieu[nombre_tour]["lien"];
              } else if (lien2 == "") {
                lien2 = img.imagelieu[nombre_tour]["lien"];
              } else if (lien3 == "") {
                lien3 = img.imagelieu[nombre_tour]["lien"];
              } else if (lien4 == "") {
                lien4 = img.imagelieu[nombre_tour]["lien"];
              }
              nombre_tour++;
            }

            // on calcul le coff de l'image pour definir la taille du sizebox ou l'on vas les afficher
            double hauteurimage = 1;
            double largeur_image = 1;
            double douCoffImage = 1.333;

            return 
                SingleChildScrollView(
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                        // ici on propose les bouton pour la participation
                        // boParticipation est à true c'est que l'on participa déja si il est à false on participe pas encore

// cette colone afficher les images du lieu
                        Container(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width *
                                douCoffImage,
                            child: PageView.builder(
                              controller: PageController(viewportFraction: 1),
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
                                          builder: (BuildContext context) {
                                            return Container(
                                                child: PhotoView(
                                              imageProvider:
                                                  NetworkImage(image),
                                            ));
                                          });
                                    },
                                    child: Image.network(
                                      image,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                        // ce container contient les information sur le lieu
                        Column(
                          children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                          model.adresse_lieu +
                                              ", " +
                                              model.nom_t_lieu,
                                          textAlign: TextAlign.end,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                          ScopedModel.of<GameModel>(context)
                                                  .daterencontre +
                                              ", " +
                                              ScopedModel.of<GameModel>(context)
                                                  .heurerencontre,
                                          textAlign: TextAlign.end,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                    ],
                                  ),
                                ]),
                            Text(model.commentaire_lieu,
                                softWrap: true,
                                style: Theme.of(context).textTheme.display3),
                          ],
                        ),
                        difference > 0
                            ? ScopedModel.of<LoginModel>(context)
                                    .boParticipation
                                ? RaisedButton(
                                    onPressed: () async {
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
                                                        'Es-tu sûr de vraiment vouloir supprimer ta participation ?',
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
                                                                  .Personne_propose(
                                                                      model
                                                                          .id_rencontre);
                                                              // maintenant dans login modal var participent nous avons les participent

                                                              if (ScopedModel.of<
                                                                              LoginModel>(
                                                                          context)
                                                                      .boParticipation ==
                                                                  true) {
                                                                // créer la participation
                                                                await model
                                                                    .Sup_participation(
                                                                  int.parse(model
                                                                      .id_rencontre),
                                                                  ScopedModel.of<
                                                                              LoginModel>(
                                                                          context)
                                                                      .pseudo,
                                                                  model
                                                                      .nombJoueur,
                                                                );

                                                                // maintenant on refrech la page
                                                                model
                                                                    .nombJoueur--;
                                                                if (model
                                                                        .nombJoueur ==
                                                                    0) {
                                                                  ScopedModel.of<
                                                                              LoginModel>(
                                                                          context)
                                                                      .ParticipationProil();
                                                                  ScopedModel.of<
                                                                              LoginModel>(
                                                                          context)
                                                                      .page = 1;
                                                                  Navigator.pushNamedAndRemoveUntil(
                                                                      context,
                                                                      '/Profil',
                                                                      (Route<dynamic>
                                                                              route) =>
                                                                          false);
                                                                } else {
                                                                  await ScopedModel.of<
                                                                              LoginModel>(
                                                                          context)
                                                                      .Personne_propose(
                                                                          model
                                                                              .id_rencontre);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }
                                                              }
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
                                    child: Text("supprimer ma participation"))
                                : RaisedButton(
                                    onPressed: () async {
                                      await ScopedModel.of<LoginModel>(context)
                                          .Personne_propose(model.id_rencontre);
                                      // maintenant dans login modal var participent nous avons les participent

                                      if (ScopedModel.of<LoginModel>(context)
                                              .boParticipation ==
                                          false) {
                                        // créer la participation
                                        await model.Participation(
                                          int.parse(model.id_rencontre),
                                          ScopedModel.of<LoginModel>(context)
                                              .pseudo,
                                          model.nombJoueur,
                                        );

                                        // maintenant on refrech la page

                                        model.nombJoueur++;
                                        await ScopedModel.of<LoginModel>(
                                                context)
                                            .Personne_propose(
                                                model.id_rencontre);
                                        _scrollController.jumpTo(
                                            _scrollController
                                                .position.maxScrollExtent);
                                      }
                                    },
                                    child: Text("participer"))
                            : Container(),
// affichage des participations
                        difference > 0
                            ? ScopedModelDescendant<LoginModel>(
                                builder: (context, child, login) {
                                // calcule du nombre de personne à afficher
                                int affichage_participent =
                                    login.participent.length;

                                if (affichage_participent > 3 &&
                                    aff_participent == false) {
                                  affichage_participent = 3;
                                }

                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: affichage_participent,
                                    itemBuilder: (context, i) {
                                      var ms = (new DateTime.now())
                                          .millisecondsSinceEpoch;
                                      String ok = "}" +
                                          login.participent[i]['age'] +
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
                                      int ageAnne = ((ms - mst) /
                                              (365 * 24 * 3600 * 1000))
                                          .toInt();
                                      bool bonotation = true;
                                      if (login.pseudo ==
                                          login.participent[i]['pseudo']) {
                                        bonotation = false;
                                      } else {
                                        bonotation = true;
                                      }

                                      // ici c'est le container pour celui qui a propose cette rencontre
                                      return Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () async {
                                              if (login.participent[i]
                                                      ['pseudo'] ==
                                                  ScopedModel.of<LoginModel>(
                                                          context)
                                                      .pseudo
                                                      .toString()) {
                                                ScopedModel.of<LoginModel>(
                                                        context)
                                                    .ParticipationProil();
                                                ScopedModel.of<LoginModel>(
                                                        context)
                                                    .page = 1;
                                                Navigator.pushNamed(
                                                    context, '/Profil');
                                              } else {
                                                await login
                                                    .ParticipationProilVisiteur(
                                                        login.participent[i]
                                                            ['pseudo']);
                                                ScopedModel.of<LoginModel>(
                                                            context)
                                                        .profVisiteur =
                                                    login.participent[i];
                                                Navigator.pushNamed(
                                                    context, '/ProfilVisiteur');
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 0.8),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0,
                                                      vertical: 2.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 2.0,
                                                        vertical: 2.0),
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                              login.participent[
                                                                  i]['photo']),
                                                      radius:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              20,
                                                    ),
                                                  ),
                                                  Text(
                                                      login.participent[i]
                                                          ['pseudo'],
                                                      softWrap: true,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .display3),
                                                  Text(
                                                      ageAnne.toString() +
                                                          " ans ",
                                                      softWrap: true,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .display3),
                                                  bonotation
                                                      ? ScopedModel.of<
                                                                      LoginModel>(
                                                                  context)
                                                              .boParticipation
                                                          ? FlatButton(
                                                              onPressed: () {
                                                                if (difference <
                                                                    0) {
                                                                  notation(
                                                                      login.participent[
                                                                              i]
                                                                          [
                                                                          'pseudo'],
                                                                      model
                                                                          .id_rencontre);
                                                                } else {
                                                                  Scaffold.of(
                                                                          context)
                                                                      .showSnackBar(new SnackBar(
                                                                          content:
                                                                              new Text('Tu pourra noter cette personne dans ' + tempsavantmatch)));
                                                                }
                                                              },
                                                              child: Text(
                                                                'noter',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            )
                                                          : Container()
                                                      : Container(
                                                          child: FlatButton(
                                                              child: Text(
                                                                  '     ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                  )))),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              })
                            : Container(),
                        difference > 0
                            ? login.participent.length > 3
                                ? IconButton(
                                    icon: aff_participent
                                        ? Icon(Icons.arrow_upward)
                                        : Icon(Icons.arrow_downward),
                                    onPressed: () {
                                      setState(() {
                                        aff_participent = !aff_participent;
                                      });
                                    })
                                : Container()
                            : FutureBuilder<List>(
                                future: participationnote(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List> snapshot) {
                                  if (snapshot.hasData) {
                                    return AffParticipent(snapshot.data);
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
                              )
                      ])),
                );
                // ScopedModel.of<LoginModel>(context).boParticipation
                //     ? Container(
                //         width: MediaQuery.of(context).size.width,
                //         height: MediaQuery.of(context).size.height,
                //         child: MatrixGestureDetector(
                //           onMatrixUpdate: (m, tm, sm, rm) {
                //             if (initmove) {
                //               initmove = false;
                //               largeur = m.entry(0, 3) / .15;
                //               hauteur = m.entry(1, 3) / .15;
                //             }

                //             setState(() {
                //               largeurMessage = largeurMessage +
                //                   ((m.entry(0, 3) / .15) - largeur);
                //               hauteurMessage = hauteurMessage +
                //                   ((m.entry(1, 3) / .15) - hauteur);
                //             });

                //             largeur = m.entry(0, 3) / .15;
                //             hauteur = m.entry(1, 3) / .15;
                //           },
                //           child: Transform.scale(
                //             scale: .15,
                //             child: Transform.translate(
                //                 offset: Offset(largeurMessage, hauteurMessage),
                //                 child: MaterialButton(
                //                   onPressed: () async {
                //                     ScopedModel.of<GameModel>(context)
                //                         .commentaire
                //                         .clear();
                //                     ScopedModel.of<GameModel>(context).nombre =
                //                         0; // sela premette de reconmmencer l'affichage
                //                     await ScopedModel.of<GameModel>(context)
                //                         .Commentaire();
                //                     Navigator.pushNamed(
                //                         context, '/commentaire');
                //                   },
                //                   color: Colors.indigo,
                //                   textColor: Colors.white,
                //                   child: Icon(
                //                     Icons.comment,
                //                     size: 300,
                //                   ),
                //                   padding: EdgeInsets.all(16),
                //                   shape: CircleBorder(),
                //                 )),
                //           ),
                //         ),
                //       )
                //     : Container(),
             
          });
        });
      }),
    );
  }
}