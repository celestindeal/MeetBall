import 'dart:convert';
import 'dart:typed_data';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';
import 'package:meetballl/Ajout_terrain.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:meetballl/modif.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/Model_img.dart';
import 'models/Model_match.dart';

List lieupro = [];

class LieuDev extends StatefulWidget {
  @override
  _LieuDevState createState() => _LieuDevState();
}

double lat2 = 0;
double lon2 = 0;
double lon1;
double lat1;
double ditanceCourt = 1000000;

class _LieuDevState extends State<LieuDev> {
  @override
  List terrain = [];
  bool init = true;
  bool afficher = true;

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  List base64Image = [];
  String lien1 = "";
  String lien2 = "";
  String lien3 = "";
  String lien4 = "";
  Widget build(BuildContext context) {
    envoie_image(String idlieu, String nomlieu) async {
      for (var i = 0; i < images.length; i++) {
        ByteData test = await images[i].getByteData();
        Uint8List audioUint8List =
            test.buffer.asUint8List(test.offsetInBytes, test.lengthInBytes);
        List<int> audioListInt =
            audioUint8List.map((eachUint8) => eachUint8.toInt()).toList();

        List<int> imageBytescompress =
            await FlutterImageCompress.compressWithList(
          audioListInt,
          minHeight: 1920,
          minWidth: 1080,
          quality: 96,
          rotate: 0,
        );

        base64Image.add(base64Encode(imageBytescompress));
      }

      base64Image.add("null");
      base64Image.add("null");
      base64Image.add("null");
      base64Image.add("null");
      String image1 = base64Image[0];
      String image2 = base64Image[1];
      String image3 = base64Image[2];
      String image4 = base64Image[3];

      var url = 'http://51.210.103.151/post_terrain_modif.php';
      String json =
          '{"nom":"$nomlieu","id":"$idlieu","image1":"$image1","image2":"$image2","image3":"$image3","image4":"$image4"}'; // make POST request
      print(json);
      Response response = await post(url, body: json);
      String body = response.body;
      print(body);
      return body;
    }

    Future<void> loadAssets(String idterrain, String nomlieu) async {
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
        _error = error;
      });
     await  envoie_image(idterrain, nomlieu);
    

