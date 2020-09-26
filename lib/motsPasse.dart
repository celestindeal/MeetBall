import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mailer2/mailer.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:scoped_model/scoped_model.dart';

class Password extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    email(String message, String email) async {
      var options = new GmailSmtpOptions()
        ..username = 'equipemeetball@gmail.com'
        ..password = 'Projet1*';
      var emailTransport = new SmtpTransport(options);

      // Create our mail/envelope.
      var envelope = new Envelope()
        ..from = '$email'
        ..recipients.add('$email')
        ..subject = 'Nouveaux mots de passe'
        ..text = 'Ton nouveau mots de passe est $message';
      emailTransport.send(envelope);
    }

    String strinEmailChange;
    return Scaffold(
        backgroundColor: back,
        body:
            ScopedModelDescendant<LoginModel>(builder: (context, child, model) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'img/balise.png',
                width: MediaQuery.of(context).size.width,
              ),
              TextFormField(
                autocorrect: true,
                decoration: InputDecoration(
                  filled: false,
                  fillColor: Colors.black,
                  hintText: 'adresse email',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "entrer une adresse email";
                  }
                  return null;
                },
                onChanged: (value) {
                  strinEmailChange = value;
                },
              ),
              RaisedButton(
                  onPressed: () async {
                    // vérification de l'email pour s'avoir si il fait bien partir de notre basse de donner
                    String url =
                        'http://51.210.103.151/post_connexion.php'; // vérification email
                    String json = '{"email":"$strinEmailChange"}';
                    Response response = await post(url, body: json);
                    List listpersonne = jsonDecode(response.body);
                    if (listpersonne.isNotEmpty) {
                      String url = 'http://51.210.103.151/post_password.php';
                      String json = '{"email":"$strinEmailChange"}';
                      Response response = await post(url, body: json);
                      String body = response.body;
                      email(body, strinEmailChange);
                      Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text(
                              "Le nouveau mots de passe est envoyer à l'adresse mail")));
                    } else {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Cette email n'exist pas "),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Ressevoir un nouveaux mots de passe',
                    textAlign: TextAlign.center,
                  )),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('retour'),
              )
            ],
          );
        }));
  }
}
