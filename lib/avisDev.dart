import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';

class AvisDev extends StatefulWidget {
  @override
  _AvisDevState createState() => _AvisDevState();
}

class _AvisDevState extends State<AvisDev> {
  double douTaille;
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width <
        MediaQuery.of(context).size.height) {
      setState(() {
        douTaille = MediaQuery.of(context).size.width;
      });
    } else {
      setState(() {
        douTaille = MediaQuery.of(context).size.width;
      });
    }
    return Scaffold(
         appBar: AppBar(
    title:Center( child : Text("MeetBall"),),
    backgroundColor: Colors.indigo,
    leading: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/Ajout_match', (Route<dynamic> route) => false);
        }),

  ),
        // backgroundColor: Colors.black,
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        backgroundColor: back,
        body: 
            ScopedModelDescendant<LoginModel>(builder: (context, child, model) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: model.lisAvisDev.length,
              itemBuilder: (context, i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: douTaille / 4,
                        child: Text(model.lisAvisDev[i]["pseudo"],
                            softWrap: true,
                            style: Theme.of(context).textTheme.bodyText1)),
                    GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.grey,
                                    ),
                                    child: Text(
                                        model.lisAvisDev[i]["commentaire"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ),
                                );
                              });
                            },
                          );
                        },
                        child: Container(
                            width: douTaille / 2,
                            child: Text(model.lisAvisDev[i]["commentaire"],
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Theme.of(context).textTheme.bodyText1))),
                    Container(
                        width: douTaille / 4,
                        child: Text(model.lisAvisDev[i]["date"],
                            softWrap: true,
                            style: Theme.of(context).textTheme.bodyText1)),
                  ],
                );
              });
        }));
  }
}
