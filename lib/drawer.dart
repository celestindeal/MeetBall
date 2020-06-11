import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/Model_co.dart';
import 'models/Model_img.dart';
import 'models/Model_match.dart';
import 'models/Model_terrain.dart';

          
class Darwer extends StatelessWidget {

   @override
  Widget build(BuildContext context) {
     return 
    
           Drawer(
          child: ListView(
            children: <Widget>[

              GestureDetector(
              onTap: (){
                ScopedModel.of<LoginModel>(context).Participation();
                 Navigator.pushNamedAndRemoveUntil(context, '/Profil', (Route<dynamic> route) => false);},
              child:Container(
                width:(MediaQuery.of(context).size.width/3),

                color: Colors.transparent,
                height:(MediaQuery.of(context).size.height/10),
               child:Center(child: Text('Profil',
              style: Theme.of(context)
                      .textTheme
                      .display1
               ),
              ),
              ),
              
              ),

Divider(color: Colors.blueGrey),

              GestureDetector(
              onTap: (){ 
                ScopedModel.of<GameModel>(context).Match();
                Navigator.pushNamedAndRemoveUntil(context, '/Match', (Route<dynamic> route) => false);},
              child:Container(
                color: Colors.transparent,
                width:(MediaQuery.of(context).size.width/3),
                height:(MediaQuery.of(context).size.height/10),
               child:Center(
                 child: Text('Rencontre',
               style: Theme.of(context)
                      .textTheme
                      .display1
               ),
               )
              ),
              ),

Divider(color: Colors.blueGrey),

              GestureDetector(
              onTap: ()async{ 
                ScopedModel.of<ImgModel>(context).Img();
                ScopedModel.of<TerrainModel>(context).Terrain();
                Navigator.pushNamedAndRemoveUntil(context, '/Terrain', (Route<dynamic> route) => false);},
              child:Container(
                color: Colors.transparent,
                width:(MediaQuery.of(context).size.width/3),
                height:(MediaQuery.of(context).size.height/10),
               child: Center(
                 child: Text('Terrain',
               style: Theme.of(context)
                      .textTheme
                      .display1
               ),
               ),
              ),
              
              ),
/*
Divider(color: Colors.blueGrey),

              GestureDetector(
              onTap: (){ Navigator.pushNamedAndRemoveUntil(context, '/Ajout_match', (Route<dynamic> route) => false);},
              child: Center(
              child:Container(
                height:(MediaQuery.of(context).size.height/10),
               child:Center(
                 child: Text('Ajouter un match',
               style: Theme.of(context)
                      .textTheme
                      .display1
               ),
               ),
              ),
              ),
              ),

Divider(color: Colors.blueGrey),

              GestureDetector(
              onTap: (){ Navigator.pushNamedAndRemoveUntil(context, '/Ajout_terrain', (Route<dynamic> route) => false);},
              child: Center(
              child:Container(
                height:(MediaQuery.of(context).size.height/10),
               child:Center(
                 child: Text('Ajouter un terrain',
               style: Theme.of(context)
                      .textTheme
                      .display1
               ),
               ),
              ),
              ),
              ),*/
Divider(color: Colors.blueGrey),

              GestureDetector(
              onTap: (){Navigator.pushNamedAndRemoveUntil(context, '/Avis', (Route<dynamic> route) => false);},
              child:Container(
                width:(MediaQuery.of(context).size.width/3),
                height:(MediaQuery.of(context).size.height/10),
                color: Colors.transparent,
               child:Center(
                 child:Text('Nous contacter',
               style: Theme.of(context)
                      .textTheme
                      .display1
               ),
               ), 
              ),
              
              ),


Divider(color: Colors.blueGrey),

              GestureDetector(
              onTap: ()async{await ScopedModel.of<LoginModel>(context).Deconnection();
                      Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
              },
              child:Container(
                width:(MediaQuery.of(context).size.width/3),
                height:(MediaQuery.of(context).size.height/10),
                color: Colors.transparent,
               child:Center(
                 child:Text('Déconnexion',
               style: Theme.of(context)
                      .textTheme
                      .display1
               ),
               ), 
              ),
              
              ),
Divider(color: Colors.blueGrey),
              ScopedModel.of<LoginModel>(context).devellopeur?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                  onTap: (){Navigator.pushNamedAndRemoveUntil(context, '/avisDev', (Route<dynamic> route) => false);},
                  child:Container(
                    height:(MediaQuery.of(context).size.height/10),
                   child:Center(
                     child:Text('avisDev',
                   style: Theme.of(context)
                          .textTheme
                          .display1
                   ),
                   ), 
                  ),
                  
                  ),
                  GestureDetector(
              onTap: (){
                ScopedModel.of<ImgModel>(context).Img();
                ScopedModel.of<TerrainModel>(context).TerrainDev();
                Navigator.pushNamedAndRemoveUntil(context, '/lieuDev', (Route<dynamic> route) => false);},
              child:Container(
                height:(MediaQuery.of(context).size.height/10),
               child:Center(
                 child:Text('lieuDev',
               style: Theme.of(context)
                      .textTheme
                      .display1
               ),
               ), 
              ),
              
              ),
                ],
              )
              
              :
              Container()
            ],
          )
      );  
  
  }
  }