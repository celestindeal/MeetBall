import 'dart:async';

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
                          sdialog(context);
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

class Presentation extends StatefulWidget {
  @override
  _PresentationState createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {
  final _formKey = GlobalKey<FormState>();

  final key_commentainer = GlobalKey<FormState>();

  ScrollController _scrollController = new ScrollController();

  String com;

  int nombre_inviter;



  @override
  Widget build(BuildContext context) {

    // après une seconds les commentaire scroll sur le dernier commentaire publier
    Timer(
    Duration(seconds: 1),
    () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
  );

    notation(String personnenoter) {
      return RaisedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    backgroundColor: Colors.transparent,
                    content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Container(
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                iconSize:
                                    MediaQuery.of(context).size.width / 11,
                                icon: Icon(Icons.star_border),
                                color: Colors.yellow,
                                onPressed: () {
                                  ScopedModel.of<LoginModel>(context)
                                      .Envoienote("1", personnenoter);
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
                                      .Envoienote("2", personnenoter);
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
                                      .Envoienote("3", personnenoter);
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
                                      .Envoienote("4", personnenoter);
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
                                      .Envoienote("5", personnenoter);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ));
                    }));
              });
        },
        child: Text('noter'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ScopedModel.of<GameModel>(context).daterencontre +
              " à " +
              ScopedModel.of<GameModel>(context).heurerencontre,
        ),
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
                      child: Column(
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Nom ",
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2),
                                      Text("adresse",
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2),
                                      Text("ville",
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2),
                                      Text("nombre de terrain",
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2),
                                    ]),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(model.lieu,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2),
                                      Text(model.adresse_lieu,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2),
                                      Text(model.nom_t_lieu,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2),
                                      Text(model.ville_lieu,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2),
                                    ]),
                              ]),
                          Text(model.commentaire_lieu,
                              softWrap: true,
                              style: Theme.of(context).textTheme.display2),
                        ],
                      ),
                    ),
// cette colone afficher les images du lieu
                    Container(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 1),
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

//affichage des commentaires
                    ScopedModel.of<LoginModel>(context).boParticipation
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(children: <Widget>[
                              model.bocommentaire
                                  ? Column(
                                      children: <Widget>[
                                        Divider(color: Colors.grey[300]),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          color: Colors.grey,
                                          child: ListView.builder(
                                              controller: _scrollController,
                                              itemCount:
                                                  model.commentaire.length,
                                              itemBuilder: (context, i) {
                                                bool message;
                                                if (model.commentaire[i]['pseudo'] .toString() ==ScopedModel.of<LoginModel>(context) .pseudo.toString()) {
                                                  message = true;
                                                } else {
                                                  message = false;
                                                }
                                                
                                                return Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: message
                                                          ? MainAxisAlignment .end
                                                          : MainAxisAlignment .start,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: GestureDetector(
                                                            onLongPress: (){
                                                              if(message){
                                                                print('nouveux bouton');
                                                                
                                                                
                                                              }

                                                            },
                                                            child: Container(
                                                              padding:const EdgeInsets.all(15),
                                                              constraints: BoxConstraints(
                                                                  minWidth: MediaQuery.of(context).size.width / 5,
                                                                  maxWidth: MediaQuery.of(  context).size .width / 1.1),
                                                              decoration:BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(20.0),
                                                                color: message
                                                                    ? Colors.indigo
                                                                    : Colors.amber[ 900],
                                                              ),
                                                              child: 
                                                              Column(
                                                                children: < Widget>[
                                                                  Text( model.commentaire[ i][ 'commentaire'],
                                                                      textAlign: TextAlign.center,
                                                                      style: Theme.of(context).textTheme .display3),
                                                                  Text(model .commentaire[i]['pseudo']),
                                                                  Text(model.commentaire[ i]['date']),
                                                                ],
                                                              ),


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
                                    )
                                  : Container(),

                              // formulaire pour commenter
                              Form(
                                key: key_commentainer,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      color: Colors.indigo,
                                      child: TextFormField(
                                        autocorrect: true,
                                        cursorColor: Colors.white,
                                        style: TextStyle(
                                            color: Colors.white,
                                            decorationColor: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: 'Ecrivez un message...',
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          suffixIcon: IconButton(
                                            onPressed: () async {
                                              if (key_commentainer.currentState
                                                  .validate()) {
                                                await ScopedModel.of<GameModel>(
                                                        context)
                                                    .Ajouter_ommentaire(
                                                        com, login.pseudo);
                                                await ScopedModel.of<GameModel>(
                                                        context)
                                                    .Commentaire();
                                              }
                                            },
                                            icon: Icon(Icons.send),
                                            color: Colors.white,
                                          ),
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
                                  ],
                                ),
                              ),
                            ]),
                          )
                        : Container(),

// ce container affiche le bouton participer ou alluler la participation
                    Center(
                        child: Text("Participants",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context).textTheme.display4)),

                    // ici on propose les bouton pour la participation
                    // boParticipation est à true c'est que l'on participa déja si il est à false on participe pas encore

                    ScopedModel.of<LoginModel>(context).boParticipation
                        ? RaisedButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                                'Es-tu sûr de vraiment vouloir supprimer ta participation ?',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display1),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
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
                                                          .Personne_propose(model
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
                                                          model.nombJoueur,
                                                        );

                                                        // maintenant on refrech la page
                                                        model.nombJoueur--;
                                                        if (model.nombJoueur ==
                                                            0) {
                                                          ScopedModel.of<
                                                                      LoginModel>(
                                                                  context)
                                                              .ParticipationProil();

                                                          Navigator.pushNamed(
                                                              context,
                                                              '/Profil');
                                                        } else {
                                                          await ScopedModel.of<
                                                                      LoginModel>(
                                                                  context)
                                                              .Personne_propose(
                                                                  model
                                                                      .id_rencontre);
                                                        }
                                                      }
                                                      Navigator.of(context)
                                                          .pop();
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
                                  ScopedModel.of<LoginModel>(context).pseudo,
                                  model.nombJoueur,
                                );

                                // maintenant on refrech la page

                                model.nombJoueur++;
                                await ScopedModel.of<LoginModel>(context)
                                    .Personne_propose(model.id_rencontre);
                              }
                            },
                            child: Text("participer")),
