import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appBar.dart';
import 'drawer.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';

var pseudo;
var telephone = " ";
var email;
var password;
String _date = "date de naissance";
var club;
var niveaux;
var description;
var photo;
var id;
bool init = true;
bool affphoto = true;

class Modif extends StatefulWidget {
  @override
  _ModfState createState() => _ModfState();
}

class _ModfState extends State<Modif> {
  final _formKey = GlobalKey<FormState>();
  File image;
  String base64Image = "";
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
        appBar: headerNav(context),
        // backgroundColor: Colors.black54,
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        drawer: Darwer(),
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
                    telephone = model.numero;
                    email = model.email;
                    password = model.password;
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
                          initialValue: model.pseudo,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.white,
                              decorationColor: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Pseudo',
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            pseudo = value;
                          },
                        ),
                        TextFormField(
                          initialValue: model.email,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.white,
                              decorationColor: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'email',
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        TextFormField(
                          initialValue: model.password,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.white,
                              decorationColor: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'password',
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
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
                                    headerColor: Colors.red,
                                    // backgroundColor: Colors.blue,
                                    itemStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    doneStyle: TextStyle(
                                        color: Colors.black, fontSize: 16)),
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
                                            color: Colors.teal,
                                          ),
                                          Text(
                                            " $_date",
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
                        /* SizedBox(
                height: 20.0,
              ),
               */
                        TextFormField(
                          initialValue: model.club,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.white,
                              decorationColor: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'club',
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18.0),
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
                        TextFormField(
                          initialValue: model.niveau,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.white,
                              decorationColor: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'niveaux',
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            niveaux = value;
                          },
                        ),
                        TextFormField(
                          initialValue: model.description,
                          maxLines: 5,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                              color: Colors.white,
                              decorationColor: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'description',
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18.0),
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
                    /*   Center(
                            child: RaisedButton(
                          onPressed: () {
                            _choisirimage(context);
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: const Text('changer la photo',
                                style: TextStyle(fontSize: 20)),
                          ),
                        )),
                        affphoto
                            ? Image.network(
                                model.img,
                              )
                            : Image.file(
                                image,
                                width: 400,
                                height: 400,
                              ),
                    */    Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: RaisedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  model.loging = false;
                                  ScopedModel.of<LoginModel>(context).Modif(
                                      pseudo,
                                      email,
                                      telephone,
                                      password,
                                      _date,
                                      club,
                                      niveaux,
                                      description,
                                      base64Image,
                                      id);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/Profil',
                                      (Route<dynamic> route) => false);
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
