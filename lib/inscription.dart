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
bool checkboxValue = false;

class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(

   
        // backgroundColor: Colors.black,
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
                       Image.asset(
                'img/balise.png',
                width: MediaQuery.of(context).size.width,
              ),
                       TextFormField(
                      autocorrect: true,
                        cursorColor: Colors.black,
                        style: TextStyle(
                            color: Colors.black, decorationColor: Colors.black),
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
                      autocorrect: true,
                        cursorColor: Colors.black,
                        style: TextStyle(
                            color: Colors.black, decorationColor: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Nom',
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 18.0),
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
                      autocorrect: true,
                        cursorColor: Colors.black,
                        style: TextStyle(
                            color: Colors.black, decorationColor: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Prénom',
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 18.0),
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
                      autocorrect: true,
                        cursorColor: Colors.black,
                        style: TextStyle(
                            color: Colors.black, decorationColor: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 18.0),
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
                      autocorrect: true,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          hasFloatingPlaceholder: true,
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
                      autocorrect: true,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          hasFloatingPlaceholder: true,
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
                                  headerColor: Colors.indigo,
                                  // backgroundColor: Colors.white,
                                  itemStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  cancelStyle: TextStyle(
                                      color: Colors.white, fontSize: 16),
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
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "$_date",
                                          style: TextStyle(
                                              color: Colors.black,
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
                        color: Colors.amber[900],
                      ),
                  
                   
                      Container(
                        height: 10,
                      ),
                      FlatButton(
                          child: Text(
                            "Conditions générales d'utilisations",
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              decorationColor: Colors.black,
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
                            child: Text("S'inscrire"),
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
