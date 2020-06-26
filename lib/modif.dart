import 'dart:convert';
import 'dart:io';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';

var pseudo;
var nom = " ";
var prenom = " ";
var email;
var password;
String _date = "date de naissance";
var club;
var niveaux;
var description;
var photo;
var id;
bool init = true;
bool affphoto = true;

class Modif extends StatefulWidget {
  @override
  _ModfState createState() => _ModfState();
}

class _ModfState extends State<Modif> {
  final _formKey = GlobalKey<FormState>();
  File image;
  String base64Image = "";
  Future<void> _choisirimage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('choisi entre'),
              content: SingleChildScrollView(
                  child: ListBody(children: <Widget>[
                GestureDetector(
                  child: Text("galerie"),
                  onTap: () async {
                    Navigator.of(context).pop();
                    image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    setState(() {
                      image = image;
                    });
                    List<int> imageBytes = image.readAsBytesSync();
                    base64Image = base64Encode(imageBytes);
                    affphoto = false;
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("caméra"),
                  onTap: () async {
                    Navigator.of(context).pop();
                    image =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    setState(() {
                      image = image;
                    });
                    List<int> imageBytes = image.readAsBytesSync();
                    base64Image = base64Encode(imageBytes);
                    affphoto = false;
                  },
                )
              ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
    title: Text("Modifier le profil"),
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
        // backgroundColor: Colors.black54,
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ScopedModelDescendant<LoginModel>(
                    builder: (context, child, model) {
                  if (init == true) {
                    pseudo = model.pseudo;
                    nom = model.nom;
                    prenom = model.prenom;

                    email = model.email;
                    password = model.password;
                    _date = model.age;
                    club = model.club;
                    niveaux = model.niveau;
                    description = model.description;
                    image = File(model.img);
                    id = model.id;
                    init = false;
                  }

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          initialValue: model.pseudo,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.black54,
                              decorationColor: Colors.black54),
                          decoration: const InputDecoration(
                            hintText: 'Pseudo',
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            pseudo = value;
                          },
                        ),


TextFormField(
                          initialValue: model.nom,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.black54,
                              decorationColor: Colors.black54),
                          decoration: const InputDecoration(
                            hintText: 'Nom',
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            nom = value;
                          },
                        ),TextFormField(
                          initialValue: model.prenom,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.black54,
                              decorationColor: Colors.black54),
                          decoration: const InputDecoration(
                            hintText: 'Prénom',
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            prenom = value;
                          },
                        ),


                        TextFormField(
                          initialValue: model.email,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.black54,
                              decorationColor: Colors.black54),
                          decoration: const InputDecoration(
                            hintText: 'email',
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        TextFormField(
                          initialValue: model.password,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.black54,
                              decorationColor: Colors.black54),
                          decoration: const InputDecoration(
                            hintText: 'password',
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                        Container(height: 10,),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          elevation: 4.0,
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1900, 0, 0),
                                maxTime: DateTime.now(),
                                theme: DatePickerTheme(
                                    headerColor: Colors.indigo,
                                    // backgroundColor: Colors.blue,
                                    itemStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    cancelStyle:  TextStyle(color: Colors.white, fontSize: 16),
                            doneStyle:
                                TextStyle(color: Colors.white, fontSize: 16)),
                                onChanged: (date) {}, onConfirm: (date) {
                              _date = '${date.year}-${date.month}-${date.day}';
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.fr);
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
                                                color: Colors.black,
                                                fontSize: 18.0),
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
                        TextFormField(
                          initialValue: model.club,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.black54,
                              decorationColor: Colors.black54),
                          decoration: const InputDecoration(
                            hintText: 'club',
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            club = value;
                          },
                        ),
                        TextFormField(
                          initialValue: model.niveau,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.black54,
                              decorationColor: Colors.black54),
                          decoration: const InputDecoration(
                            hintText: 'niveaux',
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            niveaux = value;
                          },
                        ),
                        TextFormField(
                          initialValue: model.description,
                          maxLines: 5,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.black54,
                              decorationColor: Colors.black54),
                          decoration: const InputDecoration(
                            hintText: 'description',
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            description = value;
                          },
                        ),
                      Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: RaisedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  model.loging = false;
                                  ScopedModel.of<LoginModel>(context).Modif(
                                      pseudo,
                                      email,
                                      nom,
                                      prenom,
                                      password,
                                      _date,
                                      club,
                                      niveaux,
                                      description,
                                      id);
                                      if(email != model.email || password != model.password){
                                        Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/',
                                      (Route<dynamic> route) => false);
                                      }else{
                                         Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/Profil',
                                      (Route<dynamic> route) => false);
                                      }
                                 
                                  init = true;
                                  affphoto = true;
                                }
                              },
                              child: Text("modifer"),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                })
              ],
            )),
          ),
        ));
  }
}
