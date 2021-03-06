import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:location/location.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import '../footer.dart';
import '../main.dart';
import '../models/Model_match.dart';
import '../models/Model_terrain.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';

String nom;
String adresse;
String ville;
int inNombreTerrain;
String sol = " ";
String ouverture = " ";
String urlgoogle = "non ";
String urlwaze = "non ";

int n = 0;
var _controller1 = TextEditingController();
var _controller2 = TextEditingController();
var _controller3 = TextEditingController();
var _controller4 = TextEditingController();
var _controller5 = TextEditingController();
var _controller6 = TextEditingController();

class AjoutTerrain extends StatefulWidget {
  @override
  _AjoutTerrainState createState() => _AjoutTerrainState();
}

class _AjoutTerrainState extends State<AjoutTerrain> {
  final _formKey = GlobalKey<FormState>();

  List<Asset> images = List<Asset>();
  String strinError = 'No Error Dectected';

  List base64Image = [];
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      strinError = error;
    });
  }

  localisation() async {
    var location = new Location();
    var currentLocation = await location.getLocation();

    urlgoogle = "https://www.google.fr/maps/dir//" +
        currentLocation.latitude.toString() +
        "," +
        currentLocation.longitude.toString();
    urlwaze = "https://www.waze.com/fr/livemap/directions?latlng=" +
        currentLocation.latitude.toString() +
        "%2C" +
        currentLocation.longitude.toString() +
        "&utm_campaign=waze_website&utm_expid=.K6QI8s_pTz6FfRdYRPpI3A.0&utm_referrer=&utm_source=waze_website";
    final coordinates =
        new Coordinates(currentLocation.latitude, currentLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    adresse = first.featureName + " " + first.thoroughfare;
    ville = first.locality + " " + first.postalCode;
    setState(() {
      _controller2 = TextEditingController(text: adresse);
      _controller3 = TextEditingController(text: ville);
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Ajouter un playground"),
          backgroundColor: Colors.indigo,
        ),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        // backgroundColor: Colors.black,

        backgroundColor: back,
        body: CustomScrollView(slivers: [
          SliverFillRemaining(
            child: ScopedModelDescendant<GameModel>(
                builder: (context, child, model) {
              return Column(
                children: <Widget>[
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            autocorrect: true,
                            controller: _controller1,
                            cursorColor: Colors.black,
                            style: Theme.of(context).textTheme.headline3,
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
                            style: Theme.of(context).textTheme.headline3,
                            controller: _controller2,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              filled: false,
                              fillColor: Colors.black,
                              hintText: 'Adresse',
                              hintStyle: TextStyle(color: Colors.black),
                              suffixIcon: GestureDetector(
                                onTap: () async {
                                  localisation();
                                  return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: SizedBox(
                                            child: CircularProgressIndicator(),
                                            width: 60,
                                            height: 60,
                                          ),
                                        );
                                      });
                                },
                                child: Icon(Icons.gps_fixed),
                              ),
                            ),
                            onChanged: (value) {
                              adresse = value;
                            },
                          ),
                          TextFormField(
                            autocorrect: true,
                            controller: _controller3,
                            cursorColor: Colors.black,
                            style: Theme.of(context).textTheme.headline3,
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
                            style: Theme.of(context).textTheme.headline3,
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
                              inNombreTerrain = int.parse(value);
                            },
                          ),
                          TextFormField(
                            autocorrect: true,
                            controller: _controller5,
                            cursorColor: Colors.black,
                            style: Theme.of(context).textTheme.headline3,
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
                            style: Theme.of(context).textTheme.headline3,
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
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: RaisedButton(
                                onPressed: () async {
                                  await ScopedModel.of<TerrainModel>(context)
                                      .verificationNom(nom);
                                  if (ScopedModel.of<TerrainModel>(context)
                                          .nomVerifier ==
                                      true) {
                                    if (_formKey.currentState.validate()) {
                                      for (var i = 0; i < images.length; i++) {
                                        ByteData test =
                                            await images[i].getByteData();
                                        Uint8List audioUint8List = test.buffer
                                            .asUint8List(test.offsetInBytes,
                                                test.lengthInBytes);
                                        List<int> audioListInt = audioUint8List
                                            .map((eachUint8) =>
                                                eachUint8.toInt())
                                            .toList();

                                        List<int> imageBytescompress =
                                            await FlutterImageCompress
                                                .compressWithList(
                                          audioListInt,
                                          minHeight: 1920,
                                          minWidth: 1080,
                                          quality: 96,
                                          rotate: 0,
                                        );

                                        base64Image.add(
                                            base64Encode(imageBytescompress));
                                      }

                                      base64Image.add("null");
                                      base64Image.add("null");
                                      base64Image.add("null");
                                      base64Image.add("null");
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/Profil',
                                          (Route<dynamic> route) => false);
                                      ScopedModel.of<TerrainModel>(context)
                                          .ajouterTerrain(
                                              nom,
                                              adresse,
                                              ville,
                                              inNombreTerrain,
                                              base64Image[0],
                                              base64Image[1],
                                              base64Image[2],
                                              base64Image[3],
                                              sol,
                                              ouverture,
                                              urlgoogle,
                                              urlwaze);
                                      ScopedModel.of<GameModel>(context)
                                          .match();
                                      Scaffold.of(context)
                                          .showSnackBar(new SnackBar(
                                              content: new Text(
                                        'Terrain Proposé',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      )));
                                    }
                                  } else {
                                    // le nom est déja pris
                                    Scaffold.of(context).showSnackBar(new SnackBar(
                                        content: new Text(
                                            'Ce nom est déja pris par un autre terrain')));
                                  }
                                },
                                child: Text(
                                  'Proposer',
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                            ),
                          ),
                          Center(
                              child: Text(
                            "Ton terrain sera rajouter à la liste après validation par notre équipe",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline3,
                          )),
                        ],
                      )),
                  RaisedButton(
                    child: Text("Ajouter des photos"),
                    onPressed: loadAssets,
                  ),
                  Expanded(
                    child: buildGridView(),
                  )
                ],
              );
            }),
          ),
        ]));
  }
}
