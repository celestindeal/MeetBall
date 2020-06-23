import 'package:flutter/material.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/profil.dart';
import 'package:meetballl/profil_rencontre.dart';
import 'package:meetballl/terrain.dart';
import 'package:meetballl/terrainproche.dart';
import 'package:meetballl/terrainrecherche.dart';
import 'package:meetballl/terrainrencontre.dart';
import 'package:meetballl/test.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:splashscreen/splashscreen.dart';
import 'Ajout_terrain.dart';
import 'PushNotificationManager.dart';
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

void main() {
  runApp(new Main());
}

bool couleur = false;

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
    if (couleur) {
      couleur = false;
    } else {
      couleur = true;
    }
    Baselocal().mise_a_jour();
  }

  Widget build(BuildContext context) {
    String mode = "false";
    initState() async {
      mode = await Baselocal().valColor();
      if (mode == "true") {
        setState(() {
          couleur = true;
        });

        DynamicTheme.of(context).setBrightness(
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark);
      }
    }

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
                                    color:
                                          Colors.black,
                                    decorationColor:
                                        Colors.black54), //text Class
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
                            theme: theme,
                            debugShowCheckedModeBanner: false,
                            initialRoute: '/',
                            routes: {
                              '/': (context) => Accueil(),
                              '/inscription': (context) => Inscription(),
                              '/Profil': (context) => Profil(),
                              '/Match': (context) => Match(),
                              '/Profil_renctontre': (context) =>
                                  Profil_renctontre(),
                              '/Terrain': (context) => Terrain(),
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
                              '/test': (context) => MyHomePage(),
                            },
                          );
                        })))));
  }
}
