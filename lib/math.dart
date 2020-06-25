import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appBar.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';
import 'models/Model_match.dart';

String id_rencontre;
bool chnagecouleur = true;

class Match extends StatelessWidget {
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
                    title: Text(
                      'Basketcopie',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    centerTitle: true,
                  ),
                  persistentFooterButtons: <Widget>[
                    Footer(),
                  ],
                  // backgroundColor: Colors.black54,
                  body: Center(
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
        appBar: headerNav(context),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        // backgroundColor: Colors.black54,
        body: SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ScopedModelDescendant<GameModel>(
              builder: (context, child, model) {
            return Stack(
              children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: model.taille,
                        itemBuilder: (context, i) {
                          if (chnagecouleur) {
                            chnagecouleur = false;
                          } else {
                            chnagecouleur = true;
                          }
                          return Center(
                              child: GestureDetector(
                                  onTap: () async {
                                    model.afficher_lieu = false;
                                    model.lieu = model.data_game[i]['lieu'];
                                    model.id_rencontre =
                                        model.data_game[i]['id'];
                                    ScopedModel.of<ImgModel>(context).Img();
                                    ScopedModel.of<GameModel>(context)
                                        .Terrain();
                                    ScopedModel.of<GameModel>(context)
                                        .Commentaire();
                                    await ScopedModel.of<LoginModel>(context)
                                        .Personne_propose(
                                            model.data_game[i]['per']);
                                    //  model.rencontre_visualiser = model.data_game[i]['id'];
                                    Navigator.pushNamed(
                                        context, '/Profil_renctontre');
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: chnagecouleur
                                            ? Colors.indigo
                                            : Colors.amber[900],
                                      ),
                                      child: Row(
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
                                                        textAlign: TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text(
                                                        model.data_game[i]
                                                            ['jours'],
                                                        textAlign: TextAlign.center,
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text(
                                                        model.data_game[i]
                                                            ['heure'],
                                                        textAlign: TextAlign.center,
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text(
                                                        model.data_game[i]
                                                            ['nombre_j'],
                                                        textAlign: TextAlign.center,
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                    Text(
                                                        model.data_game[i]
                                                            ['lieu'],
                                                        textAlign: TextAlign.center,
                                                        softWrap: false,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2),
                                                  ]),
                                            ),
                                          ])
                                          )
                                          )
                                          );
                        }),
                  
                // Transform.translate(
                //   offset: Offset(),
                //   child: MaterialButton(
                //     onPressed: () {Navigator.pushNamedAndRemoveUntil(context,
                //                 '/Ajout_match', (Route<dynamic> route) => false);},
                //     color: Colors.blue,
                //     textColor: Colors.white,
                //     child: Icon(
                //       Icons.add,
                //       size: 24,
                //     ),
                //     padding: EdgeInsets.all(16),
                //     shape: CircleBorder(),
                //   ),
                // )
              ],
            );
          }),
        ));
  }
}
