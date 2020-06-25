import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
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
                    print("test");
                    setState(() {
                      image;
                      afficherimage = true;
                    });
                    print("test");
                    List<int> imageBytes =
                        image[image.length - 1].readAsBytesSync();
                    print("test");
                    base64Image.add(base64Encode(imageBytes));
                    print("test");
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("caméra"),
                  onTap: () async {
                    image.add(await ImagePicker.pickImage(
                        source: ImageSource.camera));
                    print("test");
                    setState(() {
                      image;
                      afficherimage = true;
                    });
                    print("test");
                    List<int> imageBytes =
                        image[image.length - 1].readAsBytesSync();
                    print("test");
                    base64Image.add(base64Encode(imageBytes));
                    print("test");
                    Navigator.of(context).pop();
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
