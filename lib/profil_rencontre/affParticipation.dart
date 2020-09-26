import 'package:flutter/material.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/models/Model_match.dart';
import 'package:scoped_model/scoped_model.dart';

// ignore: must_be_immutable
class AfParticipent extends StatefulWidget {
  AfParticipent(this.participant);
  List participant;
  @override
  _AffParticipentState createState() => _AffParticipentState();
}

class _AffParticipentState extends State<AfParticipent> {
  notation(String personnenoter, String strinIdRencontre) {
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
                              iconSize: MediaQuery.of(context).size.width / 11,
                              icon: Icon(Icons.star_border),
                              color: Colors.yellow,
                              onPressed: () {
                                ScopedModel.of<LoginModel>(context).envoieNote(
                                    "1", personnenoter, strinIdRencontre);
                                Navigator.of(context).pop();
                              },
                            ),
                            IconButton(
                              iconSize: MediaQuery.of(context).size.width / 11,
                              icon: Icon(Icons.star_border),
                              color: Colors.yellow,
                              onPressed: () {
                                ScopedModel.of<LoginModel>(context).envoieNote(
                                    "2", personnenoter, strinIdRencontre);
                                Navigator.of(context).pop();
                              },
                            ),
                            IconButton(
                              iconSize: MediaQuery.of(context).size.width / 11,
                              icon: Icon(Icons.star_border),
                              color: Colors.yellow,
                              onPressed: () {
                                ScopedModel.of<LoginModel>(context).envoieNote(
                                    "3", personnenoter, strinIdRencontre);
                                Navigator.of(context).pop();
                              },
                            ),
                            IconButton(
                              iconSize: MediaQuery.of(context).size.width / 11,
                              icon: Icon(Icons.star_border),
                              color: Colors.yellow,
                              onPressed: () {
                                ScopedModel.of<LoginModel>(context).envoieNote(
                                    "4", personnenoter, strinIdRencontre);
                                Navigator.of(context).pop();
                              },
                            ),
                            IconButton(
                              iconSize: MediaQuery.of(context).size.width / 11,
                              icon: Icon(Icons.star_border),
                              color: Colors.yellow,
                              onPressed: () {
                                ScopedModel.of<LoginModel>(context).envoieNote(
                                    "5", personnenoter, strinIdRencontre);
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

  List<bool> boaffnote = [];

  Widget build(BuildContext context) {
    List participant = widget.participant;
    return ScopedModelDescendant<LoginModel>(builder: (context, child, login) {
      int affnote = participant.length;

      for (var i = 0; i < affnote; i++) {
        boaffnote.add(false);
      }
      return Column(
        children: <Widget>[
          Container(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: affnote,
                  itemBuilder: (context, i) {
                    // on calcule la moyenne
                    double doubleMoyenne = 0;
                    String moyenne = 'Aucune note';
                    for (var a = 0; a < participant[i]['note'].length; a++) {
                      doubleMoyenne = doubleMoyenne +
                          int.parse(
                              participant[i]['note'][a]['note'].toString());
                    }
                    if (participant[i]['note'].length != 0) {
                      doubleMoyenne = doubleMoyenne /
                          double.parse(
                              participant[i]['note'].length.toString());
                      moyenne = doubleMoyenne.toString();
                    }

                    // on calcul l'age de la personne
                    var ms = (new DateTime.now()).millisecondsSinceEpoch;
                    String ok =
                        "}" + participant[i]['participent']['age'] + "/";

                    int jour = int.parse(ok.split('}')[1].split('-')[0]);
                    int mois = int.parse(ok.split('-')[1].split('-')[0]);

                    String placement =
                        jour.toString() + '-' + mois.toString() + '-';
                    int ans = int.parse(ok.split(placement)[1].split('/')[0]);

                    var mst = new DateTime.utc(ans, mois, jour, 20, 18, 04)
                        .millisecondsSinceEpoch;
                    double douAge = ((ms - mst) / (365 * 24 * 3600 * 1000));

                    int ageAnne = douAge.toInt();

                    // on veux savoir si cette personne est nous même
                    bool bonotation = true;
                    if (login.pseudo ==
                        participant[i]['participent']['pseudo']) {
                      bonotation = false;
                    } else {
                      bonotation = true;
                    }

                    // ici c'est le container pour celui qui a propose cette rencontre
                    return Column(
                      children: <Widget>[
                        Divider(color: Colors.grey),
                        GestureDetector(
                          onTap: () async {
                            if (participant[i]['participent']['pseudo'] ==
                                ScopedModel.of<LoginModel>(context)
                                    .pseudo
                                    .toString()) {
                              ScopedModel.of<LoginModel>(context)
                                  .ParticipationPr();
                              ScopedModel.of<LoginModel>(context).page = 1;
                              Navigator.pushNamed(context, '/Profil');
                            } else {
                              await login.ParticipationProilVisiteur(
                                  participant[i]['participent']['pseudo']);
                              ScopedModel.of<LoginModel>(context).profVisiteur =
                                  participant[i]['participent'];
                              Navigator.pushNamed(context, '/ProfilVisiteur');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              // border: Border.all(width: 0.8),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 2.0, vertical: 2.0),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        participant[i]['participent']['photo']),
                                    radius:
                                        MediaQuery.of(context).size.width / 20,
                                  ),
                                ),
                                Text(participant[i]['participent']['pseudo'],
                                    softWrap: true,
                                    style:
                                        Theme.of(context).textTheme.headline3),
                                Text(ageAnne.toString() + " ans ",
                                    softWrap: true,
                                    style:
                                        Theme.of(context).textTheme.headline3),
                                bonotation
                                    ? ScopedModel.of<LoginModel>(context)
                                            .boParticipation
                                        ? FlatButton(
                                            onPressed: () {
                                              notation(
                                                  participant[i]['participent']
                                                      ['pseudo'],
                                                  ScopedModel.of<GameModel>(
                                                          context)
                                                      .inIdRencontre);
                                            },
                                            child: Text(
                                              'noter',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          )
                                        : Container()
                                    : Container(
                                        child: Text('     ',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ))),
                              ],
                            ),
                          ),
                        ),
                        boaffnote[i]
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: participant[i]['note'].length,
                                itemBuilder: (context, n) {
                                  return Column(
                                    children: <Widget>[
                                      Divider(color: Colors.grey[300]),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                              participant[i]['note'][n]
                                                      ['pseudo']
                                                  .toString(),
                                              softWrap: true,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3),
                                          Text(
                                              participant[i]['note'][n]['note']
                                                  .toString(),
                                              softWrap: true,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3),
                                        ],
                                      ),
                                      Divider(color: Colors.grey[300]),
                                    ],
                                  );
                                })
                            : Container(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              boaffnote[i] = !boaffnote[i];
                            });
                          },
                          child: Text(moyenne,
                              softWrap: true,
                              style: Theme.of(context).textTheme.headline3),
                        ),
                      ],
                    );
                  })),
          Container(
            height: 10,
          )
        ],
      );
    });
  }
}
