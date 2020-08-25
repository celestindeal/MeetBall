import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:meetballl/models/Model_match.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
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
          centerTitle: true,
          title: Text("Rencontre à " +
              ScopedModel.of<GameModel>(context).terrainrencontre),
          backgroundColor: Colors.indigo,
        ),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        backgroundColor: back,
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
        bool affrencontre = false;
        int nombreTours = model.taille;
        for (var i = 0; i < nombreTours; i++) {
          if (ScopedModel.of<GameModel>(context).terrainrencontre ==
              model.data_game[i]['lieu']) {
            affrencontre = true;
          }
        }

        return affrencontre
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: nombreTours,
                itemBuilder: (context, i) {
                  // calcule du temps avant le match
                  var ms = (new DateTime.now()).millisecondsSinceEpoch;
                  String ok = "}" + model.data_game[i]['jours'] + "/";
                  int jour = int.parse(ok.split('}')[1].split('-')[0]);
                  int mois = int.parse(ok.split('-')[1].split('-')[0]);
                  String placement =
                      jour.toString() + '-' + mois.toString() + '-';
                  int ans = int.parse(ok.split(placement)[1].split('/')[0]);

                  var mst = new DateTime.utc(ans, mois, jour, 20, 18, 04)
                      .millisecondsSinceEpoch;
                  double tkt = ((mst - ms) / (24 * 3600 * 1000));
                  String tempsavantmatch;

                  if (tkt.toInt() == 0) {
                    tempsavantmatch =
                        "Aujoud'hui à " + model.data_game[i]['heure'];
                  } else if (1 <= tkt && tkt < 2) {
                    tempsavantmatch = "Demain à " + model.data_game[i]['heure'];
                  } else {
                    tempsavantmatch = "Dans " +
                        tkt.toInt().toString() +
                        " jour(s) à " +
                        model.data_game[i]['heure'];
                  }
                  if (ScopedModel.of<GameModel>(context).terrainrencontre ==
                      model.data_game[i]['lieu']) {
                    return Center(
                        child: GestureDetector(
                            onTap: () async {
                              model.afficher_lieu = false;
                              model.lieu = model.data_game[i]['lieu'];
                              model.id_rencontre = model.data_game[i]['id'];

                              model.nombJoueur =
                                  int.parse(model.data_game[i]['nombre_j']);
                              model.daterencontre = model.data_game[i]['jours'];
                              model.heurerencontre =
                                  model.data_game[i]['heure'];
                              ScopedModel.of<ImgModel>(context).Img();
                              ScopedModel.of<GameModel>(context).Terrain();
                              await ScopedModel.of<LoginModel>(context)
                                  .Personne_propose(model.data_game[i]['id']);
                              //  model.rencontre_visualiser = model.data_game[i]['id'];
                              ScopedModel.of<GameModel>(context)
                                  .commentaire
                                  .clear();
                              ScopedModel.of<GameModel>(context).nombre =
                                  0; // sela premette de reconmmencer l'affichage
                               ScopedModel.of<GameModel>(context)
                                  .Commentaire();
                              Navigator.pushNamed(
                                  context, '/Profil_renctontre');
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
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                                "Proposé par " +
                                                    model.data_game[i]['per'],
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text(tempsavantmatch,
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                            Text(
                                                "Il y as " +
                                                    model.data_game[i]
                                                        ['nombre_j'] +
                                                    " joueur(s)",
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2),
                                          ]),
                                    ]))));
                  } else {
                    return Container();
                  }
                })
            : Center(
                child: Text("Il n'y a pas de rencontre prévue",
                    softWrap: true,
                    style: Theme.of(context).textTheme.display3),
              );
      }),
    );
  }
}
