import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meetballl/models/Model_match.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
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
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    void _onRefresh() async {
      ScopedModel.of<LoginModel>(context).ParticipationProilVisiteur(
          ScopedModel.of<LoginModel>(context).profVisiteur["pseudo"]);

      _refreshController.refreshCompleted();
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:
              Text(ScopedModel.of<LoginModel>(context).profVisiteur["pseudo"]),
          backgroundColor: Colors.indigo,
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
              String ok = "}" + model.profVisiteur["age"] + "/";
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
                                        return Container(
                                            child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: PhotoView(
                                                  imageProvider: NetworkImage(
                                                      model.profVisiteur[
                                                          "photo"]),
                                                )));
                                      });
                                },
                                child: CircleAvatar(
                                  radius:
                                      (MediaQuery.of(context).size.width / 6) +
                                          5,
                                  backgroundColor: Colors.indigo,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        model.profVisiteur["photo"]),
                                    radius:
                                        MediaQuery.of(context).size.width / 6,
                                  ),
                                )),
                            Text(model.noteVisiteur.toString() + "/5",
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
                                                Text(
                                                    model.profVisiteur[
                                                            "prenom"] +
                                                        " ",
                                                    softWrap: true,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3),
                                                Text(model.profVisiteur["nom"],
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
                                            Text(model.profVisiteur["club"],
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3),
                                            Text(model.profVisiteur["niveaux"],
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3),
                                            Container(
                                              height: 10,
                                            ),
                                            Text(model.profVisiteur["message"],
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
                            child: Text('Envoyer une invitation'),
                            onPressed: () {
                              Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Text(
                                      "Cette fonctionnalite n'existe pas encore")));
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
                            color: model.participationProilfutureVisiteur
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
                                    .participationProilfutureVisiteur = false;
                                ScopedModel.of<LoginModel>(context)
                                    .ParticipationProilVisiteur(
                                        model.profVisiteur["pseudo"]);
                              }),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: model.participationProilfutureVisiteur
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
                                    .participationProilfutureVisiteur = true;
                                ScopedModel.of<LoginModel>(context)
                                    .ParticipationProilVisiteur(
                                        model.profVisiteur["pseudo"]);
                              }),
                        ),
                      ],
                    ),
                    rencontre
                        ? Expanded(
                            child: GestureDetector(
                              onHorizontalDragEnd: (details) {
                                // setState(() {
                                //   model.participationProilfutureVisiteur =
                                //       !model.participationProilfutureVisiteur;
                                // });
                                setState(() {
                                  if (model.participationProilfutureVisiteur) {
                                    ScopedModel.of<LoginModel>(context)
                                            .participationProilfutureVisiteur =
                                        false;
                                    ScopedModel.of<LoginModel>(context)
                                        .ParticipationProilVisiteur(
                                            model.profVisiteur["pseudo"]);
                                  } else {
                                    ScopedModel.of<LoginModel>(context)
                                            .participationProilfutureVisiteur =
                                        true;
                                    ScopedModel.of<LoginModel>(context)
                                        .ParticipationProilVisiteur(
                                            model.profVisiteur["pseudo"]);
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.grey,
                                child: ListView.builder(
                                    // physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        model.participationvisiteur.length,
                                    itemBuilder: (context, i) {
                                      // calcule du temps avant le match
                                      var ms = (new DateTime.now())
                                          .millisecondsSinceEpoch;
                                      String ok = "}" +
                                          model.participationvisiteur[i]
                                              ['jour'] +
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
                                            model.participationvisiteur[i]
                                                ['heure'];
                                      } else {
                                        //dans le future
                                        if (tkt.toInt() == 0) {
                                          tempsavantmatch = "aujoud'hui à " +
                                              model.participationvisiteur[i]
                                                  ['heure'];
                                        } else if (1 <= tkt && tkt < 2) {
                                          tempsavantmatch = "demain à " +
                                              model.participationvisiteur[i]
                                                  ['heure'];
                                        } else {
                                          tempsavantmatch = "dans " +
                                              tkt.toInt().toString() +
                                              " jour(s) à " +
                                              model.participationvisiteur[i]
                                                  ['heure'];
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
                                                model.participationvisiteur[i]
                                                    ['lieu'];
                                            ScopedModel.of<GameModel>(context)
                                                    .inIdRencontre =
                                                model.participationvisiteur[i]
                                                    ['stirnIdrencontre'];
                                            ScopedModel.of<GameModel>(context)
                                                    .nombJoueur =
                                                int.parse(model
                                                    .participationvisiteur[i]
                                                        ['nom_j']
                                                    .toString());
                                            ScopedModel.of<GameModel>(context)
                                                    .daterencontre =
                                                model.participationvisiteur[i]
                                                    ['jour'];
                                            ScopedModel.of<GameModel>(context)
                                                    .heurerencontre =
                                                model.participationvisiteur[i]
                                                    ['heure'];
                                            ScopedModel.of<ImgModel>(context)
                                                .imageTerrainId(
                                                    model.participationvisiteur[
                                                        i]['lieu']);

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
                                                    model.participationvisiteur[
                                                        i]['stirnIdrencontre']);

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
                                                                            model.participationvisiteur[i][
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
                        : Center(
                            child: Text("tu n'a pas de rencontre de prevue",
                                softWrap: true,
                                style: Theme.of(context).textTheme.headline3)),
                  ]);
            })));
  }
}
