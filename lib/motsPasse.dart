import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mailer2/mailer.dart';
import 'package:http/http.dart' as http;
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:scoped_model/scoped_model.dart';

class Password extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    email(String message, String email) async {
      var options = new GmailSmtpOptions()
        ..username = 'equipemeetball@gmail.com'
        ..password =
            'Projet1*'; // Note: if you have Google's "app specific passwords" enabled,
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
      emailTransport
          .send(envelope);
          // .then((envelope) => print('Email sent!'))
          // .catchError((e) => print('Error occurred: $e'));
    }

    String email_chnage;
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
              hasFloatingPlaceholder: true,
              filled: false,
              fillColor: Colors.black,
              hintText: 'adresse email',
              hintStyle: TextStyle(color: Colors.black),
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
                // vérification de l'email pour s'avoir si il fait bien partir de notre basse de donner
                var listemail = 'http://51.210.103.151/get_email.php';
                http.Response mail = await http.get(listemail);
                var data = jsonDecode(mail.body);
                bool trueemail = false;
                for (var i = 0; i < data.length; i++) {
                  if (data[i]['email'] == email_chnage && trueemail == false) {
                    trueemail = true;
                    String url = 'http://51.210.103.151/post_password.php';
                    String json = '{"email":"$email_chnage"}';
                    Response response = await post(url,  body:  json);
                    String body = response.body;
                    email(body, email_chnage);
                    Scaffold.of(context).showSnackBar(new SnackBar(
                        content: new Text(
                            "Le nouveau mots de passe est envoyer à l'adresse mail")));
                  }
                }
                if (trueemail == false) {
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
