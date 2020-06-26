import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import 'footer.dart';
import 'models/Model_co.dart';
import 'models/Model_match.dart';
import 'models/Model_terrain.dart';

String lieuchoisi = "Choix du lieu";
List<String> reportList = [
  "Not relevant",
  "Illegal",
  "Spam",
  "Offensive",
  "Uncivil"
];
String _date = "Date";
String _time = "Heure";
var nombre_jo;
var pseudo;
var _controller = TextEditingController();

class Ajout_match extends StatefulWidget {
  @override
  _Ajout_matchState createState() => _Ajout_matchState();
}

class _Ajout_matchState extends State<Ajout_match> {
  final _formKey = GlobalKey<FormState>();
  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choisi ton lieu"),
            content: MultiSelectChip(reportList),
            actions: <Widget>[
              FlatButton(
                  child: Text("valider"),
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Ajouter une rencontre")),
          backgroundColor: Colors.indigo,
          leading: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/Ajout_match', (Route<dynamic> route) => false);
              }),
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
                        if (couleur) {
                          couleur = false;
                        } else {
                          couleur = true;
                        }
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Mode d'affichage:",
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2),
                                        RaisedButton(
                                            child: couleur
                                                ? Text("dark")
                                                : Text("normale"),
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
                                        child: Text(
                                            "POLITIQUE DE CONFIDENTIALITÉ"),
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
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/Avis',
                                            (Route<dynamic> route) => false);
                                      },
                                      child: Text('Nous contacter',
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Center(
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                          'Es-tu sûr de vraiment vouloir te déconnecter ?',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display1),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          RaisedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Text('non')),
                                                          RaisedButton(
                                                              onPressed:
                                                                  () async {
                                                                await ScopedModel.of<
                                                                            LoginModel>(
                                                                        context)
                                                                    .Deconnection();
                                                                await Baselocal()
                                                                    .deconnect();
                                                                Navigator.pushNamedAndRemoveUntil(
                                                                    context,
                                                                    '/',
                                                                    (Route<dynamic>
                                                                            route) =>
                                                                        false);
                                                              },
                                                              child:
                                                                  Text('oui')),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Text('Déconnexion',
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                    ),
                                    ScopedModel.of<LoginModel>(context)
                                            .devellopeur
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          '/avisDev',
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                },
                                                child: Container(
                                                  height:
                                                      (MediaQuery.of(context)
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
                                                  ScopedModel.of<ImgModel>(
                                                          context)
                                                      .Img();
                                                  ScopedModel.of<TerrainModel>(
                                                          context)
                                                      .TerrainDev();
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          '/lieuDev',
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                },
                                                child: Container(
                                                  height:
                                                      (MediaQuery.of(context)
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
        // backgroundColor: Colors.black,

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
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2030, 12, 31),
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
                        onChanged: (date) {}, onConfirm: (date) {
                      _date = '${date.year}-${date.month}-${date.day}';
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.fr);
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
                /* SizedBox(
                height: 20.0,
              ),
             */

                Container(
                  height: 10,
                ),
                RaisedButton(
                  padding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 4.0,
                  onPressed: () {
                    DatePicker.showTimePicker(context,
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
                        showTitleActions: true, onConfirm: (time) {
                      _time = '${time.hour}:${time.minute}';
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.fr);
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
                    return Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RaisedButton(
                                  child: Text("Lieu"),
                                  onPressed: () async {
                                    await ScopedModel.of<TerrainModel>(context)
                                        .List();
                                    reportList =
                                        ScopedModel.of<TerrainModel>(context)
                                            .nomlist;
                                    _showReportDialog();
                                  }),
                              Text(lieuchoisi),
                              TextFormField(
                                controller: _controller,
                                keyboardType: TextInputType.number,
                                maxLength: 2,
                                cursorColor: Colors.black,
                                style: TextStyle(
                                    color: Colors.black,
                                    decorationColor: Colors.black),
                                decoration: const InputDecoration(
                                  hintText: 'Nombre de joueurs',
                                  hintStyle: TextStyle(color: Colors.black),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Choisir un nombre de joueur(s)';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  nombre_jo = value;
                                },
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: RaisedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        await ScopedModel.of<GameModel>(context)
                                            .Ajout_match(lieuchoisi, _date,
                                                _time, nombre_jo, pseudo);
                                        await ScopedModel.of<GameModel>(context)
                                            .Match();
                                        setState(() {
                                          lieuchoisi = "Choix du lieu";
                                          _date = "Date";
                                          _time = "Heure";
                                          nombre_jo = null;
                                          _controller.clear();
                                        });

                                        Scaffold.of(context).showSnackBar(
                                            new SnackBar(
                                                content: new Text(
                                                    'Rencontre ajoutée')));
                                      }
                                    },
                                    child: Text('Proposer'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
                  });
                })
              ],
            ),
          ),
        ));
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  MultiSelectChip(this.reportList);
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  String selectedChoice =
      ""; // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
              lieuchoisi = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
