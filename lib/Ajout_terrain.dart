import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appBar.dart';
import 'drawer.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_match.dart';
import 'models/Model_terrain.dart';

 String nom;
 String adresse;
 String ville;
 int nombre_terrain;
  String sol = " ";
 String ouverture=" ";

class Ajout_terrain extends StatefulWidget {
  @override
  _Ajout_terrainState createState() => _Ajout_terrainState();
}

class _Ajout_terrainState extends State<Ajout_terrain> {
  final _formKey = GlobalKey<FormState>();

  File image ;
  String base64Image = "";
  bool afficher = false;

  Future<void> _choisirimage (BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text('choisi entre'),
        content:SingleChildScrollView(
          child: ListBody(
           children: <Widget>[
             GestureDetector(
               child:Text("galerie"),
               onTap: ()async{
                 Navigator.of(context).pop();
                     image = await ImagePicker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      image = image;
                      afficher = true;
                    });
                  List<int> imageBytes = image.readAsBytesSync();
                   base64Image = base64Encode(imageBytes);
                    
               },
             ),
             Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
               child:Text("caméra"),
               onTap: ()async{
                 Navigator.of(context).pop();
                     image = await ImagePicker.pickImage(source: ImageSource.camera);
                    setState(() {
                        image = image;
                      afficher = true;
                    });
                  List<int> imageBytes = image.readAsBytesSync();
                   base64Image = base64Encode(imageBytes);
                    
               },
             )
           ] 
          )
        )
      );
    });
  }

 

    @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: headerNav(context),
      persistentFooterButtons: <Widget>[
                    Footer(),
                  ],     
      drawer: Darwer(),
       // backgroundColor: Colors.black54,
       
    body:        
    ScopedModelDescendant<GameModel>(
          builder:(context, child, model){
            return

                        Form(
              key: _formKey,
              child:SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[


                    TextFormField(
                    cursorColor: Colors.black54, 
                    style: TextStyle(color: Colors.white, decorationColor:  Colors.white  ),
                    decoration: const InputDecoration(
                      hintText: 'nom',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {return 'Please enter some text'; } return null;},
                      onChanged: (value){
                        nom = value;
                      },
                    ),
                    TextFormField(
                    cursorColor: Colors.black54, 
                    style: TextStyle(color: Colors.white, decorationColor:  Colors.white  ),
                    decoration: const InputDecoration(
                      hintText: 'adresse',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {return 'Please enter some text'; } return null;},
                      onChanged: (value){
                        adresse = value;
                      },
                    ),
                    TextFormField(
                    cursorColor: Colors.black54, 
                    style: TextStyle(color: Colors.white, decorationColor:  Colors.white  ),
                    decoration: const InputDecoration(
                      hintText: 'ville',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {return 'Please enter some text'; } return null;},
                      onChanged: (value){
                        ville = value;
                      },
                    ),
                    TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    cursorColor: Colors.black54, 
                    style: TextStyle(color: Colors.white, decorationColor:  Colors.white  ),
                    decoration: const InputDecoration(
                      hintText: 'nombre de terrain',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {return 'Please enter some text'; } return null;},
                      onChanged: (value){
                        nombre_terrain = int.parse(value);
                      },
                    ),
                    TextFormField(
                    cursorColor: Colors.black54, 
                    style: TextStyle(color: Colors.white, decorationColor:  Colors.white  ),
                    decoration: const InputDecoration(
                      hintText: 'Nature du sol',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {return 'Please enter some text'; } return null;},
                      onChanged: (value){
                        sol = value;
                      },
                    ),
                    TextFormField(
                    cursorColor: Colors.black54, 
                    style: TextStyle(color: Colors.white, decorationColor:  Colors.white  ),
                    decoration: const InputDecoration(
                      hintText: 'Ouverture',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {return 'Please enter some text'; } return null;},
                      onChanged: (value){
                        ouverture = value;
                      },
                    ),
                     Center(
                  child:RaisedButton(
                    onPressed: () {
                      _choisirimage(context);
                      },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                        'photo',
                        style: TextStyle(fontSize: 20)
                      ),
                    ),
                  )
                ),
                afficher?
                Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        child:Image.file(image,width:400,height:400,)
                      )
                    ),
                    RaisedButton(
                      child: Text("annuler"),
                      onPressed: (){
                        setState(() {
                           image =null ;
                         base64Image = "";
                        afficher = false;
                        });
                      }
                      )
                  ],
                )
                :
                Center(
                  child: Container(
                    child: Text("tu n'a pas choisi d'image"), 
                  )
                ),
                  Center(
                    child:Padding( 
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () async{
                        if (_formKey.currentState.validate()) {
                          
                        //    await ScopedModel.of<GameModel>(context).Ajout_match( lieuchoisi , _date , _time , nombre_jo,pseudo);
                             ScopedModel.of<TerrainModel>(context).AjouterTerrain( nom,  adresse, ville,  nombre_terrain,base64Image,sol,ouverture);
                        
                            ScopedModel.of<GameModel>(context).Match();
                            Navigator.pushNamedAndRemoveUntil(context, '/Match', (Route<dynamic> route) => false);
                        }
                      },
                      child: Text('proposer'),
                    ),
                  ),
                  ),
                  Center(
                    child:Text("votre terrain sera rajouter à la liste après validation par notre équipe", textAlign: TextAlign.center , style: TextStyle( 
                          fontSize: 16.0, 
                          
                          color: Colors.white70,
                          decorationColor:  Colors.white,
                          fontWeight: FontWeight.w800,
                           fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          )
                      ) 
                  )
                  
                ],
              ),
              )
            );

        })
        
  
      );
  
    }
}
              
