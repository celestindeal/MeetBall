import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'accueil.dart';
import 'appBar.dart';
import 'drawer.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';
import 'models/Model_match.dart';

var now = new DateTime.now();
bool rencontre = true;

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    
    return ScopedModelDescendant<LoginModel>(builder: (context, child, model) {
      return Container(
        child: model.loging == false
            ? Scaffold(
                // appBar: headerNav(context),
                persistentFooterButtons: <Widget>[
                    // AppB(),
                    Footer(),
                  ],
                drawer: Darwer(),
                // backgroundColor: color1,
                body: Center(
                  child: CircularProgressIndicator(),
                ))
            : model.retour_Profil
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Center(
                            child: model.faux_pseudo
                                ? Text("ton email est faux",
                                    style: Theme.of(context).textTheme.display1)
                                : Text("ton password est faux",
                                    style:
                                        Theme.of(context).textTheme.display1)),
                        Center(
                            child: RaisedButton(
                          onPressed: () {
                            ScopedModel.of<LoginModel>(context).Deconnection();
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (Route<dynamic> route) => false);
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF0D47A1),
                                  Color(0xFF1976D2),
                                  Color(0xFF42A5F5),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Text('nouveaux test',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ))
                      ])
                : Presentation(),
      );
    });
  }
}

class Presentation extends StatefulWidget {
  @override
  _PresentationState createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {
  File image;

  String base64Image = "";

  bool affImage = true;

  @override
  Widget build(BuildContext context) {
    mis_ajour() {
      affImage = false;
    }
    

    Future<void> _choisirimage(BuildContext context) {
      bool aff = true;
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('choisi entre'),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return aff
                      ? SingleChildScrollView(
                          child: ListBody(children: <Widget>[
                          GestureDetector(
                            child: Text("galerie"),
                            onTap: () async {
                              setState(() {
                                aff = false;
                              });

                              image = await ImagePicker.pickImage(
                                  source: ImageSource.gallery);
                                  Navigator.of(context).pop();
                              List<int> imageBytes = image.readAsBytesSync();
                              base64Image = await base64Encode(imageBytes);
                              await ScopedModel.of<LoginModel>(context)
                                  .ChangeImage(base64Image);
                              
                              mis_ajour();
                            },
                          ),
                          Padding(padding: EdgeInsets.all(8.0)),
                          GestureDetector(
                            child: Text("caméra"),
                            onTap: () async {
                              setState(() {
                                aff = false;
                              });
                              image = await ImagePicker.pickImage(
                                  source: ImageSource.camera);
                                  Navigator.of(context).pop();
                              List<int> imageBytes = image.readAsBytesSync();
                              base64Image = base64Encode(imageBytes);
                              await ScopedModel.of<LoginModel>(context)
                                  .ChangeImage(base64Image);
                              
                              mis_ajour();
                            },
                          )
                        ]))
                      : Center(
                          child: Container(
                            height: 100,
                            child: CircularProgressIndicator(),
                          ),
                        );
                }));
          });
    }

    return Scaffold(
        appBar: headerNav(context),
        drawer: Darwer(),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        // backgroundColor: color1,
        body: SingleChildScrollView(child:
            ScopedModelDescendant<LoginModel>(builder: (context, child, model) {
          if (model.participation.length == 0) {
            rencontre = false;
          } else {
            rencontre = true;
          }
// calcule de l'age
          var ms = (new DateTime.now()).millisecondsSinceEpoch;
          String ok = "}" + model.age + "/";
          int ans = int.parse(ok.split('}')[1].split('-')[0]);
          int mois = int.parse(ok.split('-')[1].split('-')[0]);
          int jour = int.parse(ok.split('-')[1].split('/')[0]);
          var mst = new DateTime.utc(ans, mois, jour, 20, 18, 04)
              .millisecondsSinceEpoch;
          int ageAnne = ((ms - mst) / (365 * 24 * 3600 * 1000)).toInt();
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return 
                              affImage? Container(
                                      child: PhotoView(
                                imageProvider: NetworkImage(model.img),
                              ))
                              :
                              Container(
                                      child: PhotoView(
                                imageProvider: FileImage(image),
                              ));
                            });
                      },
                      onLongPress: () {
                        _choisirimage(context);
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height / 3,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey,
                          ),
                          child:
                              affImage // je ne sais pas recharger Image.network alors j'affiche l'image file a la place
                                  ? Image.network(
                                      model.img,
                                      excludeFromSemantics: true,
                                    )
                                  : Image.file(image)),
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                model.affmodif = true;
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/modif', (Route<dynamic> route) => false);
                              },
                              child: Container(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(model.pseudo,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                      Text(model.email,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                      Text(model.password,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                      Text(ageAnne.toString() + " ans",
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                      Text(model.club,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                      Text(model.niveau,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                    ]),
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
                Text("Description",
                    softWrap: true,
                    style: Theme.of(context).textTheme.display2),
                Text(model.description,
                    softWrap: true,
                    style: Theme.of(context).textTheme.display3),
                Center(
                    child: Text("Rencontre à venir",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: Theme.of(context).textTheme.display4)),
                rencontre
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: model.participation.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () async {
                              ScopedModel.of<GameModel>(context).lieu =
                                  model.participation[i]['lieu'];
                              ScopedModel.of<GameModel>(context).id_rencontre =
                                  model.participation[i]['id_rencontre'];
                              ScopedModel.of<ImgModel>(context).Img();
                              ScopedModel.of<GameModel>(context).Terrain();
                              ScopedModel.of<GameModel>(context).Commentaire();
                              await ScopedModel.of<LoginModel>(context)
                                  .Personne_propose(
                                      model.participation[i]['pseudo']);
                              Navigator.pushNamed(
                                  context, '/Profil_renctontre');
                            },
                            child: Center(
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.grey,
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                          "Cette rencontre est prevue ",
                                                          textAlign:
                                                              TextAlign.center,
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2),
                                                      Text(
                                                          "le " +
                                                              model.participation[
                                                                  i]['jour'] +
                                                              " à " +
                                                              model.participation[
                                                                  i]['heure'],
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2),
                                                      Text(
                                                          "Il y a " +
                                                              model.participation[
                                                                  i]['nom_j'] +
                                                              " personne(s) qui seront là",
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2),
                                                      Text(
                                                          "Vous avez invité " +
                                                              model.participation[
                                                                      i]
                                                                  ['inviter'] +
                                                              " personne(s)",
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2),
                                                    ]),
                                              ]),
                                          RaisedButton(
                                              child: Text("annuler"),
                                              onPressed: () async {
                                                await ScopedModel.of<GameModel>(
                                                        context)
                                                    .Sup_participation(
                                                        model.participation[i]
                                                            ['inviter'],
                                                        model.participation[i]
                                                            ['id'],
                                                        model.participation[i]
                                                            ['id_rencontre']);
                                                ScopedModel.of<LoginModel>(
                                                        context)
                                                    .Participation();
                                              })
                                        ]))),
                          );
                        })
                    : Text("tu n'a pas de rencontre de prevue"),
              ]);
        })));
  }
}
