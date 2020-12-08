import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meetballl/calendar.dart';
import 'package:meetballl/profil_rencontre/commentaire.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/motsPasse.dart';
import 'package:meetballl/parametrz.dart';
import 'package:meetballl/profVisiteur.dart';
import 'package:meetballl/profil.dart';
import 'package:meetballl/profil_rencontre/presentation.dart';
import 'package:meetballl/profilrechercher.dart';
import 'package:meetballl/rechercher.dart';
import 'package:meetballl/terrain/terrain.dart';
import 'package:meetballl/terrain/terrainproche.dart';
import 'package:meetballl/terrain/terrainrecherche.dart';
import 'package:meetballl/terrain/terrainrencontre.dart';
import 'package:meetballl/test.dart';
import 'package:scoped_model/scoped_model.dart';
import 'terrain/Ajout_terrain.dart';
import 'accueil.dart';
import 'ajout_match.dart';
import 'avis.dart';
import 'avisDev.dart';
import 'terrain/lieudev.dart';
import 'inscription.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';
import 'models/Model_match.dart';
import 'models/Model_terrain.dart';
import 'modif.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:connectivity/connectivity.dart';

Color back;
var connectivityResult;
bool boConnexionAuto = true;
void main() {
  runApp(new Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  bool connexion = true;
  changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);

    Baselocal().miseAjour();
  }

  Widget build(BuildContext context) {
    connection() async {
      // si on est connecter à internet connexion = true;    et si on n'a pas de connexion = false;
      connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        if (connexion == false) {
          setState(() {
            connexion = true;
            boConnexionAuto = true; // relance la connexion automatique
          });
        }
      } else if (connectivityResult == ConnectivityResult.none) {
        if (connexion = !false) {
          setState(() {
            connexion = false;
          });
        }
      }
    }

// toutes les deux seconds on verrifi la conneciton à internet
    const oneSec = const Duration(seconds: 2);
    new Timer.periodic(oneSec, (Timer t) {
      connection();
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // initState() async {
    //   mode = await Baselocal().valColor();
    //   if (mode == "true") {
    //     DynamicTheme.of(context).setBrightness(
    //         Theme.of(context).brightness == Brightness.dark
    //             ? Brightness.values
    //             : Brightness.dark);
    //   }
    // }

    back =
        Theme.of(context).brightness == Brightness.dark ? Colors.white : null;

    if (connexion) {
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
                                  headline1: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.red,
                                      decorationColor: Colors.white), // darwer
                                  headline2: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    decorationColor: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.5,
                                  ), //text stiler
                                  headline3: TextStyle(
                                      fontSize: 16.0,
                                      color: brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      decorationColor:
                                          Colors.black), //text Class
                                  headline4: TextStyle(
                                    fontSize: 32.0,
                                    inherit: false,
                                    letterSpacing: 0.5,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                          themedWidgetBuilder: (context, theme) {
                            return MaterialApp(
                              // localizationsDelegates: [
                              //   GlobalMaterialLocalizations.delegate,
                              //   GlobalWidgetsLocalizations.delegate,
                              // ],
                              supportedLocales: [
                                const Locale('fr', ''), // English
                              ],
                              theme: theme,
                              debugShowCheckedModeBanner: false,
                              initialRoute: '/',
                              routes: {
                                '/': (context) => Accueil(),
                                '/inscription': (context) => Inscription(),
                                '/Profil': (context) => Profil(),
                                '/ProfilVisiteur': (context) =>
                                    ProfilVisiteur(),
                                '/Profil_renctontre': (context) =>
                                    ProfilRenctontre(),
                                '/Terrain': (context) => Terrain(),
                                '/Rechercher': (context) => Rechercher(),
                                '/ProfilRechercher': (context) =>
                                    ProfilRecherche(),
                                '/Terrainpro': (context) => TerrainPro(),
                                '/Terrainrecherche': (context) =>
                                    TerrainRecherche(),
                                '/TerrainRencontre': (context) => TerrainRen(),
                                '/Ajout_terrain': (context) => AjoutTerrain(),
                                '/Ajout_match': (context) => AjoutMatch(),
                                '/Avis': (context) => Avis(),
                                '/modif': (context) => Modif(),
                                '/avisDev': (context) => AvisDev(),
                                '/lieuDev': (context) => LieuDev(),
                                '/Calendar': (context) => Calendar(),
                                '/password': (context) => Password(),
                                '/commentaire': (context) => Commentaire(),
                                '/test': (context) => MyApp(),
                                '/parametre': (context) => Parametre(),
                              },
                            );
                          })))));
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Problème de connection',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Problème de connection'),
          ),
          body: Center(
            child: Text('Vérifie ta connection'),
          ),
        ),
      );
    }
  }
}

// fonction pour comparer deux string et renvoye un nombre
comparestring(String mot1, String mot2) {
  // on compparre deux mots si il ont des lettre en commun on renvoie un nombre sinon on renvoie 0
  int taille1 = mot1.length;
  int compare = 0;
  for (var i = 0; i < taille1; i++) {
    String lettre1 = mot1[i];
    bool ok = mot2.contains(lettre1);
    if (ok) {
      compare++;
    }
  }
  return compare;
}
