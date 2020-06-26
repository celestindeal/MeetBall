import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:meetballl/models/Model_match.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:meetballl/profil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';


class TerrainRen extends StatefulWidget {
  @override
  _TerrainRenState createState() => _TerrainRenState();
}

class _TerrainRenState extends State<TerrainRen> {
  @override
  Widget build(BuildContext context) {
    terrain() async {
      await ScopedModel.of<GameModel>(context).Match();
      return true;
    }

    return Scaffold(
        appBar: AppBar(
    title: Text("Rencontre prévue"),
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
        body: FutureBuilder<bool>(
          future: terrain(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return AffRencontre();
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
        ));
  }
}

class AffRencontre extends StatefulWidget {
  @override
  _AffRencontreState createState() => _AffRencontreState();
}

class _AffRencontreState extends State<AffRencontre> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Widget build(BuildContext context) {

    void _onRefresh() async {
      ScopedModel.of<GameModel>(context).Match();
      Navigator.pushNamedAndRemoveUntil(
          context, '/TerrainRencontre', (Route<dynamic> route) => false);
      _refreshController.refreshCompleted();
    }
    return SmartRefresher(
      enablePullDown: true,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ScopedModelDescendant<GameModel>(builder: (context, child, model) {     
        bool affrencontre = false ;
        int nombreTours = model.taille;
        for (var i = 0; i < nombreTours; i++) {
          if ( ScopedModel.of<GameModel>(context).terrainrencontre == model.data_game[i]['lieu'] ){
            affrencontre = true ;
            }
        }
       
        return 
          affrencontre?
            ListView.builder(
              shrinkWrap: true,
              itemCount: nombreTours,
              itemBuilder: (context, i){
                if ( ScopedModel.of<GameModel>(context).terrainrencontre == model.data_game[i]['lieu'] ){
                  return Center(
                    child: GestureDetector(
                        onTap: () async {
                          model.afficher_lieu = false;
                          model.lieu = model.data_game[i]['lieu'];
                          model.id_rencontre = model.data_game[i]['id'];
                          ScopedModel.of<ImgModel>(context).Img();
                          ScopedModel.of<GameModel>(context).Terrain();
                          ScopedModel.of<GameModel>(context).Commentaire();
                          await ScopedModel.of<LoginModel>(context)
                              .Personne_propose(model.data_game[i]['id']);
                          //  model.rencontre_visualiser = model.data_game[i]['id'];
                          Navigator.pushNamed(context, '/Profil_renctontre');
                        },
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey,
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(model.data_game[i]['per'],
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2),
                                        Text(model.data_game[i]['jours'],
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2),
                                        Text(model.data_game[i]['heure'],
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2),
                                        Text(model.data_game[i]['nombre_j'],
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2),
                                        Text(model.data_game[i]['lieu'],
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2),
                                      ]),
                                ]))));
                }else{return Container();}

              })
              : Center(
                child: Text("Il n'y a pas de rencontre prévue",
                                              softWrap: true,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .display3),
              );
              
          
        
        
        
        
      }),
    );
  }
}
