import 'package:flutter/material.dart';

class Affplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                                                    int inNombreTour = 0;
                                                    String lien1 = "";
                                                    String lien2 = "";
                                                    String lien3 = "";
                                                    String lien4 = "";
                                                    while (img.inTailleImg >
                                                        inNombreTour) {
                                                      if (lisTerrain[i]['id'] ==
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
                                                                  lisTerrain[i]
                                                                      ['nom'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  lisTerrain[i][
                                                                      'adresse'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  lisTerrain[i]
                                                                      ['ville'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  lisTerrain[i][
                                                                          'nom_t'] +
                                                                      " terrain(s) disponible(s)",
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  lisTerrain[i]
                                                                      ['sol'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  lisTerrain[i][
                                                                      'ouverture'],
                                                                  softWrap:
                                                                      true,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline3),
                                                              Text(
                                                                  lisTerrain[i][
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
                                                      onPressed: () async {
                                                        return showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                  title: Text(
                                                                      'Ouvrir avec'),
                                                                  content:
                                                                      SingleChildScrollView(
                                                                          child:
                                                                              ListBody(children: <Widget>[
                                                                    GestureDetector(
                                                                      child: Text(
                                                                          "Google map"),
                                                                      onTap:
                                                                          () async {
                                                                        String
                                                                            value =
                                                                            lisTerrain[i]['url'].toString();
                                                                        //const url = const value;
                                                                        if (await canLaunch(
                                                                            value)) {
                                                                          await launch(
                                                                              value);
                                                                        }
                                                                      },
                                                                    ),
                                                                    Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8.0)),
                                                                    GestureDetector(
                                                                      child: Text(
                                                                          "Waze"),
                                                                      onTap:
                                                                          () async {
                                                                        String
                                                                            value =
                                                                            lisTerrain[i]['urlwaze'].toString();
                                                                        //const url = const value;
                                                                        if (await canLaunch(
                                                                            value)) {
                                                                          await launch(
                                                                              value);
                                                                        }
                                                                      },
                                                                    )
                                                                  ])));
                                                            });
                                                      },
                                                      child: Text('Y aller'),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: RaisedButton(
                                                      onPressed: () async {
                                                        ScopedModel.of<GameModel>(
                                                                    context)
                                                                .terrainrencontre =
                                                            lisTerrain[i]['nom']
                                                                .toString();
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/TerrainRencontre');
                                                      },
                                                      child: Text(
                                                          'Rencontre à venir'),
                                                    ),
                                                  ),
                                                ]))),
                                  );
                                });
}
}