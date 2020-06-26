import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meetballl/PushNotificationManager.dart';
import 'package:meetballl/db.dart';

import 'package:scoped_model/scoped_model.dart';

//import 'package:image_picker/image_picker.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';

File image;
var form_email;
var form_password;
var _controller1 = TextEditingController();
bool _passwordVisible = false;
bool boinit = true;

const url = 'https://flutter.dev';

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
        ScopedModel.of<LoginModel>(context)
            .Connexion(persoonne[0]['email'], persoonne[0]['password']);
        Navigator.pushNamedAndRemoveUntil(
            context, '/Profil', (Route<dynamic> route) => false);

        PushNotificationsManager().init();
        return persoonne;
      }
      if (boinit) {

      init();
     boinit = false;
    }
    return Scaffold(

      // backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                      controller: _controller1,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: couleur? Colors.white : Colors.black,
                           decorationColor: Colors.white),
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
                        form_email = value;
                      },
                    ),
                    TextFormField(
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
                          return "Mot de passe incorrect";
                        }
                      },
                      onChanged: (value) {
                        form_password = value;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/inscription');
                                PushNotificationsManager().init();
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
                                  _controller1 =
                                  TextEditingController(text: form_email);
                                  ScopedModel.of<LoginModel>(context)
                                      .Connexion(form_email, form_password);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/Profil',
                                      (Route<dynamic> route) => false);
                                }
                                PushNotificationsManager().init();
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
