import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'footer.dart';
import 'main.dart';
import 'models/Model_co.dart';
import 'models/Model_match.dart';

class Commentaire extends StatefulWidget {
  @override
  _CommentaireState createState() => _CommentaireState();
}

bool attend = true ;

class _CommentaireState extends State<Commentaire> {
  ScrollController _scrollController = new ScrollController();
  final key_commentainer = GlobalKey<FormState>();
  String com;
  var _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {

    void checkForNewSharedLists() async {
      // on refait la fonction pour aller chercher les commentaire
      await ScopedModel.of<GameModel>(context).Commentaire();
      // si il y as un nouveau commentainer  on scroll la page pour voir le nouveau com
      if (ScopedModel.of<GameModel>(context).scrool) {
        ScopedModel.of<GameModel>(context).scrool = false;
        Timer(Duration(microseconds: 1), () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
      // si l'utilisateur a scroller en haut pour avoir plus de message 
      if(_scrollController.position.pixels==0  && attend){
        attend = false;
         _scrollController.jumpTo(10);
         // on rajoute 10 message suplementaire 
        ScopedModel.of<GameModel>(context).mmax = ScopedModel.of<GameModel>(context).mmax +10;
        // calcul et placement du nouveau scroll
        double max = _scrollController.position.maxScrollExtent;
        await ScopedModel.of<GameModel>(context).Commentaire();
        Timer(Duration(microseconds: 1), () {
            _scrollController.jumpTo((_scrollController.position.maxScrollExtent-max+10));
            attend = true;                                                                                                                                                                                                                                                                                                                                                              
        });
      }
    }


  // la on est à l'écoute des nouveau message 
    Timer.periodic(Duration(seconds: 1), (Timer t) => checkForNewSharedLists());

 // init page
    Timer(Duration(microseconds: 1), () {
      if (ScopedModel.of<LoginModel>(context).boParticipation) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        ScopedModel.of<GameModel>(context).Commentaire();
      }
    });
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Commentaire"),
          backgroundColor: Colors.indigo,
        ),
        // backgroundColor: Colors.black,
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        backgroundColor: back,
        body:
            ScopedModelDescendant<LoginModel>(builder: (context, child, login) {
          return ScopedModelDescendant<GameModel>(
              builder: (context, child, model) {
            return SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: <
                      Widget>[
                Container(
                  height: (MediaQuery.of(context).size.height - 200),
                  color: Colors.transparent,
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: model.commentaire.length,
                      itemBuilder: (context, i) {
                        bool message;
                        if (model.commentaire[i]['pseudo'].toString() ==
                            ScopedModel.of<LoginModel>(context)
                                .pseudo
                                .toString()) {
                          message = true;
                        } else {
                          message = false;
                        }

                        

                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: message
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: GestureDetector(
                                    onLongPress: () {
                                      if (message) {}
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),

                                      constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5,
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.1),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: message
                                            ? Colors.indigo
                                            : Colors.amber[900],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                              model.commentaire[i]
                                                  ['commentaire'],
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .display3),
                                          Text(model.commentaire[i]['pseudo']),
                                          Text(model.commentaire[i]['date']),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: 10,
                            ),
                          ],
                        );
                      }),
                ),

                // formulaire pour commenter
                Form(
                  key: key_commentainer,
                  child: Container(
                    color: Colors.indigo,
                    child: TextFormField(
                      controller: _controller,
                      autocorrect: true,
                      cursorColor: Colors.white,
                      style: TextStyle(
                          color: Colors.white, decorationColor: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Ecrivez un message...',
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            if (key_commentainer.currentState.validate()) {
                              await ScopedModel.of<GameModel>(context)
                                  .Ajouter_ommentaire(com, login.pseudo);
                              await ScopedModel.of<GameModel>(context).Commentaire();
                              com = null;
                              _controller.clear();
                              Timer(Duration(seconds: 1), () {
                                if (ScopedModel.of<LoginModel>(context)
                                    .boParticipation) {
                                  _scrollController.jumpTo(_scrollController
                                      .position.maxScrollExtent);
                                }
                              });
                            }
                          },
                          icon: Icon(Icons.send),
                          color: Colors.white,
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        com = value;
                      },
                    ),
                  ),
                ),
              ]),
            );
          });
        }));
  }
}
