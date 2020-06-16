import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appBar.dart';
import 'drawer.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';

String avis;

class Avis extends StatelessWidget {
  String pseudo;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerNav(context),
        persistentFooterButtons: <Widget>[
                    Footer(),
                  ],
        drawer: Darwer(),
        // backgroundColor: Colors.black54,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Center(
            child: Text("Qu'aimerais-tu avoir de plus sur cette application?",
                style: Theme.of(context).textTheme.display2),
          ),
          Center(
            child: Text("N'hésites pas à nous donner des idées ci-dessous !",
                style: Theme.of(context).textTheme.display2),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        maxLines: 5,
                        cursorColor: Colors.black54,
                        style: TextStyle(
                            color: Colors.white, decorationColor: Colors.white),
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          avis = value;
                        },
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                pseudo =
                                    ScopedModel.of<LoginModel>(context).pseudo;
                                envoie_avis(pseudo);
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/Profil', (Route<dynamic> route) => false);
                              }
                            },
                            child: Text('Envoyer'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ])
        ]));
  }
}

Future<String> envoie_avis(String pseudo) async {
  String json = '{"avis":"$avis","pseudo":"$pseudo"}';
  String url = 'http://51.210.103.151/post_avis.php';
  // make POST request
  Response response = await post(url, body: json);
  String body = response.body;

  return body;
}
