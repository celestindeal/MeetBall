import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:meetballl/appBar.dart';
import 'package:meetballl/drawer.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:meetballl/test.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

double ditanceCourt = 1000000;
String tkt = "location";
List lieupro = [];

class TerrainPro extends StatefulWidget {
  @override
  _TerrainProState createState() => _TerrainProState();
}

double lat2 = 0;
double lon2 = 0;
double lon1;
double lat1;

class _TerrainProState extends State<TerrainPro> {
  @override
  Widget build(BuildContext context) {
    terrain() async {
      List contruction = [];
      var location = new Location();
      var currentLocation = await location.getLocation();
      lat1 = currentLocation.latitude;
      lon1 = currentLocation.longitude;

      for (var i = 0;
          i < ScopedModel.of<TerrainModel>(context).taille_terrain;
          i++) {
        String lieu = "";
        lieu = ScopedModel.of<TerrainModel>(context)
            .data_terrain[i]['url']
            .toString();
        if (await canLaunch(lieu)) {
          String valueString =
              "/" + lieu.toString().split('@')[1].split('/')[0];
          int nombrecar = valueString.length;
          String valuelieu = valueString.substring(0, nombrecar - 1);
          lat2 = double.parse(valuelieu.toString().split('/')[1].split(',')[0]);
          lon2 = double.parse(valuelieu.toString().split(',')[1]);
          //double x = (lon2 - lon1) * cos(0.5 * (lat2 + lat1));
          //double y = lat2 - lat1;
          // double distance = 1.852 * 60 * sqrt((x * x + y * y));
          print(lon1);
          print(lat1);
          print(lon2);
          print(lat2);
          double distance = 6371 *
              acos((sin(lat1 * (pi / 180)) * sin(lat2 * (pi / 180))) +
                  (cos(lat1 * (pi / 180)) *
                      cos(lat2 * (pi / 180)) *
                      cos(lon1 * (pi / 180) - lon2 * (pi / 180))));
          print(distance);

          Map tkt = {
            'contruiction':
                ScopedModel.of<TerrainModel>(context).data_terrain[i],
            "distance": distance
          };
          contruction.add(tkt);
          print(ScopedModel.of<TerrainModel>(context).data_terrain[i]["nom"] +
              i.toString() +
              "distance " +
              distance.toString());
        }
      }
      print(contruction);
      int copie = contruction.length;
// objatif classer les lieu dans l'ordre
      for (var i = 0; i < copie; i++) {
        double nombreplus = 10000;
        int place;
        print("null");

        for (var n = 0; n < contruction.length; n++) {
          print('ok');
          if (contruction[n]['distance'] <= nombreplus) {
            print("valide");
            nombreplus = contruction[n]['distance'];
            print("valide");
            place = n;
            print("valide");
          }
        }
        lieupro.add(contruction[place]);
        contruction.removeAt(place);
      }
print(lieupro);
      return lieupro;
    }

    return Scaffold(
        appBar: headerNav(context),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        drawer: Darwer(),
        body: FutureBuilder<dynamic>(
          future: terrain(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return AffImage();
            } else {
              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
              );
            }
          },
        ));
  }
}

class AffImage extends StatefulWidget {
  @override
  _AffImageState createState() => _AffImageState();
}

class _AffImageState extends State<AffImage> {
  Widget build(BuildContext context) {
    return ListView.builder(
      
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, i) {
       return   Center(
              child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(" Vous être à " + lieupro[i]['distance'].toStringAsFixed(3).toString() + "Km", softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                        ScopedModelDescendant<ImgModel>(
                            builder: (context, child, img) {
                          int nombre_tour = 0;
                          String lien1 = "";
                          String lien2 = "";
                          String lien3 = "";
                          String lien4 = "";
                          while (img.taille_img > nombre_tour) {
                            if (lieupro[i]['contruiction']['id'] ==
                                img.data_img[nombre_tour]["id_lieu"]) {
                              if (lien1 == "") {
                                lien1 = img.data_img[nombre_tour]["lien"];
                              } else if (lien2 == "") {
                                lien2 = img.data_img[nombre_tour]["lien"];
                              } else if (lien3 == "") {
                                lien3 = img.data_img[nombre_tour]["lien"];
                              } else if (lien4 == "") {
                                lien4 = img.data_img[nombre_tour]["lien"];
                              }
                            }
                            nombre_tour++;
                          }
                          if (lien1 == "") {
                            return Container();
                          } else {
                            return Container(
                              color: Colors.transparent,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 2,
                                child: PageView.builder(
                                  controller:
                                      PageController(viewportFraction: 0.8),
                                  itemCount: 4,
                                  itemBuilder:
                                      (BuildContext context, int itemIndex) {
                                    String image = "";
                                    switch (itemIndex) {
                                      case 0:
                                        {
                                          image = lien1;
                                        }
                                        break;
                                      case 1:
                                        {
                                          image = lien2;
                                        }
                                        break;
                                      case 2:
                                        {
                                          image = lien3;
                                        }
                                        break;
                                      case 3:
                                        {
                                          image = lien4;
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
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                      child: PhotoView(
                                                    imageProvider:
                                                        NetworkImage(image),
                                                  ));
                                                });
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.transparent,
                                            child: Image.network(
                                              image,
                                            ),
                                          ));
                                    }
                                  },
                                ),
                              ),
                            );
                          }
                        }),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(lieupro[i]['contruiction']['nom'],
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                    Text(lieupro[i]['contruiction']['adresse'],
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                    Text(lieupro[i]['contruiction']['ville'],
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                    Text(
                                        lieupro[i]['contruiction']['nom_t'] +
                                            " terrain(s) disponible(s)",
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                    Text(lieupro[i]['contruiction']['sol'],
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                    Text(lieupro[i]['contruiction']['ouverture'],
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                  ]),
                            ]),
                        Center(
                          child: RaisedButton(
                            onPressed: () async {
                              String value = lieupro[0]['url'].toString();
                              //const url = const value;
                              if (await canLaunch(value)) {
                                await launch(value);
                              }
                            },
                            child: Text('Y aller'),
                          ),
                        ),
                      ])));
        });
  }
}
