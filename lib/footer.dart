import 'package:flutter/material.dart';
import 'package:meetballl/calendar.dart';
import 'package:meetballl/profil.dart';
import 'package:meetballl/rechercher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';
import 'models/Model_match.dart';
import 'models/Model_terrain.dart';

Color bouton = Colors.amber[900];


class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: ScopedModel.of<LoginModel>(context).page == 1
                  ? bouton
                  : Colors.transparent,
            ),
            child: IconButton(
                icon: Image.asset(
                  'img/icon.jpg',
                  width: 40,
                  height: 40,
                ),
                onPressed: () {
                  
                    ScopedModel.of<LoginModel>(context).ParticipationProil();
                  
                  Navigator.of(context).push(_createRouteprofil(context));
                }),
          ),
          Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: ScopedModel.of<LoginModel>(context).page == 2
                  ? bouton
                  : Colors.transparent,
            ),
            child: IconButton(
                icon: Image.asset(
                  'img/rencontre.png',
                  width: 40,
                  height: 40,
                ),
                onPressed: () {
                  
                    ScopedModel.of<GameModel>(context).MatchCalendar();
                 

                  Navigator.of(context).push(_createRouterencontre(context));
                }),
          ),
          Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: ScopedModel.of<LoginModel>(context).page == 3
                  ? bouton
                  : Colors.transparent,
            ),
            child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  ScopedModel.of<ImgModel>(context).Img();
                  ScopedModel.of<TerrainModel>(context).Terrain();
                  Navigator.of(context).push(_createRouterecherche(context));
                }),
          ),
        ],
      ),
    );
  }
}

Route _createRouteprofil(BuildContext context) {
  ScopedModel.of<LoginModel>(context).page = 1;
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Profil(),
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Route _createRouterencontre(BuildContext context) {
  ScopedModel.of<LoginModel>(context).page = 2;
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Calendar(),
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Route _createRouterecherche(BuildContext context) {
  ScopedModel.of<LoginModel>(context).page = 3;
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Rechercher(),
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
