import 'package:flutter/material.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/profil_rencontre/commentaire.dart';
import 'package:meetballl/profil_rencontre/presentation.dart';
import 'package:scoped_model/scoped_model.dart';
import '../footer.dart';
import '../main.dart';
import '../models/Model_match.dart';

class Profil_renctontre extends StatefulWidget {
  @override
  _Profil_renctontreState createState() => _Profil_renctontreState();
}

class _Profil_renctontreState extends State<Profil_renctontre> {
  @override

  Widget build(BuildContext context) {
    
    return ScopedModelDescendant<GameModel>(builder: (context, child, model) {
 Function changepage(){
      setState(() {
      //  ScopedModel.of<LoginModel>(context).boParticipation;
      });
    }
      return Container(
          child: model.afficher_lieu
              ? ScopedModel.of<LoginModel>(context).boParticipation?
              PageView.builder(
                  controller: PageController(viewportFraction: 1),
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    if (itemIndex == 0) {
                      return Presentation();
                    } else {
                      return Commentaire();
                    }
                  }): Presentation()
              : Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text("Rencontre"),
                    backgroundColor: Colors.indigo,
                  ),
                  persistentFooterButtons: <Widget>[
                    Footer(),
                  ],
                  // backgroundColor: Colors.black,
                  backgroundColor: back,
                  body: Center(
                    child: CircularProgressIndicator(),
                  )));
    });
  }
}







