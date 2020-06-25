import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appBar.dart';
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

  File image;
  String base64Image = "";
  bool afficher = false;

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
                      afficher = true;
                    });
                    List<int> imageBytes = image.readAsBytesSync();
                    base64Image = base64Encode(imageBytes);
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
                      afficher = true;
                    });
                    List<int> imageBytes = image.readAsBytesSync();
                    base64Image = base64Encode(imageBytes);
                  },
                )
              ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: headerNav(context),
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
                            print("calcul gpeerfv");
                            
                            var location = new Location();
                            var currentLocation = await location.getLocation();
                            adresse = currentLocation.latitude.toString();
                            ville = currentLocation.longitude.toString();
                            setState(() {
                              _controller2 =TextEditingController(text: adresse);
                              _controller3 =TextEditingController(text: ville);

                            });
print(ville);
print(adresse);
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
                        _choisirimage(context);
                      },
                      textColor: Colors.black54,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text('Ajouter une photo',
                            style: TextStyle(fontSize: 20)),
                      ),
                    )),
                    afficher
                        ? Column(
                            children: <Widget>[
                              Center(
                                  child: Container(
                                      child: Image.file(
                                image,
                                width: 400,
                                height: 400,
                              ))),
                              RaisedButton(
                                  child: Text("Annuler"),
                                  onPressed: () {
                                    setState(() {
                                      image = null;
                                      base64Image = "";
                                      afficher = false;
                                    });
                                  })
                            ],
                          )
                        : Center(
                            child: Container(
                            child: Text("Tu n'as pas choisi d'image"),
                          )),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              //    await ScopedModel.of<GameModel>(context).Ajout_match( lieuchoisi , _date , _time , nombre_jo,pseudo);
                              ScopedModel.of<TerrainModel>(context)
                                  .AjouterTerrain(
                                      nom,
                                      adresse,
                                      ville,
                                      nombre_terrain,
                                      base64Image,
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
                                base64Image = "";
                                afficher = false;
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
