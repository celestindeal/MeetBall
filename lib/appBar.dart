

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/Model_co.dart';





 
 AppBar headerNav(context,) {
  
 
  return AppBar(
    title: Text("BasketCopie"),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey,
                    ),
                    child:Column(
                      children: <Widget>[
                        RaisedButton(child:Text("CONDITIONS GÉNÉRALES D’UTILISATION"),
                          onPressed: ()async{
                            if (await canLaunch("http://51.210.103.151/conditions.php")) {
                                                await launch("http://51.210.103.151/conditions.php");
                                              } else {
                                                print("http://51.210.103.151/conditions.php");
                                              }
                          }),
                          RaisedButton(child:Text("POLITIQUE DE CONFIDENTIALITÉ"),
                          onPressed: ()async{
                            if (await canLaunch("http://51.210.103.151/confidentialite.php")) {
                                                await launch("http://51.210.103.151/confidentialite.php");
                                              } else {
                                                print("http://51.210.103.151/confidentialite.php");
                                              }
                          }),
                        RaisedButton(child:Text("changer de mode"),
                          onPressed: (){
                            ScopedModel.of<LoginModel>(context).changeMode();
                            Navigator.of(context).pop();
                          }),
                      ],
                    )
                  ),
                );
              });
            },
          );
        },
      ),
    ],
  );
}
