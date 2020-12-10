import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/main.dart';
import 'package:scoped_model/scoped_model.dart';

//import 'package:image_picker/image_picker.dart';
import 'models/Model_co.dart';

File image;
var vaFormEmail;
var vaFormPassword;
var _controller1 = TextEditingController();
bool _passwordVisible = false;

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    init() async {
      List persoonne;
      persoonne = await Baselocal().connect();
      persoonne.add("value");
      if (persoonne[0] != "value") {
        ScopedModel.of<LoginModel>(context)
            .connexion(persoonne[0]['email'], persoonne[0]['password']);
        Navigator.pushNamedAndRemoveUntil(
            context, '/Profil', (Route<dynamic> route) => false);
      }
      return persoonne;
    }

    if (boConnexionAuto) {
      init();
      boConnexionAuto = false;
    }
    return Scaffold(
      backgroundColor: back,
      body: Center(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Image.asset(
            'img/balise.png',
            width: MediaQuery.of(context).size.width,
          ),
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
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email incorrect';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    vaFormEmail = value;
                  },
                ),

                TextFormField(
                  autocorrect: true,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.black,
                    hintText: 'Mot de passe',
                    hintStyle: TextStyle(color: Colors.black),
                    // icon pour rendre visible le password écrit
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
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Mot de passe incorrect";
                    }
                  },
                  onChanged: (value) {
                    vaFormPassword = value;
                  },
                ),
// test mots de passe oublié
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/password');
                    },
                    child: Text(
                      "Mots de passe oublier",
                    )),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/inscription');
                          },
                          child: Text('Inscription'),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              //enregistrer l'email écrit pour le cas ou il y as un deuxième essaye de connection
                              _controller1 =
                                  TextEditingController(text: vaFormEmail);
                              //fonction de connection
                              ScopedModel.of<LoginModel>(context)
                                  .connexion(vaFormEmail, vaFormPassword);

                              Navigator.pushNamedAndRemoveUntil(context,
                                  '/Profil', (Route<dynamic> route) => false);
                            }
                          },
                          child: Text('Connexion'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ])),
      ),
    );
  }
}
