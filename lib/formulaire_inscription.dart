import 'package:flutter/material.dart';
import 'package:meetballl/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/Model_co.dart';

var pseudo;
var nom = " ";

var prenom = " ";
var email;
var password;
var jour;
var club = " ";
var niveaux = " ";
var description = " ";
bool loging = false;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _Home();
  }
}

class _Home extends State<Home> {
  final keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("MeetBall"),
          backgroundColor: Colors.indigo,
          leading: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/Ajout_match', (Route<dynamic> route) => false);
              }),
        ),
        // backgroundColor: Colors.black,
        backgroundColor: back,
        body:
            ScopedModelDescendant<LoginModel>(builder: (context, child, model) {
          return Container(
              child: model.loging == false
                  ? Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      ],
                    )
                  : Center(
                      child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/Profil',
                            (Route<dynamic> route) => false);
                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: const Text('Se connecter',
                            style: TextStyle(fontSize: 20)),
                      ),
                    )));
        }));
  }
}
