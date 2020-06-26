import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'footer.dart';
import 'formulaire_inscription.dart';
import 'models/Model_co.dart';

String _date = "Date de naissance";
bool _passwordVisible = false;
String confirmation_password;
File image;
String base64Image = "";
bool afficher = false;
bool checkboxValue = false;

class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final _formKey = GlobalKey<FormState>();

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
      appBar: AppBar(
    title: Text("MeetBall"),
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        cursorColor: Colors.black54,
                        style: TextStyle(
                            color: Colors.white, decorationColor: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Pseudo',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Pseudo manquant ';
                          }
                          if (ScopedModel.of<LoginModel>(context)
                                  .pseudovalide ==
                              false) {
                            return 'Ce pseudo est déja pris';
                          }
                        },
                        onChanged: (value) {
                          pseudo = value;
                        },
                      ),

                      TextFormField(
                        cursorColor: Colors.black54,
                        style: TextStyle(
                            color: Colors.white, decorationColor: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Nom',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nom manquant ';
                          }
                        },
                        onChanged: (value) {
                          nom = value;
                        },
                      ),

                      TextFormField(
                        cursorColor: Colors.black54,
                        style: TextStyle(
                            color: Colors.white, decorationColor: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Prénom',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Prénom manquant ';
                          }
                        },
                        onChanged: (value) {
                          prenom = value;
                        },
                      ),
                      TextFormField(
                        cursorColor: Colors.black54,
                        style: TextStyle(
                            color: Colors.white, decorationColor: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Veuillez ajouter un email';
                          }
                          if (ScopedModel.of<LoginModel>(context).emailvalide ==
                              false) {
                            return 'Cette adresse email est déja pris';
                          }
                          return value.contains('@')
                              ? null
                              : "Cette adresse email n'est pas validé";
                        },
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      TextFormField(
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          hasFloatingPlaceholder: true,
                          filled: false,
                          fillColor: Colors.black,
                          hintText: 'Mot de passe',
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: GestureDetector(
                            onLongPress: () {
                              setState(() {
                                _passwordVisible = true;
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                _passwordVisible = false;
                              });
                            },
                            child: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Mot de passe obligatoire";
                          }
                        },
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      TextFormField(
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          hasFloatingPlaceholder: true,
                          filled: false,
                          fillColor: Colors.black,
                          hintText: 'Confirmation du mot de passe',
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: GestureDetector(
                            onLongPress: () {
                              setState(() {
                                _passwordVisible = true;
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                _passwordVisible = false;
                              });
                            },
                            child: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Mot de passe obligatoire";
                          }
                          if (confirmation_password != password) {
                            return "Le mot de passe est different";
                          }
                        },
                        onChanged: (value) {
                          confirmation_password = value;
                        },
                      ),
                      RaisedButton(
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1900, 0, 0),
                              maxTime: DateTime.now(),
                              theme: DatePickerTheme(
                                  headerColor: Colors.blue,
                                  // backgroundColor: Colors.white,
                                  itemStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  doneStyle: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              onChanged: (date) {}, onConfirm: (date) {
                            _date = '${date.year}-${date.month}-${date.day}';
                            setState(() {});
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.fr);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          size: 18.0,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "$_date",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        color: Colors.black,
                      ),
                      Center(
                          child: RaisedButton(
                        onPressed: () {
                          _choisirimage(context);
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: const Text('photo de profil',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )),
                      afficher
                          ? Center(
                              child: Container(
                                  child: Image.file(
                              image,
                              width: 400,
                              height: 400,
                            )))
                          : Center(
                              child: Container(
                              child: Text("tu n'a pas choisi d'image"),
                            )),
                      Container(
                        height: 10,
                      ),
                      FlatButton(
                          child: Text(
                            "Conditions générales d'utilisations",
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white70,
                              decorationColor: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.5,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () async {
                            if (await canLaunch(
                                "http://51.210.103.151/conditions.php")) {
                              await launch(
                                  "http://51.210.103.151/conditions.php");
                            }
                          }),
                      Center(
                        child: CheckboxListTile(
                          value: checkboxValue,
                          onChanged: (val) {
                            if (checkboxValue == false) {
                              setState(() {
                                checkboxValue = true;
                              });
                            } else if (checkboxValue == true) {
                              setState(() {
                                checkboxValue = false;
                              });
                            }
                          },
                          subtitle: !checkboxValue
                              ? Text(
                                  "Vous devez accepter les conditions générales d'utilisations.",
                                  style: TextStyle(color: Colors.red),
                                )
                              : null,
                          title: new Text(
                            'Accepter',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.green,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            onPressed: () async {
                              email = email;
                              pseudo = pseudo;
                              await ScopedModel.of<LoginModel>(context)
                                  .Verification_email(email, pseudo);
                              if (_formKey.currentState.validate() &&
                                  checkboxValue == true) {
                                pseudo = pseudo;
                                nom = nom;
                                prenom = prenom;
                                email = email;
                                password = password;
                                club = club;
                                niveaux = niveaux;
                                description = description;
                                ScopedModel.of<LoginModel>(context)
                                    .Postinscritpion(
                                        pseudo,
                                        email,
                                        nom,
                                        prenom,
                                        password,
                                        _date,
                                        club,
                                        niveaux,
                                        description,
                                        base64Image);
                                Navigator.of(context)
                                    .push(_createRouteformulaire());
                              }
                            },
                            child: Text("s'incrire"),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
          ),
        ));
  }
}

Route _createRouteformulaire() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Home(),
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child, // child is the value returned by pageBuilder
      );
    },
  );
}
