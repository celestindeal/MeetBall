import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:meetballl/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';

import 'footer.dart';
import 'models/Model_co.dart';
import 'models/Model_match.dart';
import 'models/Model_terrain.dart';

String lieuchoisi = "Choix du lieu";

String _date = "Date";
DateTime curseurdate = DateTime.now();
DateTime curseurtime = DateTime.now();

String _time = "Heure";
var nombre_jo = "1";
var pseudo;
var _controller = TextEditingController();
List terrain = [];
bool init = true;
bool afficher = true;

class Ajout_match extends StatefulWidget {
  @override
  _Ajout_matchState createState() => _Ajout_matchState();
}

class _Ajout_matchState extends State<Ajout_match> {
  terrainre(String terrainre) async {
    List contruction = [];
    await ScopedModel.of<TerrainModel>(context).Terrain();
    terrain.clear();
    if (terrainre.isEmpty) {
      // quand l'utilisateur viens d'appuyer mais qu'il n'a rien écrit on passe ici et on affiche tous
      terrain = [];
    } else {
      // on vas regarder mot pare mot si on a des lettre on commun avec la recherche
      int plusG = 0;
      for (var i = 0;
          i < ScopedModel.of<TerrainModel>(context).taille_terrain;
          i++) {
        int nombre = 0;
        nombre = comparestring(
            terrainre.toUpperCase(),
            ScopedModel.of<TerrainModel>(context)
                .data_terrain[i]['ville']
                .toUpperCase());
        if (nombre > 0 && nombre > (plusG - 2)) {
          plusG = nombre;
          // ici le lieu doit être affiche il vas dans construction
          Map tkt = {
            'contruiction':
                ScopedModel.of<TerrainModel>(context).data_terrain[i],
            "nombre": nombre
          };
          contruction.add(tkt);
        }
      }
      int copie = contruction.length;
      // objatif classer les lieu dans l'ordre
      for (var i = 0; i < copie; i++) {
        int nombreplus = 0;
        int place;
        for (var n = 0; n < contruction.length; n++) {
          if (contruction[n]['nombre'] >= nombreplus) {
            nombreplus = contruction[n]['nombre'];
            place = n;
          }
        }
        if (nombreplus >= (plusG - 1)) {
          terrain.add(contruction[place]['contruiction']);
        }
        contruction.removeAt(place);
      }
    }
    afficher = true;
  }
lieutrouver(String lieu ){
    Navigator.of(context).pop();
                                        setState(() {
                                          lieuchoisi =lieu;
                                        });
}
  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          print(terrain);
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: back,
              title: Text("Choisi ton lieu"),
              actions: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Divider(color: Colors.grey),
                      TextFormField(
                        autocorrect: true,
                        cursorColor: Colors.black,
                        style: Theme.of(context).textTheme.display3,
                        decoration: const InputDecoration(
                          hintText: 'Trouver un playground',
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        onChanged: (value) async {
                          setState(() {
                            afficher = false;
                          });
                          await terrainre(value);
                          setState(() {
                            terrain;
                            afficher;
                          });
                        },
                      ),
                      Flexible(
                        child: Container(
                          child: afficher
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: terrain.length,
                                  itemBuilder: (context, i) {
                                    print('normale affichage');
                                    return GestureDetector(
                                      onTap: (){
                                        lieutrouver(terrain[i]['nom']);
                                      
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                20,
                                        child: Center(
                                          child: Text(
                                              terrain[i]['nom'] +
                                                  " (" +
                                                  terrain[i]['ville'] +
                                                  ')',
                                              softWrap: true,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .display3),
                                        ),
                                      ),
                                    );
                                  })
                              : CircularProgressIndicator(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Ajouter une rencontre"),
          backgroundColor: Colors.indigo,
        ),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        // backgroundColor: Colors.black,

        backgroundColor: back,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  padding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 4.0,
                  onPressed: () {
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(2030, 12, 31),
                      currentTime: curseurdate,
                      locale: LocaleType.fr,
                      theme: DatePickerTheme(
                          headerColor: Colors.indigo,
                          // backgroundColor: Colors.blue,
                          itemStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          cancelStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16)),
                      onChanged: (date) {},
                      onConfirm: (date) {
                        curseurdate = date;
                        _date = '${date.day}-${date.month}-${date.year}';
                        setState(() {});
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    size: 18.0,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    " $_date",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  color: Colors.amber[900],
                ),
                Container(
                  height: 10,
                ),
                RaisedButton(
                  padding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 4.0,
                  onPressed: () {
                    DatePicker.showTimePicker(
                      context,
                      showSecondsColumn: false,
                      currentTime: curseurtime,
                      locale: LocaleType.fr,
                      theme: DatePickerTheme(
                          headerColor: Colors.indigo,
                          // backgroundColor: Colors.blue,
                          itemStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          cancelStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16)),
                      showTitleActions: true,
                      onConfirm: (time) {
                        curseurtime = time;
                        _time = '${time.hour}:${time.minute}';
                        setState(() {});
                      },
                    );
                    setState(() {});
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    size: 18.0,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    " $_time",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  color: Colors.amber[900],
                ),
                ScopedModelDescendant<GameModel>(
                    builder: (context, child, model) {
                  return ScopedModelDescendant<LoginModel>(
                      builder: (context, child, model) {
                    pseudo = model.pseudo;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RaisedButton(
                              child: Text(lieuchoisi),
                              onPressed: () async {
                                _showReportDialog();
                              }),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: RaisedButton(
                                onPressed: () async {
                                  if (_date == "Date") {
                                    Scaffold.of(context).showSnackBar(
                                        new SnackBar(
                                            content: new Text(
                                                'Tu doit choisir une date')));
                                  } else if (_time == "Heure") {
                                    Scaffold.of(context).showSnackBar(
                                        new SnackBar(
                                            content: new Text(
                                                'Tu doit choisir une heure')));
                                  } else {
                                    if (lieuchoisi == "Choix du lieu" ||
                                        lieuchoisi ==
                                            "Tu doit choisir un lieu") {
                                      Scaffold.of(context).showSnackBar(
                                          new SnackBar(
                                              content: new Text(
                                                  'Tu doit choisir un lieu')));
                                    } else {
                                      await ScopedModel.of<GameModel>(context)
                                          .Ajout_match(lieuchoisi, _date, _time,
                                              nombre_jo, pseudo);
                                      await ScopedModel.of<GameModel>(context)
                                          .Match();
                                      setState(() {
                                        lieuchoisi = "Choix du lieu";
                                        _date = "Date";
                                        _time = "Heure";
                                        nombre_jo = null;
                                        curseurdate = DateTime.now();
                                        curseurtime = DateTime.now();
                                        _controller.clear();
                                      });

                                      Scaffold.of(context).showSnackBar(
                                          new SnackBar(
                                              content: new Text(
                                                  'Rencontre ajoutée')));
                                    }
                                  }
                                },
                                child: Text('Proposer'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                })
              ],
            ),
          ),
        ));
  }
}
