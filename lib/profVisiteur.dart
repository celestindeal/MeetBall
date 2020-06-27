import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meetballl/db.dart';
import 'package:meetballl/models/Model_terrain.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';

var now = new DateTime.now();
bool rencontre = true;
bool chnagecouleur = false;

class ProfilVisiteur extends StatefulWidget {
  @override
  _ProfilVisiteurState createState() => _ProfilVisiteurState();
}

class _ProfilVisiteurState extends State<ProfilVisiteur> {


  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
    title: Center( child : Text( ScopedModel.of<LoginModel>(context).profVisiteur['pseudo']),),
    backgroundColor: Colors.indigo,
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          sdialog(context);
                  },
                ),
              ],
            ),
                  persistentFooterButtons: <Widget>[
                    Footer(),
                  ],
                  body: SingleChildScrollView(child:
                      Center(
                        child: ScopedModelDescendant<LoginModel>(builder: (context, child, model) {
          // calcule de l'age
                    var ms = (new DateTime.now()).millisecondsSinceEpoch;
                    String ok = "}" + model.profVisiteur['age'].toString() + "/";
                    int ans = int.parse(ok.split('}')[1].split('-')[0]);
                    int mois = int.parse(ok.split('-')[1].split('-')[0]);
                    int jour = int.parse(ok.split('-')[1].split('/')[0]);
                    var mst = new DateTime.utc(ans, mois, jour, 20, 18, 04)
                          .millisecondsSinceEpoch;
                    int ageAnne = ((ms - mst) / (365 * 24 * 3600 * 1000)).toInt();
                    return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                    
                                    GestureDetector(
                                      onTap: () {
                                        return showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return 
                                                  Container(
                                                      child: PhotoView(
                                                      imageProvider:
                                                          NetworkImage(model.profVisiteur['photo']),
                                                    )
                                                 );
                                            });
                                      },
                                    
                                      child: CircleAvatar(
                                        backgroundImage: 
                                             NetworkImage(model.profVisiteur['photo']),
                                        radius: MediaQuery.of(context).size.width / 4,
                                      ),
                                    ),
                                 
                              
                                Container(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context).size.width / 1.8,
                                          height: MediaQuery.of(context).size.height / 3,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 50,
                                                    ),
                                                    Text(model.profVisiteur['nom'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display3),
                                                    Text(model.profVisiteur['prenom'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display3),
                                                    Text(ageAnne.toString() + " ans",
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display3),
                                                    Text(model.profVisiteur['club'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display3),
                                                    Text(model.profVisiteur['niveaux'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display3),
                                                    Container(
                                                      height: 10,
                                                    ),
                                                    Text(model.profVisiteur['message'],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display3),
                                                  ]),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                     
                        
                          ]);
                  }),
                      )));
            }
          }
          
      
