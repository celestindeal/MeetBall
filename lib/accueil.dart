import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mailer2/mailer.dart';
import 'package:meetballl/PushNotificationManager.dart';
import 'package:meetballl/db.dart';

import 'package:scoped_model/scoped_model.dart';

//import 'package:image_picker/image_picker.dart';
import 'models/Model_co.dart';

File image;
var form_email;
var form_password;
var _controller1 = TextEditingController();
bool _passwordVisible = false;
bool boinit = true;

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

email(String message , String email) async {
  var options = new GmailSmtpOptions()
    ..username = 'equipemeetball@gmail.com'
    ..password = 'Projet1*'; // Note: if you have Google's "app specific passwords" enabled,
                                        // you need to use one of those here.
                                        
  // How you use and store passwords is up to you. Beware of storing passwords in plain.

  // Create our email transport.
  var emailTransport = new SmtpTransport(options);

  // Create our mail/envelope.
  var envelope = new Envelope()
    ..from = '$email'
    ..recipients.add('$email')
    ..subject = 'Nouveaux mots de passe'
    ..text = 'Ton nouveau mots de passe est $message';

  // Email it.
  emailTransport.send(envelope)
    .then((envelope) => print('Email sent!'))
    .catchError((e) => print('Error occurred: $e'));
} 

    init() async {
      List persoonne;
      persoonne = await Baselocal().connect();
      persoonne.add("value");
      if (persoonne[0] != "value") {
        ScopedModel.of<LoginModel>(context)
            .Connexion(persoonne[0]['email'], persoonne[0]['password']);
        Navigator.pushNamedAndRemoveUntil(
            context, '/Profil', (Route<dynamic> route) => false);
      }

      PushNotificationsManager().init();
      return persoonne;
    }

    if (boinit) {
      init();
      boinit = false;
    }
    return Scaffold(
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
                  style: Theme.of(context).textTheme.display3,
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
                  autocorrect: true,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    hasFloatingPlaceholder: true,
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
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Mot de passe incorrect";
                    }
                  },
                  onChanged: (value) {
                    form_password = value;
                  },
                ),
// test mots de passe oublié
                FlatButton(
                    onPressed: () {
                      String email_chnage;
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                backgroundColor: Colors.transparent,
                                content: StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.grey,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        TextFormField(
                                          autocorrect: true,
                                          decoration: InputDecoration(
                                            hasFloatingPlaceholder: true,
                                            filled: false,
                                            fillColor: Colors.black,
                                            hintText: 'adresse email',
                                            hintStyle:
                                                TextStyle(color: Colors.black),
                                          ),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "entrer une adresse email";
                                            }
                                          },
                                          onChanged: (value) {
                                            email_chnage = value;
                                          },
                                        ),
                                        RaisedButton(
                                          onPressed: () async {
                                            print('changement de mots depasse');
                                            String url =
                                                'http://51.210.103.151/post_password.php';
                                            String json =
                                                '{"email":"$email_chnage"}';
                                            Response response =
                                                await post(url, body: json);
                                            String body = response.body;
                                            print(body);
                                            email(body, email_chnage);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Ressevoir un nouveaux mots de passe',
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }));
                          });
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
                              //enregistrer l'email écrit pour le cas ou il y as un deuxième essaye de connection
                              _controller1 =
                                  TextEditingController(text: form_email);
                              //fonction de connection
                              ScopedModel.of<LoginModel>(context)
                                  .Connexion(form_email, form_password);

                              Navigator.pushNamedAndRemoveUntil(context,
                                  '/Profil', (Route<dynamic> route) => false);
                            }
                            // s'inscrirr pour resevoire les notifications
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
