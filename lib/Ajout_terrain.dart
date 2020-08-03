import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_match.dart';
import 'models/Model_terrain.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
    title:  Text('choisi entre'),
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

              List<int> imageBytescompress =await FlutterImageCompress.compressWithList(
            imageBytes,
            minHeight: 1920,
            minWidth: 1080,
            quality: 96,
            rotate: 0,
          );

                    base64Image.add(base64Encode(imageBytescompress));
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

              List<int> imageBytescompress =await FlutterImageCompress.compressWithList(
            imageBytes,
            minHeight: 1920,
            minWidth: 1080,
            quality: 96,
            rotate: 0,
          );

                    base64Image.add(base64Encode(imageBytescompress));
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
     centerTitle: true,
    title:  Text("Ajouter un playground"),
    backgroundColor: Colors.indigo,
   
    
  ),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        // backgroundColor: Colors.black,

        backgroundColor: back,
        body: 
            ScopedModelDescendant<GameModel>(builder: (context, child, model) {
          return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     TextFormField(
                      autocorrect: true,
                      controller: _controller1,
                      cursorColor: Colors.black,
                      style: Theme.of(context)
                                                      .textTheme
                                                      .display3,
                      decoration: const InputDecoration(
                        hintText: 'Nom',
                        hintStyle: TextStyle(color: Colors.black),
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
                      autocorrect: true,
                      style: Theme.of(context)
                                                      .textTheme
                                                      .display3,
                      controller: _controller2,
                      cursorColor: Colors.black,
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
                      autocorrect: true,
                      controller: _controller3,
                      cursorColor: Colors.black,
                      style: Theme.of(context)
                                                      .textTheme
                                                      .display3,
                      decoration: const InputDecoration(
                        hintText: 'Ville',
                        hintStyle: TextStyle(color: Colors.black),
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
                      autocorrect: true,
                      controller: _controller4,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      style: Theme.of(context)
                                                      .textTheme
                                                      .display3,
                      decoration: const InputDecoration(
                        hintText: 'Nombre de terrain',
                        hintStyle: TextStyle(color: Colors.black),
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
                      autocorrect: true,
                      controller: _controller5,
                      cursorColor: Colors.black,
                      style: Theme.of(context)
                                                      .textTheme
                                                      .display3,
                      decoration: const InputDecoration(
                        hintText: 'Nature du sol',
                        hintStyle: TextStyle(color: Colors.black),
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
                      autocorrect: true,
                      controller: _controller6,
                      cursorColor: Colors.black,
                      style: Theme.of(context)
                                                      .textTheme
                                                      .display3,
                      decoration: const InputDecoration(
                        hintText: 'Horaire Ouverture',
                        hintStyle: TextStyle(color: Colors.black),
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
                        textColor: Colors.black,
                        padding: const EdgeInsets.all(0.0),
                        child: Text('Ajouter une photo',
                            style: Theme.of(context)
                                                      .textTheme
                                                      .display3,),
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
                        base64Image.add("null");
                        base64Image.add("null");
                        base64Image.add("null");
                        base64Image.add("null");
                         Navigator.pushNamedAndRemoveUntil(
                    context, '/Profil', (Route<dynamic> route) => false);
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
                              Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Text('Terrain Proposé',style: Theme.of(context)
                                                      .textTheme
                                                      .display3,)));
                            }
                          },
                          child: Text('Proposer',style: Theme.of(context)
                                                      .textTheme
                                                      .display3,),
                        ),
                      ),
                    ),
                    Center(
                        child: Text(
                            "Ton terrain sera rajouter à la liste après validation par notre équipe",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                                      .textTheme
                                                      .display3,))
                  ],
                ),
              ));
        }));
  }
}
