import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';

var pseudo;
var nom = " ";
var prenom = " ";
var email;
var password;
String _date = "date de naissance";
var club;
var niveaux = '';
var description;
var photo;
var id;
bool init = true;
bool affphoto = true;
bool _passwordVisible = false;
String strinConfirmationPassword;

class Modif extends StatefulWidget {
  @override
  _ModfState createState() => _ModfState();
}

class _ModfState extends State<Modif> {
  final _formKey = GlobalKey<FormState>();
  File image;
  String base64Image = "";
  Future<void> choisirimage(BuildContext context) {
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
                    });
                    List<int> imageBytes = image.readAsBytesSync();
                    base64Image = base64Encode(imageBytes);
                    affphoto = false;
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
                    });
                    List<int> imageBytes = image.readAsBytesSync();
                    base64Image = base64Encode(imageBytes);
                    affphoto = false;
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
          title: Text("Modifier le profil"),
          backgroundColor: Colors.indigo,
        ),
        // backgroundColor: Colors.black,
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        backgroundColor: back,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ScopedModelDescendant<LoginModel>(
                    builder: (context, child, model) {
                  if (init == true) {
                    pseudo = model.pseudo;
                    nom = model.nom;
                    prenom = model.prenom;

                    email = model.email;
                    password = model.password;
                    strinConfirmationPassword = model.password;
                    _date = model.age;
                    club = model.club;
                    niveaux = model.niveau;
                    description = model.description;
                    image = File(model.img);
                    id = model.id;
                    init = false;
                  }

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          autocorrect: true,
                          initialValue: model.pseudo,
                          cursorColor: Colors.black,
                          style: Theme.of(context).textTheme.headline3,
                          decoration: const InputDecoration(
                            hintText: 'Pseudo',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Pseudo manquant ';
                            }
                            if (ScopedModel.of<LoginModel>(context)
                                    .pseudovalideModif ==
                                false) {
                              return 'Ce pseudo est déja pris';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            pseudo = value;
                          },
                        ),
                        TextFormField(
                          autocorrect: true,
                          initialValue: model.nom,
                          cursorColor: Colors.black,
                          style: Theme.of(context).textTheme.headline3,
                          decoration: const InputDecoration(
                            hintText: 'Nom',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 18.0),
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
                          initialValue: model.prenom,
                          cursorColor: Colors.black,
                          style: Theme.of(context).textTheme.headline3,
                          decoration: const InputDecoration(
                            hintText: 'Prénom',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            prenom = value;
                          },
                        ),
                        TextFormField(
                          autocorrect: true,
                          initialValue: model.email,
                          cursorColor: Colors.black,
                          style: Theme.of(context).textTheme.headline3,
                          decoration: const InputDecoration(
                            hintText: 'email',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Veuillez ajouter un email';
                            }
                            if (ScopedModel.of<LoginModel>(context)
                                    .emailvalideModif ==
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
                          initialValue: model.password,
                          autocorrect: true,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            filled: false,
                            fillColor: Colors.black,
                            hintText: 'Mot de passe',
                            hintStyle: TextStyle(color: Colors.black),
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Mot de passe obligatoire";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                        TextFormField(
                          initialValue: model.password,
                          autocorrect: true,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            filled: false,
                            fillColor: Colors.black,
                            hintText: 'Confirmation du mot de passe',
                            hintStyle: TextStyle(color: Colors.black),
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Mot de passe obligatoire";
                            }
                            if (strinConfirmationPassword != password) {
                              return "Le mot de passe est different";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            strinConfirmationPassword = value;
                          },
                        ),
                        Container(
                          height: 10,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          elevation: 4.0,
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1900, 0, 0),
                                maxTime: DateTime.now(),
                                theme: DatePickerTheme(
                                    headerColor: Colors.indigo,
                                    // backgroundColor: Colors.blue,
                                    itemStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    cancelStyle: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    doneStyle: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                                onChanged: (date) {}, onConfirm: (date) {
                              _date = '${date.day}-${date.month}-${date.year}';
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.fr);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            size: 18.0,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            " $_date",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          color: Colors.amber[900],
                        ),
                        TextFormField(
                          autocorrect: true,
                          initialValue: model.club,
                          cursorColor: Colors.black,
                          style: Theme.of(context).textTheme.headline3,
                          decoration: const InputDecoration(
                            hintText: 'club',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            club = value;
                          },
                        ),
                        DropdownButton<String>(
                          items: [
                            DropdownMenuItem<String>(
                              value: "Pro A (masculin)",
                              child: Text(
                                "Pro A (masculin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Pro B (masculin)",
                              child: Text(
                                "Pro B (masculin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "National 1 (masculin)",
                              child: Text(
                                "National 1 (masculin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "National 2 (masculin)",
                              child: Text(
                                "National 2 (masculin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "National 3 (masculin)",
                              child: Text(
                                "National 3 (masculin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Régionale 1 (masculin)",
                              child: Text(
                                "Régionale 1 (masculin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Régionale 2 (masculin)",
                              child: Text(
                                "Régionale 2 (masculin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Régionale 3 (masculin)",
                              child: Text(
                                "Régionale 3 (masculin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Départementale 1 (masculin)",
                              child: Text(
                                "Départementale 1 (masculin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Départementale 2 (masculin)",
                              child: Text(
                                "Départementale 2 (masculin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Départementale 3 (masculin)",
                              child: Text(
                                "Départementale 3 (masculin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Départementale 4 (masculin)",
                              child: Text(
                                "Départementale 4 (masculin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Pro A (féminin)",
                              child: Text(
                                "Pro A (féminin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Pro B (féminin)",
                              child: Text(
                                "Pro B (féminin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "National 1 (féminin)",
                              child: Text(
                                "National 1 (féminin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "National 2 (féminin)",
                              child: Text(
                                "National 2 (féminin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "National 3 (féminin)",
                              child: Text(
                                "National 3 (féminin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Régionale 1 (féminin)",
                              child: Text(
                                "Régionale 1 (féminin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Régionale 2 (féminin)",
                              child: Text(
                                "Régionale 2 (féminin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Régionale 3 (féminin)",
                              child: Text(
                                "Régionale 3 (féminin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Départementale 1 (féminin)",
                              child: Text(
                                "Départementale 1 (féminin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Départementale 2 (féminin)",
                              child: Text(
                                "Départementale 2 (féminin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Départementale 3 (féminin)",
                              child: Text(
                                "Départementale 3 (féminin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Départementale 4 (féminin)",
                              child: Text(
                                "Départementale 4 (féminin)",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "aucun",
                              child: Text(
                                "aucun",
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              niveaux = value;
                            });
                          },
                          value: niveaux,
                          isDense: true,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        TextFormField(
                          autocorrect: true,
                          initialValue: model.description,
                          maxLines: 5,
                          cursorColor: Colors.black,
                          style: Theme.of(context).textTheme.headline3,
                          decoration: const InputDecoration(
                            hintText: 'description',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            description = value;
                          },
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: RaisedButton(
                              onPressed: () async {
                                await ScopedModel.of<LoginModel>(context)
                                    .verificationEmailModif(email, pseudo);
                                if (_formKey.currentState.validate()) {
                                  model.loging = false;
                                  ScopedModel.of<LoginModel>(context)
                                      .modifierProfil(
                                          pseudo,
                                          email,
                                          nom,
                                          prenom,
                                          password,
                                          _date,
                                          club,
                                          niveaux,
                                          description,
                                          id);
                                  if (email != model.email ||
                                      password != model.password) {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        '/', (Route<dynamic> route) => false);
                                  } else {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/Profil',
                                        (Route<dynamic> route) => false);
                                  }

                                  init = true;
                                  affphoto = true;
                                }
                              },
                              child: Text("modifer"),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                })
              ],
            )),
          ),
        ));
  }
}
