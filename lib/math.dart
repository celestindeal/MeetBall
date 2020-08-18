import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';
import 'models/Model_match.dart';

String id_rencontre;
bool chnagecouleur = true;

class Match extends StatefulWidget {
  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Match> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(builder: (context, child, model) {
      return Container(
          child: model.afficher
              ? Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Presentation(),
                  ],
                )
              : Scaffold(
                  appBar: AppBar(
                     centerTitle: true,
    title:   Text("MeetBall"),
                    
                    backgroundColor: Colors.indigo,
                    leading: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              '/Ajout_match', (Route<dynamic> route) => false);
                        }),
                   
                  ),
                  persistentFooterButtons: <Widget>[
                    Footer(),
                  ],
                  backgroundColor: back,
        body:  Center(
                    child: CircularProgressIndicator(),
                  )));
    });
  }
}

class Presentation extends StatelessWidget {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    void _onRefresh() async {
      ScopedModel.of<GameModel>(context).Match();
      Navigator.pushNamedAndRemoveUntil(
          context, '/Match', (Route<dynamic> route) => false);
      _refreshController.refreshCompleted();
    }

    return Scaffold(
        appBar: AppBar(
           centerTitle: true,
    title:  Text("Rencontre à venir"),
          
          backgroundColor: Colors.indigo,
          leading: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/Ajout_match');
              }),
         
        ),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        // backgroundColor: Colors.black,
        backgroundColor: back,
        body:  SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ScopedModelDescendant<GameModel>(
              builder: (context, child, model) {
            if (model.data_game.isEmpty) {
              return Center(
                child: Text('Aucune rencontre est proposée',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display3),
              );
            } else {
              return Stack(
                children: <Widget>[
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: model.taille,
                      itemBuilder: (context, i) {


// calcule du temps avant le match
                          var ms = (new DateTime.now()).millisecondsSinceEpoch;
                          String ok =
                              "}" + model.data_game[i]['jours'] + "/";
                          int jour = int.parse(ok.split('}')[1].split('-')[0]);

                          int mois = int.parse(ok.split('-')[1].split('-')[0]);
                            String placement = jour.toString() + '-'+ mois.toString() + '-';
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
                        return Center(
                            child: GestureDetector(
                                onTap: () async {
                                  model.afficher_lieu = false;
                                  
                                  // on sélection la rencontre choisir
                                  model.lieu = model.data_game[i]['lieu'];
                                  model.id_rencontre = model.data_game[i]['id'];
                                  model.nombJoueur = int.parse( model.data_game[i]['nombre_j']);
                                  model.daterencontre =  model.data_game[i]['jours'];
                                  model.heurerencontre =  model.data_game[i]['heure'];





                                  // on prepare les image terrain et commentaire pour la page profil rencontre
                                  ScopedModel.of<ImgModel>(context).Img();
                                  ScopedModel.of<GameModel>(context).Terrain();
                                  // ScopedModel.of<GameModel>(context)
                                  //     .Commentaire();

                                  await ScopedModel.of<LoginModel>(context)
                                      .Personne_propose(
                                          model.data_game[i]['id']);

                                  //  model.rencontre_visualiser = model.data_game[i]['id'];
                                  Navigator.pushNamed(
                                      context, '/Profil_renctontre');
                                },
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
                                      children: <Widget>[
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text("Proposé par ",
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text("Jour",
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text("Heure",
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text("Nombre de joueur(s)",
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text("Lieu",
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                  ]),
                                              Flexible(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                          model.data_game[i]['per'],
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .display2),
                                                      Text(
                                                         tempsavantmatch,
                                                          textAlign:
                                                              TextAlign.center,
                                                          softWrap: true,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .display2),
                                                      Text(
                                                          model.data_game[i]
                                                              ['heure'],
                                                          textAlign:
                                                              TextAlign.center,
                                                          softWrap: true,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .display2),
                                                      Text(
                                                          model.data_game[i]
                                                              ['nombre_j'],
                                                          textAlign:
                                                              TextAlign.center,
                                                          softWrap: true,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .display2),
                                                      Text(
                                                          model.data_game[i]
                                                              ['lieu'],
                                                          textAlign:
                                                              TextAlign.center,
                                                          softWrap: false,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .display2),
                                                    ]),
                                              ),
                                             
                                            ]
                                            ),
 RaisedButton(
                                                  onPressed: () async {
                                                    await ScopedModel.of<
                                                            LoginModel>(context)
                                                        .Personne_propose(model
                                                            .data_game[i]['id']);
                                                    // maintenant dans login modal var participent nous avons les participent

                                                    if (ScopedModel.of<LoginModel>(
                                                                context)
                                                            .boParticipation ==
                                                        false) {
                                                      // créer la participation
                                                      await model.Participation(
                                                          int.parse(model
                                                              .data_game[i]['id']),
                                                          ScopedModel.of<
                                                                      LoginModel>(
                                                                  context)
                                                              .pseudo,
                                                          int.parse(
                                                              model.data_game[i]
                                                                  ['nombre_j']));
                                                      await ScopedModel.of<GameModel>(
                                                              context)
                                                          .Match();
                                                      await Navigator
                                                          .pushNamedAndRemoveUntil(
                                                              context,
                                                              '/Match',
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                               
                                                    }else{
                                                        Scaffold.of(context).showSnackBar(
                                              new SnackBar(
                                                  content: new Text(
                                                      'Tu participe déjà à cette rencontre')));
                                                    }
                                                  },
                                                  child: Text("participer"))


                                      ],
                                    )
                                        )
                                        )
                                        );
                      }),
                ],
              );
            }
          }),
        ));
  }
}
