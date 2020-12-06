import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../footer.dart';
import '../main.dart';
import '../models/Model_co.dart';
import '../models/Model_match.dart';

class Commentaire extends StatefulWidget {
  @override
  _CommentaireState createState() => _CommentaireState();
}

bool attend = true;
double lastscrool = 0;

class _CommentaireState extends State<Commentaire> {
  ScrollController _scrollController = new ScrollController();
  final keyCommentainer = GlobalKey<FormState>();
  String com;
  var _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_element
    void checkForNewSharedLists() async {
      // on refait la fonction pour aller chercher les commentaire
      ScopedModel.of<GameModel>(context).commentaire();
      // si il y as un nouveau commentainer  on scroll la page pour voir le nouveau com
      if (ScopedModel.of<GameModel>(context).scrool) {
        ScopedModel.of<GameModel>(context).scrool = false;
        Timer(Duration(microseconds: 1), () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
      // si l'utilisateur a scroller en haut pour avoir plus de message

      if (_scrollController.position.pixels == 0 && attend && lastscrool > 0) {
        attend = false;
        //  _scrollController.jumpTo(10);
        // on rajoute 10 message suplementaire
        ScopedModel.of<GameModel>(context).mmax =
            ScopedModel.of<GameModel>(context).mmax + 10;
        // calcul et placement du nouveau scroll
        double max = _scrollController.position.maxScrollExtent;
        await ScopedModel.of<GameModel>(context).commentaire();
        Timer(Duration(microseconds: 10), () {
          _scrollController
              .jumpTo((_scrollController.position.maxScrollExtent - max));
          attend = true;
        });
      }
      lastscrool = _scrollController.position.pixels;
    }

    // la on est à l'écoute des nouveau message
    // Timer.periodic(Duration(seconds: 1), (Timer t) => checkForNewSharedLists());

    // init page
    Timer(Duration(microseconds: 1), () {
      if (ScopedModel.of<LoginModel>(context).boParticipation) {
        // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        ScopedModel.of<GameModel>(context).commentaire();
      }
    });

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Commentaire"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo,
        ),
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
                  child: model.lisCommentaire.length == 0
                      ? Text("Il n'y as pas encore de commentaire",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3)
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: model.lisCommentaire.length,
                          itemBuilder: (context, i) {
                            bool message;

                            if (model.lisCommentaire[i]['pseudo'].toString() ==
                                ScopedModel.of<LoginModel>(context)
                                    .pseudo
                                    .toString()) {
                              message = true;
                            } else {
                              message = false;
                            }
                            return Column(
                              children: <Widget>[
                                Container(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: message
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: GestureDetector(
                                        onLongPress: () {
                                          if (message) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter setState) {
                                                  return Center(
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: RaisedButton(
                                                        onPressed: () async {
                                                          await ScopedModel.of<
                                                                      GameModel>(
                                                                  context)
                                                              .supCommentaire(
                                                                  int.parse(model
                                                                          .lisCommentaire[
                                                                      i]['id']));
                                                          setState(() {
                                                            ScopedModel.of<
                                                                        GameModel>(
                                                                    context)
                                                                .lisCommentaire
                                                                .clear();
                                                          });

                                                          ScopedModel.of<GameModel>(
                                                                      context)
                                                                  .nombre =
                                                              0; // sela premette de reconmmencer l'affichage
                                                          await ScopedModel.of<
                                                                      GameModel>(
                                                                  context)
                                                              .commentaire();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                                "Retirer le commentaire",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline3),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                              },
                                            );
                                          }
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
                                                  model.lisCommentaire[i]
                                                      ['commentaire'],
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline3),
                                              Text(model.lisCommentaire[i]
                                                  ['pseudo']),
                                              Text(model.lisCommentaire[i]
                                                  ['date']),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 10,
                                )
                              ],
                            );
                          }),
                ),

                // formulaire pour commenter
                Form(
                  key: keyCommentainer,
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
                            if (keyCommentainer.currentState.validate()) {
                              await ScopedModel.of<GameModel>(context)
                                  .ajouterCommentaire(com, login.pseudo);
                              await ScopedModel.of<GameModel>(context)
                                  .commentaire();
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
