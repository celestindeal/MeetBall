import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/Model_co.dart';
import 'models/Model_img.dart';
import 'models/Model_match.dart';
import 'models/Model_terrain.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
              icon: Image.asset(
                'img/icon.jpg',
                width: 40,
                height: 40,
              ),
              onPressed: () {
                ScopedModel.of<LoginModel>(context).ParticipationProil();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/Profil', (Route<dynamic> route) => false);
              }),
          IconButton(
              icon: Image.asset(
                'img/rencontre.png',
                width: 40,
                height: 40,
              ),
              onPressed: () {
                ScopedModel.of<GameModel>(context).Match();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/Match', (Route<dynamic> route) => false);
              }),
          IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: Colors.black,
              ),
              onPressed: () {
                ScopedModel.of<GameModel>(context).MatchCalendar();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/Calendar', (Route<dynamic> route) => false);
              }),
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                ScopedModel.of<ImgModel>(context).Img();
                ScopedModel.of<TerrainModel>(context).Terrain();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/Rechercher', (Route<dynamic> route) => false);
              }),
        ],
      ),
    );
  }
}
