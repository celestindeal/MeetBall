import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/models/Model_match.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';

var now = new DateTime.now();
bool rencontre = true;
bool chnagecouleur = false;

class ProfilVisiteur extends StatefulWidget {
  @override
  _ProfilVisiteurState createState() => _ProfilVisiteurState();
}

class _ProfilVisiteurState extends State<ProfilVisiteur> {


  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
    title: Center( child : Text( ScopedModel.of<LoginModel>(context).profVisiteur['pseudo']),),
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
                  body: SingleChildScrollView(child:
                      Center(
                        child: ScopedModelDescendant<LoginModel>(builder: (context, child, model) {
          // calcule de l'age
                    var ms = (new DateTime.now()).millisecondsSinceEpoch;
                    String ok = "}" + model.profVisiteur['age'].toString() + "/";
                    int ans = int.parse(ok.split('}')[1].split('-')[0]);
                    int mois = int.parse(ok.split('-')[1].split('-')[0]);
                    int jour = int.parse(ok.split('-')[1].split('/')[0]);
                    var mst = new DateTime.utc(ans, mois, jour, 20, 18, 04)
                          .millisecondsSinceEpoch;
                    int ageAnne = ((ms - mst) / (365 * 24 * 3600 * 1000)).toInt();

                     if (model.participationvisiteur.length == 0) {
            rencontre = false;
          } else {
            rencontre = true;
          }
                    return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                    
                                    GestureDetector(
                                      onTap: () {
                                        return showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return 
                                                  Container(
                                                      child: PhotoView(
                                                      imageProvider:
                                                          NetworkImage(model.profVisiteur['photo']),
                                                    )
                                                 );
                                            });
                                      },
                                    
                                      child: CircleAvatar(
                                        backgroundImage: 
                                             NetworkImage(model.profVisiteur['photo']),
                                        radius: MediaQuery.of(context).size.width / 4,
                                      ),
                                    ),
                                 
                              
                                Container(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                                                    Text(model.profVisiteur['nom'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display3),
                                                    Text(model.profVisiteur['prenom'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display3),
                                                    Text(ageAnne.toString() + " ans",
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display3),
                                                    Text(model.profVisiteur['club'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display3),
                                                    Text(model.profVisiteur['niveaux'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display3),
                                                    Container(
                                                      height: 10,
                                                    ),
                                                    Text(model.profVisiteur['message'],
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


                                 rencontre
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: model.participationvisiteur.length,
                        itemBuilder: (context, i) {
                          // calcule du temps avant le match
                          var ms = (new DateTime.now()).millisecondsSinceEpoch;
                          String ok =
                              "}" + model.participationvisiteur[i]['jour'] + "/";
                          int jour = int.parse(ok.split('}')[1].split('-')[0]);
                          int mois = int.parse(ok.split('-')[1].split('-')[0]);
                          String placement =
                              jour.toString() + '-' + mois.toString() + '-';
                          int ans =
                              int.parse(ok.split(placement)[1].split('/')[0]);

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
                                  model.participationvisiteur[i]['lieu'];
                              ScopedModel.of<GameModel>(context).id_rencontre =
                                  model.participationvisiteur[i]['id_rencontre'];
                              ScopedModel.of<GameModel>(context).nombJoueur =
                                  int.parse(model.participationvisiteur[i]['nom_j']
                                      .toString());
                              ScopedModel.of<GameModel>(context).daterencontre =
                                  model.participationvisiteur[i]['jour'];
                              ScopedModel.of<GameModel>(context)
                                      .heurerencontre =
                                  model.participationvisiteur[i]['heure'];
                                   ScopedModel.of<GameModel>(context)
                                      .organisateur =
                                  model.participationvisiteur[i]['pseudo'];

                              // on prepare les image terrain et commentaire pour la page profil rencontre
                              ScopedModel.of<ImgModel>(context).Img();
                              ScopedModel.of<GameModel>(context).Terrain();

                              ScopedModel.of<GameModel>(context).Commentaire();

                              await ScopedModel.of<LoginModel>(context)
                                  .Personne_propose(
                                      model.participationvisiteur[i]['id_rencontre']);

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
                                                              model.participationvisiteur[
                                                                  i]['heure'],
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2),
                                                      Text(
                                                          "Il y a " +
                                                              model.participationvisiteur[
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
                    : Center(
                        child: Text("il n'a pas de rencontre de prevue",
                            softWrap: true,
                            style: Theme.of(context).textTheme.display3)),
                     
                        
                          ]);
                  }),
                      )));
            }
          }
          
      