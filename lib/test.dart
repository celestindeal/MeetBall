import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

String tkt = "location";

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

double lat2 = 0;
double lon2 = 0;
double lon1;
double lat1;
String lieu = "https://www.google.fr/maps/place/46%C2%B002'01.1%22N+3%C2%B059'55.7%22E/@46.0336319,3.9982498,18z/data=!4m5!3m4!1s0x0:0x0!8m2!3d46.0336389!4d3.9988056";

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Carousel in vertical scrollable'),
        ),
        body: Column(
          children: <Widget>[
            Text(tkt),
            RaisedButton(
              onPressed: () async {
                var location = new Location();
                var currentLocation = await location.getLocation();
                setState(() {

                  String valueString = "/"+ lieu.toString().split('@')[1].split('/')[0];
                  int nombrecar = valueString.length;
                  String valuelieu = valueString.substring(0,nombrecar-1);
                  lon2 = double.parse(valuelieu.toString().split('/')[1].split(',')[0]);
                  lat2 = double.parse(valuelieu.toString().split(',')[1]);
                  lat1 = currentLocation.latitude;
                  lon1 = currentLocation.longitude;
                  int rayon = 6371; // radius of the earth in km
                  double x = (lon2 - lon1) * cos(0.5 * (lat2 + lat1));
                  double y = lat1 - lat2;
                  double distance =  1.852 * 60 * sqrt((x * x + y * y));
                  tkt = distance.toString();
                });
              },
              child: Text('location'),
            )
          ],
        ));
  }
}
