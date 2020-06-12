import 'package:flutter/material.dart';
import 'package:meetballl/profil.dart';
import 'package:meetballl/profil_rencontre.dart';
import 'package:meetballl/terrain.dart';
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

void main(){
  runApp( new Main());
  
}

/*
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}




class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    
    return
    MaterialApp(
    debugShowCheckedModeBanner: false,
     home: SplashScreen(
      seconds: 14,
      navigateAfterSeconds: new Main(),
      title: new Text('Bienvenue sur MeetBall',
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0
      ),),
      image: new  Image.asset(
                'img/balise.png',
              ),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.blue
    ),
    );
  }
}*/
bool mode = true;

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: ImgModel(),
        child: ScopedModel(
            model: TerrainModel(),
            child: ScopedModel(
                model: GameModel(),
                child: ScopedModel(
                    model: LoginModel(),
                    child: mode
                        ? MaterialApp(
                            debugShowCheckedModeBanner: false,
                            theme: ThemeData(
                              brightness: Brightness.dark,
                              primarySwatch: Colors.blueGrey,
                              accentColor: Colors.blue,
                              fontFamily: 'Montserrat',
                              textTheme: TextTheme(
                                body1: TextStyle(fontSize: 10.0),
                                body2: TextStyle(fontSize: 16.0),
                                display1: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.red,
                                    decorationColor: Colors.white), // darwer
                                display2: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white70,
                                  decorationColor: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.5,
                                ), //text stiler
                                display3: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    decorationColor:
                                        Colors.black), //text Classe
                                display4: TextStyle(
                                  fontSize: 32.0,
                                  inherit: false,
                                  letterSpacing: 0.5,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            initialRoute: '/',
                            routes: {
                              '/': (context) => Accueil(),
                              '/inscription': (context) => Inscription(),
                              '/Profil': (context) => Profil(),
                              '/Match': (context) => Match(),
                              '/Profil_renctontre': (context) =>
                                  Profil_renctontre(),
                              '/Terrain': (context) => Terrain(),
                              '/Ajout_terrain': (context) => Ajout_terrain(),
                              '/Ajout_match': (context) => Ajout_match(),
                              '/Avis': (context) => Avis(),
                              '/modif': (context) => Modif(),
                              '/avisDev': (context) => AvisDev(),
                              '/lieuDev': (context) => LieuDev(),
                              '/test': (context) => MyHomePage(),
                            },
                          )
                        : MaterialApp(
                            theme: ThemeData(
                              brightness: Brightness.light,
                              primarySwatch: Colors.blueGrey,
                              accentColor: Colors.blue,
                              fontFamily: 'Montserrat',
                              textTheme: TextTheme(
                                body1: TextStyle(fontSize: 10.0),
                                body2: TextStyle(fontSize: 16.0),
                                display1: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.red,
                                    decorationColor: Colors.white), // darwer
                                display2: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white70,
                                  decorationColor: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.5,
                                ), //text stiler
                                display3: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    decorationColor:
                                        Colors.white), //text Classe
                                display4: TextStyle(
                                  fontSize: 32.0,
                                  inherit: false,
                                  letterSpacing: 0.5,
                                  color: Colors.red,
                                ),
                              ),
                            ),
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
                              '/Ajout_terrain': (context) => Ajout_terrain(),
                              '/Ajout_match': (context) => Ajout_match(),
                              '/Avis': (context) => Avis(),
                              '/modif': (context) => Modif(),
                              '/avisDev': (context) => AvisDev(),
                              '/lieuDev': (context) => LieuDev(),
                              '/test': (context) => MyHomePage(),
                            },
                          )))));
  }
}
