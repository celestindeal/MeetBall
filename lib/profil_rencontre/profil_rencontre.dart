import 'package:flutter/material.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/profil_rencontre/commentaire.dart';
import 'package:meetballl/profil_rencontre/presentation.dart';
import 'package:scoped_model/scoped_model.dart';
import '../footer.dart';
import '../main.dart';
import '../models/Model_match.dart';

class ProfilRenctontre extends StatefulWidget {
  @override
  _ProfilRenctontreState createState() => _ProfilRenctontreState();
}

class _ProfilRenctontreState extends State<ProfilRenctontre> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(builder: (context, child, model) {
      return Container(
          child: model.boAfficherLieu
              ? ScopedModel.of<LoginModel>(context).boParticipation
                  ? PageView.builder(
                      controller: PageController(viewportFraction: 1),
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int itemIndex) {
                        if (itemIndex == 0) {
                          return Presentation();
                        } else {
                          return Commentaire();
                        }
                      })
                  : Presentation()
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
