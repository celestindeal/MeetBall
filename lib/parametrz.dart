import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Parametre extends StatefulWidget {
  @override
  _ParametreState createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
  final keyformKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    changeBrightness() {
      DynamicTheme.of(context).setBrightness(
          Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark);

      Baselocal().miseAjour();
      back =
          Theme.of(context).brightness == Brightness.dark ? Colors.white : null;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Paramètres'),
        backgroundColor: Colors.indigo,
      ),
      persistentFooterButtons: <Widget>[
        Footer(),
      ],
      backgroundColor: back,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Mode d'affichage"),
                      ],
                    ),
                    onPressed: () async {
                      changeBrightness();
                    }),
              ),
              Divider(color: Colors.grey[300]),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  onPressed: () async {
                    Navigator.pushNamed(context, '/Avis');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Nous contacter',
                          style: Theme.of(context).textTheme.headline3),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.grey[300]),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                      'Es-tu sûr de vraiment vouloir te déconnecter ?',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      RaisedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('non')),
                                      RaisedButton(
                                          onPressed: () async {
                                            await ScopedModel.of<LoginModel>(
                                                    context)
                                                .deconnection();
                                            await Baselocal().deconnect();
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/',
                                                (Route<dynamic> route) =>
                                                    false);
                                          },
                                          child: Text('oui')),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Déconnexion',
                          style: Theme.of(context).textTheme.headline3),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.grey[300]),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("CONDITIONS GÉNÉRALES D’UTILISATION"),
                      ],
                    ),
                    onPressed: () async {
                      if (await canLaunch(
                          "http://51.210.103.151/conditions.php")) {
                        await launch("http://51.210.103.151/conditions.php");
                      }
                    }),
              ),
              Divider(color: Colors.grey[300]),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("POLITIQUE DE CONFIDENTIALITÉ"),
                      ],
                    ),
                    onPressed: () async {
                      if (await canLaunch(
                          "http://51.210.103.151/confidentialite.php")) {
                        await launch(
                            "http://51.210.103.151/confidentialite.php");
                      }
                    }),
              ),
              Divider(color: Colors.grey[300]),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("FAQ"),
                      ],
                    ),
                    onPressed: () async {
                      if (await canLaunch("http://51.210.103.151/FAQ.php")) {
                        await launch("http://51.210.103.151/FAQ.php");
                      }
                    }),
              ),
              Divider(color: Colors.grey[300]),
              ScopedModel.of<LoginModel>(context).devellopeur
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                '/avisDev', (Route<dynamic> route) => false);
                          },
                          child: Container(
                            height: (MediaQuery.of(context).size.height / 10),
                            child: Center(
                              child: Text('avisDev',
                                  style: Theme.of(context).textTheme.headline3),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScopedModel.of<ImgModel>(context).listImage();
                            ScopedModel.of<TerrainModel>(context).terrainDev();
                            Navigator.pushNamedAndRemoveUntil(context,
                                '/lieuDev', (Route<dynamic> route) => false);
                          },
                          child: Container(
                            height: (MediaQuery.of(context).size.height / 10),
                            child: Center(
                              child: Text('lieuDev',
                                  style: Theme.of(context).textTheme.headline3),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
