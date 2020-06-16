import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetballl/PushNotificationManager.dart';
import 'package:meetballl/db.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:image_picker/image_picker.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';

File image;
var form_email;
var form_password;
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
        print('pk ça ne change pas');
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
      
      print("iniit");
      init();
     boinit = false;
    }
    return Scaffold(
      // appBar: headerNav(context),
      persistentFooterButtons: <Widget>[
        Footer(),
      ],

      // backgroundColor: Colors.black54,
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
                      cursorColor: Colors.black54,
                      style: TextStyle(
                          color: Colors.white, decorationColor: Colors.white),
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
                                  ScopedModel.of<LoginModel>(context)
                                      .Connexion(form_email, form_password);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/Profil',
                                      (Route<dynamic> route) => false);
                                }
                                PushNotificationsManager().init();
                              },
                              child: Text('connexion'),
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
