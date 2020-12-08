import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/Model_img.dart';

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
  List terrain = [];
  bool init = true;
  bool afficher = true;

  List<Asset> images = List<Asset>();
  String strinError = 'No Error Dectected';

  List base64Image = [];
  String lien1 = "";
  String lien2 = "";
  String lien3 = "";
  String lien4 = "";
  Widget build(BuildContext context) {
    envoieImage(String idlieu, String nomlieu) async {
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

      Response response = await post(url, body: json);
      String body = response.body;
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
        strinError = error;
      });
      await envoieImage(idterrain, nomlieu);

      Navigator.pushNamedAndRemoveUntil(
          context, '/Profil', (Route<dynamic> route) => false);
    }

    supprimerLieu(String id) async {
      var url = 'http://51.210.103.151/post_sup_terrain.php';
      String json = '{"id":"$id"}';
      await post(url, body: json);
      return " fin de fonction";
    }

    if (init) {
      setState(() {
        // ignore: unnecessary_statements
        terrain;
      });
      init = false;
    }

    terrainre(String terrainre) async {
      List contruction = [];
      await ScopedModel.of<TerrainModel>(context).terrainDev();
      terrain.clear();
      if (terrainre.isEmpty) {
        // quand l'utilisateur viens d'appuyer mais qu'il n'a rien écrit on passe ici et on affiche tous
        terrain = [];
      } else {
        // on vas regarder mot pare mot si on a des lettre on commun avec la recherche
        int plusG = 0;
        for (var i = 0;
            i < ScopedModel.of<TerrainModel>(context).tailleTerrainDev;
            i++) {
          int nombre = 0;
          nombre = comparestring(
              terrainre.toUpperCase(),
              ScopedModel.of<TerrainModel>(context)
                  .inDataTerrainDev[i]['ville']
                  .toUpperCase());
          if (nombre > 0 && nombre > (plusG - 2)) {
            plusG = nombre;
            // ici le lieu doit être affiche il vas dans construction
            Map tkt = {
              'contruiction':
                  ScopedModel.of<TerrainModel>(context).inDataTerrainDev[i],
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
        // ignore: unnecessary_statements
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
                style: Theme.of(context).textTheme.headline3,
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
                                                  terrain[i]['auto'] == '0'
                                                      ? Text("Pas afficher",
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4)
                                                      : Text("Afficher",
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4),
                                                  ScopedModelDescendant<
                                                          ImgModel>(
                                                      builder: (context, child,
                                                          img) {
                                                    int inNombreTour = 0;

                                                    while (img.inTailleImg >
                                                        inNombreTour) {
                                                      if (terrain[i]['id'] ==
                                                          img.vaDataImg[
                                                                  inNombreTour]
                                                              ["id_lieu"]) {
                                                        if (lien1 == "") {
                                                          lien1 = img.vaDataImg[
                                                                  inNombreTour]
                                                              ["lien"];
                                                        } else if (lien2 ==
                                                            "") {
                                                          lien2 = img.vaDataImg[
                                                                  inNombreTour]
                                                              ["lien"];
                                                        } else if (lien3 ==
                                                            "") {
                                                          lien3 = img.vaDataImg[
                                                                  inNombreTour]
                                                              ["lien"];
                                                        } else if (lien4 ==
                                                            "") {
                                                          lien4 = img.vaDataImg[
                                                                  inNombreTour]
                                                              ["lien"];
                                                        }
                                                      }
                                                      inNombreTour++;
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
                                                                return Container();
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
                                                                              child: GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: PhotoView(
                                                                                    imageProvider: NetworkImage(image),
                                                                                  )));
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
                                                                      .headline3),
                                                              Text(
                                                                  terrain[i][
                                                                      'adresse'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  terrain[i]
                                                                      ['ville'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  terrain[i][
                                                                          'nom_t'] +
                                                                      " terrain(s) disponible(s)",
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  terrain[i]
                                                                      ['sol'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  terrain[i][
                                                                      'ouverture'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  terrain[i][
                                                                      'commentaire'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
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
                                                                              .headline1),
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
                                                                                supprimerLieu(terrain[i]['id']);
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
                                                                  .headline3),
                                                    ),
                                                  ),
                                                  // Center(
                                                  //   child: RaisedButton(
                                                  //       child: Text(
                                                  //           "Ajouter des photos"),
                                                  //       onPressed: () {
                                                  //         loadAssets(
                                                  //             terrain[i]['id'],
                                                  //             terrain[i]
                                                  //                 ['nom']);
                                                  //       }),
                                                  // ),
                                                  terrain[i]['auto'] == '0'
                                                      ? RaisedButton(
                                                          onPressed: () async {
                                                            String idterrain =
                                                                terrain[i]
                                                                    ['id'];
                                                            var url =
                                                                'http://51.210.103.151/post_modif_auto_terrain.php';
                                                            String json =
                                                                '{"id":"$idterrain","auto":"1"}'; // make POST request
                                                            await post(url,
                                                                body: json);
                                                            Navigator.pushNamedAndRemoveUntil(
                                                                context,
                                                                '/lieuDev',
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false);
                                                          },
                                                          child: Text(
                                                              "Afficher",
                                                              softWrap: true,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline3))
                                                      : RaisedButton(
                                                          onPressed: () async {
                                                            String idterrain =
                                                                terrain[i]
                                                                    ['id'];
                                                            var url =
                                                                'http://51.210.103.151/post_modif_auto_terrain.php';
                                                            String json =
                                                                '{"id":"$idterrain","auto":"0"}'; // make POST request

                                                            await post(url,
                                                                body: json);
                                                            Navigator.pushNamedAndRemoveUntil(
                                                                context,
                                                                '/lieuDev',
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false);
                                                          },
                                                          child: Text(
                                                              "Pas afficher",
                                                              softWrap: true,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline3))
                                                ]))),
                                  );
                                });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 20,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      terrain[i]['nom'] +
                                          " (" +
                                          terrain[i]['ville'] +
                                          ')',
                                      softWrap: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3),
                                  terrain[i]['auto'] == '0'
                                      ? Icon(
                                          Icons.clear,
                                          color: Colors.red,
                                          size: 20.0,
                                        )
                                      : Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 20.0,
                                        ),
                                ],
                              ),
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