// affichage des participations

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

                            int jour =
                                int.parse(ok.split('}')[1].split('-')[0]);
                            int mois =
                                int.parse(ok.split('-')[1].split('-')[0]);

                            String placement =
                                jour.toString() + '-' + mois.toString() + '-';
                            int ans =
                                int.parse(ok.split(placement)[1].split('/')[0]);

                            var mst =
                                new DateTime.utc(ans, mois, jour, 20, 18, 04)
                                    .millisecondsSinceEpoch;
                            int ageAnne =
                                ((ms - mst) / (365 * 24 * 3600 * 1000)).toInt();
                            bool bonotation = true;
                            if (login.pseudo ==
                                login.participent[i]['pseudo']) {
                              bonotation = false;
                            } else {
                              bonotation = true;
                            }

                            if (ScopedModel.of<GameModel>(context)
                                    .organisateur ==
                                login.participent[i]['pseudo']) {
                              // ici c'est le container pour celui qui a propose cette rencontre
                              return GestureDetector(
                                onTap: () async {
                                  if (login.participent[i]['pseudo'] ==
                                      ScopedModel.of<LoginModel>(context)
                                          .pseudo
                                          .toString()) {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/Profil',
                                        (Route<dynamic> route) => false);
                                  } else {
                                    await login.ParticipationProilVisiteur(
                                        login.participent[i]['pseudo']);
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
                                    color: Colors.amber[900],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
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
                                      bonotation
                                          ? ScopedModel.of<LoginModel>(context)
                                                  .boParticipation
                                              ? notation(login.participent[i]
                                                  ['pseudo'])
                                              : Container()
                                          : Container(),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              //ici c'est tous les autre participent
                              return GestureDetector(
                                onTap: () async {
                                  if (login.participent[i]['pseudo'] ==
                                      ScopedModel.of<LoginModel>(context)
                                          .pseudo
                                          .toString()) {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/Profil',
                                        (Route<dynamic> route) => false);
                                  } else {
                                    await login.ParticipationProilVisiteur(
                                        login.participent[i]['pseudo']);

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
                                      bonotation
                                          ? ScopedModel.of<LoginModel>(context)
                                                  .boParticipation
                                              ? notation(login.participent[i]
                                                  ['pseudo'])
                                              : Container()
                                          : Container(),
                                    ],
                                  ),
                                ),
                              );
                            }
                          });
                    }),
                  ])),
            );
          });
        });
      }),
    );
  }
}
