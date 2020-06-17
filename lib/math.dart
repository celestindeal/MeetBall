import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appBar.dart';
import 'footer.dart';
import 'drawer.dart';
import 'main.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';
import 'models/Model_match.dart';

String id_rencontre;

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
                  drawer: Darwer(),
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
        drawer: Darwer(),
        // backgroundColor: Colors.black54,
        body: SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ScopedModelDescendant<GameModel>(
              builder: (context, child, model) {
            return SingleChildScrollView(
                child: Column(
              children: <Widget>[
                RaisedButton(
                    child: Text("organiser une rencontre"),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/Ajout_match',
                          (Route<dynamic> route) => false);
                    }),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: model.taille,
                    itemBuilder: (context, i) {
                      return Center(
                          child: GestureDetector(
                              onTap: () async {
                                model.afficher_lieu = false;
                                model.lieu = model.data_game[i]['lieu'];
                                model.id_rencontre = model.data_game[i]['id'];
                                ScopedModel.of<ImgModel>(context).Img();
                                ScopedModel.of<GameModel>(context).Terrain();
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
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.grey,
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                              Text(
                                                  model.data_game[i]
                                                      ['nombre_j'],
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
                    }),
              ],
            ));
          }),
        ));
  }
}
