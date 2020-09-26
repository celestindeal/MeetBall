import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meetballl/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'footer.dart';
import 'models/Model_terrain.dart';

class Rechercher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TerrainModel>(
        builder: (context, child, model) {
      return Container(
          child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PresentationRechercher(),
        ],
      ));
    });
  }
}

class PresentationRechercher extends StatefulWidget {
  @override
  _PresentationRechercherState createState() => _PresentationRechercherState();
}

class _PresentationRechercherState extends State<PresentationRechercher> {
  int inNombreTour = 0;

  String lien;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Rechercher", textAlign: TextAlign.center),
          backgroundColor: Colors.indigo,
          leading: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/Ajout_match');
              }),
        ),
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        backgroundColor: back,
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/ProfilRechercher');
                },
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: new BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.indigo[900],
                        Colors.indigoAccent[700],
                        Colors.indigoAccent[400],
                        Colors.indigo,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.people,
                    size: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  //  ScopedModel.of<ImgModel>(context).Img();
                  // ScopedModel.of<TerrainModel>(context).Terrain();
                  Navigator.pushNamed(context, '/Terrain');
                },
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: new BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.indigo[900],
                        Colors.indigoAccent[700],
                        Colors.indigoAccent[400],
                        Colors.indigo,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ImageIcon(
                    AssetImage(
                      'img/terrain.png',
                    ),
                    size: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