      Navigator.pushNamedAndRemoveUntil(
          context, '/Profil', (Route<dynamic> route) => false);
    }

    supprimer_lieu(String id) async {
      var url = 'http://51.210.103.151/post_sup_terrain.php';
      String json = '{"id":"$id"}';
      Response response = await post(url, body: json);
      print(jsonDecode(response.body));
      return " fin de fonction";
    }

    if (init) {
      setState(() {
        terrain;
      });
      init = false;
    }

    terrainre(String terrainre) async {
      List contruction = [];
      await ScopedModel.of<TerrainModel>(context).TerrainDev();
      terrain.clear();
      if (terrainre.isEmpty) {
        // quand l'utilisateur viens d'appuyer mais qu'il n'a rien écrit on passe ici et on affiche tous
        terrain = [];
      } else {
        // on vas regarder mot pare mot si on a des lettre on commun avec la recherche
        int plusG = 0;
        for (var i = 0;
            i < ScopedModel.of<TerrainModel>(context).taille_terrainDev;
            i++) {
          int nombre = 0;
          nombre = comparestring(
              terrainre.toUpperCase(),
              ScopedModel.of<TerrainModel>(context)
                  .data_terrainDev[i]['ville']
                  .toUpperCase());
          if (nombre > 0 && nombre > (plusG - 2)) {
            plusG = nombre;
            // ici le lieu doit être affiche il vas dans construction
            Map tkt = {
              'contruiction':
                  ScopedModel.of<TerrainModel>(context).data_terrainDev[i],
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
      setState(() {
        terrain;
      });
      afficher = true;
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Rechercher un playground"),
          backgroundColor: Colors.indigo,
        ),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        backgroundColor: back,
        body: SingleChildScrollView(
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
                onChanged: (value) {
                  setState(() {
                    afficher = false;
                  });
                  terrainre(value);
                },
              ),
              Container(
                height: 30,
              ),
              afficher
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: terrain.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Center(
                                        child: Container(
                                            padding: const EdgeInsets.all(20),
                                            margin: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: Colors.grey,
                                            ),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  ScopedModelDescendant<
                                                          ImgModel>(
                                                      builder: (context, child,
                                                          img) {
                                                    int nombre_tour = 0;

                                                    while (img.taille_img >
                                                        nombre_tour) {
                                                      if (terrain[i]['id'] ==
                                                          img.data_img[
                                                                  nombre_tour]
                                                              ["id_lieu"]) {
                                                        if (lien1 == "") {
                                                          lien1 = img.data_img[
                                                                  nombre_tour]
                                                              ["lien"];
                                                        } else if (lien2 ==
                                                            "") {
                                                          lien2 = img.data_img[
                                                                  nombre_tour]
                                                              ["lien"];
                                                        } else if (lien3 ==
                                                            "") {
                                                          lien3 = img.data_img[
                                                                  nombre_tour]
                                                              ["lien"];
                                                        } else if (lien4 ==
                                                            "") {
                                                          lien4 = img.data_img[
                                                                  nombre_tour]
                                                              ["lien"];
                                                        }
                                                      }
                                                      nombre_tour++;
                                                    }
                                                    if (lien1 == "") {
                                                      return Container();
                                                    } else {
                                                      return Container(
                                                        color:
                                                            Colors.transparent,
                                                        child: SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              1.5,
                                                          child:
                                                              PageView.builder(
                                                            controller:
                                                                PageController(
                                                                    viewportFraction:
                                                                        1),
                                                            itemCount: 4,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int itemIndex) {
                                                              String image = "";
                                                              switch (
                                                                  itemIndex) {
                                                                case 0:
                                                                  {
                                                                    image =
                                                                        lien1;
                                                                  }
                                                                  break;
                                                                case 1:
                                                                  {
                                                                    image =
                                                                        lien2;
                                                                  }
                                                                  break;
                                                                case 2:
                                                                  {
                                                                    image =
                                                                        lien3;
                                                                  }
                                                                  break;
                                                                case 3:
                                                                  {
                                                                    image =
                                                                        lien4;
                                                                  }
                                                                  break;
                                                                default:
                                                              }
                                                              if (image == "") {
                                                                Container();
                                                              } else {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    return showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return Container(
                                                                              child: PhotoView(
                                                                            imageProvider:
                                                                                NetworkImage(image),
                                                                          ));
                                                                        });
                                                                  },
                                                                  child: Image
                                                                      .network(
                                                                    image,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                  terrain[i]
                                                                      ['nom'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                              Text(
                                                                  terrain[i][
                                                                      'adresse'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                              Text(
                                                                  terrain[i]
                                                                      ['ville'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                              Text(
                                                                  terrain[i][
                                                                          'nom_t'] +
                                                                      " terrain(s) disponible(s)",
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                              Text(
                                                                  terrain[i]
                                                                      ['sol'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                              Text(
                                                                  terrain[i][
                                                                      'ouverture'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                              Text(
                                                                  terrain[i][
                                                                      'commentaire'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .display3),
                                                            ]),
                                                      ]),
                                                  Center(
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Center(
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .white,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                          'Supprimer le terrain ' +
                                                                              terrain[i][
                                                                                  'nom'],
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .display1),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: <
                                                                            Widget>[
                                                                          RaisedButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Text('non')),
                                                                          RaisedButton(
                                                                              onPressed: () async {
                                                                                Navigator.pushNamedAndRemoveUntil(context, '/lieuDev', (Route<dynamic> route) => false);
                                                                                supprimer_lieu(terrain[i]['id']);
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
                                                      child: Text(
                                                          'suprimer le terrain',
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display3),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: RaisedButton(
                                                        child: Text(
                                                            "Ajouter des photos"),
                                                        onPressed: () {
                                                          loadAssets(
                                                              terrain[i]['id'],
                                                              terrain[i]
                                                                  ['nom']);
                                                        }),
                                                  ),
                                                ]))),
                                  );
                                });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 20,
                            child: Center(
                              child: Text(
                                  terrain[i]['nom'] +
                                      " (" +
                                      terrain[i]['ville'] +
                                      ')',
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.display3),
                            ),
                          ),
                        );
                      })
                  : CircularProgressIndicator(),
            ],
          ),
        ));
  }
}
