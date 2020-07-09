import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetballl/calendar.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/motsPasse.dart';
import 'package:meetballl/profVisiteur.dart';
import 'package:meetballl/profil.dart';
import 'package:meetballl/profil_rencontre.dart';
import 'package:meetballl/profilrechercher.dart';
import 'package:meetballl/rechercher.dart';
import 'package:meetballl/terrain.dart';
import 'package:meetballl/terrainproche.dart';
import 'package:meetballl/terrainrecherche.dart';
import 'package:meetballl/terrainrencontre.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Ajout_terrain.dart';
import 'accueil.dart';
import 'ajout_match.dart';
import 'avis.dart';
import 'avisDev.dart';
import 'lieudev.dart';
import 'math.dart';
import 'inscription.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';
import 'models/Model_match.dart';
import 'models/Model_terrain.dart';
import 'modif.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
Color back ;
void main() {
  runApp(new Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Brightness _brightness = Brightness.light;
  changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
           
    Baselocal().mise_a_jour();
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    String mode = "false";
    initState() async {
      mode = await Baselocal().valColor();
      if (mode == "true") {
        DynamicTheme.of(context).setBrightness(
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.values
                : Brightness.dark);
        
      }
    }
back = Theme.of(context).brightness == Brightness.dark
            ? Colors.red 
            :null;
    return ScopedModel(
        model: ImgModel(),
        child: ScopedModel(
            model: TerrainModel(),
            child: ScopedModel(
                model: GameModel(),
                child: ScopedModel(
                    model: LoginModel(),
                    child: DynamicTheme(
                        defaultBrightness: Brightness.light,
                        data: (brightness) => ThemeData(
                              brightness: brightness,
                              textTheme: TextTheme(
                                body1: TextStyle(fontSize: 10.0),
                                body2: TextStyle(fontSize: 16.0),
                                display1: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.red,
                                    decorationColor: Colors.white), // darwer
                                display2: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  decorationColor: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.5,
                                ), //text stiler
                                display3: TextStyle(
                                    fontSize: 16.0,
                                    color: brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    decorationColor: Colors.black), //text Class
                                display4: TextStyle(
                                  fontSize: 32.0,
                                  inherit: false,
                                  letterSpacing: 0.5,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        themedWidgetBuilder: (context, theme) {
                          return MaterialApp(
                            
                            supportedLocales: [
                              const Locale('en', 'US'), // English
                              const Locale('th', 'TH'), // Thai
                            ],
                            
                            theme: theme,
                            debugShowCheckedModeBanner: false,
                            initialRoute: '/',
                            routes: {
                              '/': (context) => Accueil(),
                              '/inscription': (context) => Inscription(),
                              '/Profil': (context) => Profil(),
                              '/ProfilVisiteur': (context) => ProfilVisiteur(),
                              '/Match': (context) => Match(),
                              '/Profil_renctontre': (context) =>
                                  Profil_renctontre(),
                              '/Terrain': (context) => Terrain(),
                              '/Rechercher': (context) => Rechercher(),
                              '/ProfilRechercher': (context) => ProfilRecherche(),
                              '/Terrainpro': (context) => TerrainPro(),
                              '/Terrainrecherche': (context) =>
                                  TerrainRecherche(),
                              '/TerrainRencontre': (context) => TerrainRen(),
                              '/Ajout_terrain': (context) => Ajout_terrain(),
                              '/Ajout_match': (context) => Ajout_match(),
                              '/Avis': (context) => Avis(),
                              '/modif': (context) => Modif(),
                              '/avisDev': (context) => AvisDev(),
                              '/lieuDev': (context) => LieuDev(),
                              '/Calendar': (context) => Calendar(),
                              '/password': (context) => Password(),



                            },
                          );
                        })))));
  }
}

sdialog(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        changeBrightness() {
          DynamicTheme.of(context).setBrightness(
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark);


          Baselocal().mise_a_jour();
          back = Theme.of(context).brightness == Brightness.dark
            ? Colors.red 
            :null;
        }

        return Center(
          child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                          child: Text("Mode d'affichage"),
                          onPressed: () async {
                            changeBrightness();
                          }),
                      RaisedButton(
                        onPressed: () async {
                          Navigator.pushNamedAndRemoveUntil(context, '/Avis',
                              (Route<dynamic> route) => false);
                        },
                        child: Text('Nous contacter',
                            style: Theme.of(context).textTheme.display3),
                      ),
                      RaisedButton(
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
                                                .display1),
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
                                                  await ScopedModel.of<
                                                          LoginModel>(context)
                                                      .Deconnection();
                                                  await Baselocal().deconnect();
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          '/',
                                                          (Route<dynamic>
                                                                  route) =>
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
                        child: Text('Déconnexion',
                            style: Theme.of(context).textTheme.display3),
                      ),
                      RaisedButton(
                          child: Text("CONDITIONS GÉNÉRALES D’UTILISATION"),
                          onPressed: () async {
                            if (await canLaunch(
                                "http://51.210.103.151/conditions.php")) {
                              await launch(
                                  "http://51.210.103.151/conditions.php");
                            }
                          }),
                      RaisedButton(
                          child: Text("POLITIQUE DE CONFIDENTIALITÉ"),
                          onPressed: () async {
                            if (await canLaunch(
                                "http://51.210.103.151/confidentialite.php")) {
                              await launch(
                                  "http://51.210.103.151/confidentialite.php");
                            }
                          }),
                      RaisedButton(
                          child: Text("FAQ"),
                          onPressed: () async {
                            if (await canLaunch(
                                "http://51.210.103.151/FAQ.php")) {
                              await launch("http://51.210.103.151/FAQ.php");
                            }
                          }),
                      ScopedModel.of<LoginModel>(context).devellopeur
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/avisDev',
                                        (Route<dynamic> route) => false);
                                  },
                                  child: Container(
                                    height:
                                        (MediaQuery.of(context).size.height /
                                            10),
                                    child: Center(
                                      child: Text('avisDev',
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ScopedModel.of<ImgModel>(context).Img();
                                    ScopedModel.of<TerrainModel>(context)
                                        .TerrainDev();
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/lieuDev',
                                        (Route<dynamic> route) => false);
                                  },
                                  child: Container(
                                    height:
                                        (MediaQuery.of(context).size.height /
                                            10),
                                    child: Center(
                                      child: Text('lieuDev',
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
              )),
        );
      });
    },
  );
}
