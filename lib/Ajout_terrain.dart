import 'dart:convert';
import 'dart:io';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_match.dart';
import 'models/Model_terrain.dart';

String nom;
String adresse;
String ville;
int nombre_terrain;
String sol = " ";
String ouverture = " ";
bool afficherimage = false;
int n = 0;
var _controller1 = TextEditingController();
var _controller2 = TextEditingController();
var _controller3 = TextEditingController();
var _controller4 = TextEditingController();
var _controller5 = TextEditingController();
var _controller6 = TextEditingController();

class Ajout_terrain extends StatefulWidget {
  @override
  _Ajout_terrainState createState() => _Ajout_terrainState();
}

class _Ajout_terrainState extends State<Ajout_terrain> {
  final _formKey = GlobalKey<FormState>();

  List<File> image = [];
  List base64Image = [];

  Future<void> _choisirimage(BuildContext contex) {
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
                    image.add(await ImagePicker.pickImage(
                        source: ImageSource.gallery));
                    setState(() {
                      image;
                      afficherimage = true;
                    });
                    List<int> imageBytes =
                        image[image.length - 1].readAsBytesSync();
                    base64Image.add(base64Encode(imageBytes));
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("caméra"),
                  onTap: () async {
                    image.add(await ImagePicker.pickImage(
                        source: ImageSource.camera));
                    setState(() {
                      image;
                      afficherimage = true;
                    });
                    List<int> imageBytes =
                        image[image.length - 1].readAsBytesSync();
                    base64Image.add(base64Encode(imageBytes));
                    Navigator.of(context).pop();
                  },
                )
              ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
    title: Text("Ajouter un playground"),
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
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        // backgroundColor: Colors.black54,

        body:
            ScopedModelDescendant<GameModel>(builder: (context, child, model) {
          return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _controller1,
                      cursorColor: Colors.black54,
                      style: TextStyle(
                          color: Colors.black54,
                          decorationColor: Colors.black54),
                      decoration: const InputDecoration(
                        hintText: 'Nom',
                        hintStyle: TextStyle(color: Colors.black54),
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
                    ),
                    TextFormField(
                      style: TextStyle(
                          color: Colors.black54,
                          decorationColor: Colors.black54),
                      controller: _controller2,
                      cursorColor: Colors.black54,
                      decoration: InputDecoration(
                        hasFloatingPlaceholder: true,
                        filled: false,
                        fillColor: Colors.black,
                        hintText: 'Adresse',
                        hintStyle: TextStyle(color: Colors.black),
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            var location = new Location();
                            var currentLocation = await location.getLocation();
                            adresse = currentLocation.latitude.toString();
                            ville = currentLocation.longitude.toString();
                            setState(() {
                              _controller2 =
                                  TextEditingController(text: adresse);
                              _controller3 = TextEditingController(text: ville);
                            });
                          },
                          child: Icon(Icons.gps_fixed),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Il faut une adresse";
                        }
                      },
                      onChanged: (value) {
                        adresse = value;
                      },
                    ),
                    TextFormField(
                      controller: _controller3,
                      cursorColor: Colors.black54,
                      style: TextStyle(
                          color: Colors.black54,
                          decorationColor: Colors.black54),
                      decoration: const InputDecoration(
                        hintText: 'Ville',
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        ville = value;
                      },
                    ),
                    TextFormField(
                      controller: _controller4,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      cursorColor: Colors.black54,
                      style: TextStyle(
                          color: Colors.black54,
                          decorationColor: Colors.black54),
                      decoration: const InputDecoration(
                        hintText: 'Nombre de terrain',
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        nombre_terrain = int.parse(value);
                      },
                    ),
                    TextFormField(
                      controller: _controller5,
                      cursorColor: Colors.black54,
                      style: TextStyle(
                          color: Colors.black54,
                          decorationColor: Colors.black54),
                      decoration: const InputDecoration(
                        hintText: 'Nature du sol',
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        sol = value;
                      },
                    ),
                    TextFormField(
                      controller: _controller6,
                      cursorColor: Colors.black54,
                      style: TextStyle(
                          color: Colors.black54,
                          decorationColor: Colors.black54),
                      decoration: const InputDecoration(
                        hintText: 'Horaire Ouverture',
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        ouverture = value;
                      },
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          if (image.length < 4) {
                            _choisirimage(context);
                          } else {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                                content: new Text(
                                    'Tu ne peux pas ajouter plus de 4 photos')));
                          }
                        },
                        textColor: Colors.black54,
                        padding: const EdgeInsets.all(0.0),
                        child: Text('Ajouter une photo',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    afficherimage
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: image.length,
                            itemBuilder: (context, i) {
                              return Image.file(image[i]);
                            })
                        : Container(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                         Navigator.pushNamedAndRemoveUntil(
                    context, '/Profil', (Route<dynamic> route) => false);
                              //    await ScopedModel.of<GameModel>(context).Ajout_match( lieuchoisi , _date , _time , nombre_jo,pseudo);
                              ScopedModel.of<TerrainModel>(context)
                                  .AjouterTerrain(
                                      nom,
                                      adresse,
                                      ville,
                                      nombre_terrain,
                                      base64Image[0],
                                      base64Image[1],
                                      base64Image[2],
                                      base64Image[3],
                                      sol,
                                      ouverture);

                              ScopedModel.of<GameModel>(context).Match();
                              setState(() {
                                _controller1.clear();
                                _controller2.clear();
                                _controller3.clear();
                                _controller4.clear();
                                _controller5.clear();
                                _controller6.clear();

                                image = null;
                                base64Image.clear();
                                nom = "";
                                adresse = "";
                                ville = "";
                                nombre_terrain = null;
                                sol = " ";
                                ouverture = " ";
                              });
                              Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Text('Terrain Proposé')));
                            }
                          },
                          child: Text('Proposer'),
                        ),
                      ),
                    ),
                    Center(
                        child: Text(
                            "Ton terrain sera rajouter à la liste après validation par notre équipe",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black54,
                              decorationColor: Colors.black54,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.5,
                            )))
                  ],
                ),
              ));
        }));
  }
}
