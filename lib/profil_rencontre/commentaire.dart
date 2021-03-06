import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../footer.dart';
import '../main.dart';
import '../models/Model_co.dart';
import '../models/Model_match.dart';

// afficher les commentaires
// toutes les secondes on rafrechie la page pour voir si il y des nouveaux commentaires

class Commentaire extends StatefulWidget {
  @override
  _CommentaireState createState() => _CommentaireState();
}

bool attend = true;
double lastscrool = 0;

class _CommentaireState extends State<Commentaire> {
  // le controller est utiliser pour gérer le scroll
  ScrollController _scrollController = new ScrollController();
  final keyCommentainer = GlobalKey<FormState>(); // c'est pour le formulaire
  String com = "";
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Timer(Duration(microseconds: 1), () {
      if (ScopedModel.of<GameModel>(context).mmax == 20) {
        print("page init");
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    // tous les cycle on regarde
    // si ils y as des nouveaux messages et on les affiches et on mes un logos pour
    void checkForNewSharedLists() async {
      ScopedModel.of<GameModel>(context).commentaire();
      // on refait la fonction pour aller chercher les commentaire
      // si l'utilisateur a scroller en haut pour avoir plus de message
      if (_scrollController.position.pixels == 0 && attend && lastscrool > 0) {
        attend = false;
        //  _scrollController.jumpTo(10);
        // on rajoute 10 message suplementaire
        ScopedModel.of<GameModel>(context).mmax += 20;
        // calcul et placement du nouveau scroll
        double max = _scrollController.position.maxScrollExtent;
        await ScopedModel.of<GameModel>(context).commentaire();
        Timer(Duration(microseconds: 1), () {
          _scrollController
              .jumpTo(((_scrollController.position.maxScrollExtent - max)));
        });
        attend = true;
      }
      lastscrool = _scrollController.position.pixels;
    }

    // la on est à l'écoute des nouveau message
    Timer.periodic(Duration(seconds: 1), (Timer t) => checkForNewSharedLists());

// quand il y as un appuy long sur sont propre commentaire
    option_message(int id_commentaire) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () async {
                    await ScopedModel.of<GameModel>(context)
                        .supCommentaire(id_commentaire);
                    setState(() {
                      ScopedModel.of<GameModel>(context).lisCommentaire.clear();
                    });

                    ScopedModel.of<GameModel>(context).nombre =
                        0; // sela premette de reconmmencer l'affichage
                    await ScopedModel.of<GameModel>(context).commentaire();
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Retirer le commentaire",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      );
    }

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
            // affichage des messages plus le formulaire pour en envoyer d'autres
            return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // affichage des messages
                  model.lisCommentaire.length == 0
                      ? Flexible(
                          child: Container(
                            child: Text("Il n'y as pas encore de commentaire",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline3),
                          ),
                        )
                      : Flexible(
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            child: Container(
                              child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: model.lisCommentaire.length,
                                  itemBuilder: (context, i) {
                                    bool
                                        message; // vrais c'est mon commentraire faux il est pas de moi
                                    // on regarde si le commentaire est de notre utilisateur ou d'un autre
                                    if (model.lisCommentaire[i]['pseudo']
                                            .toString() ==
                                        ScopedModel.of<LoginModel>(context)
                                            .pseudo
                                            .toString()) {
                                      message = true;
                                    } else {
                                      message = false;
                                    }
                                    int imoin1(int i) {
                                      // i - 1  car j'avais un problème quand i-1 = -1
                                      if (i == 0) {
                                        return 0;
                                      }
                                      return i - 1;
                                    }

                                    return Column(
                                      children: <Widget>[
                                        Container(
                                          height: (model.lisCommentaire[i]
                                                      ['pseudo'] ==
                                                  model.lisCommentaire[
                                                      imoin1(i)]['pseudo'])
                                              ? 1
                                              : 10,
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
                                                    option_message(int.parse(
                                                        model.lisCommentaire[i]
                                                            ['id']));
                                                  }
                                                },
                                                child:
                                                    // Text(model.lisCommentaire[i]['date']),
                                                    //afficher qui à
                                                    !message
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // ne pas repetter le nom de la personne qui à commanter quand elle poste plusieur messge d'affiler
                                                              ((i != 0) &
                                                                      (model.lisCommentaire[i]
                                                                              [
                                                                              'pseudo'] ==
                                                                          model.lisCommentaire[imoin1(i)]
                                                                              [
                                                                              'pseudo']))
                                                                  ? Container()
                                                                  : Text(
                                                                      model.lisCommentaire[
                                                                              i]
                                                                          [
                                                                          'pseudo'],
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .indigo,
                                                                      ),
                                                                    ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                constraints: BoxConstraints(
                                                                    minWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        5,
                                                                    maxWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        1.1),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                  color: message
                                                                      ? Colors
                                                                          .indigo
                                                                      : Colors.amber[
                                                                          900],
                                                                ),
                                                                child: Text(
                                                                    model.lisCommentaire[
                                                                            i][
                                                                        'commentaire'],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline3),
                                                              ),
                                                            ],
                                                          )
                                                        : Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            constraints: BoxConstraints(
                                                                minWidth: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    5,
                                                                maxWidth: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1.1),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                              color: message
                                                                  ? Colors
                                                                      .indigo
                                                                  : Colors.amber[
                                                                      900],
                                                            ),
                                                            child: Text(
                                                                model.lisCommentaire[
                                                                        i][
                                                                    'commentaire'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline3),
                                                          ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),

                  // formulaire pour envoyer d'autre message
                  Form(
                    key: keyCommentainer,
                    child: Container(
                      color: Colors.indigo,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        // onTap: () async {
                        //   print("scroll");
                        //   // quand on écrit un message on affiche les derniers messages
                        //   print("one tap textfield");
                        //   // attendre que le clavier soit ouvert
                        //   Timer(Duration(seconds: 1), () {
                        //     _scrollController.jumpTo(
                        //         _scrollController.position.maxScrollExtent);
                        //   });
                        // },
                        controller: _controller,
                        autocorrect: true,
                        cursorColor: Colors.white,
                        style: TextStyle(
                            color: Colors.white, decorationColor: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Ecrivez un message...',
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            // envoyer le message et l'afficher
                            onPressed: () async {
                              if (keyCommentainer.currentState.validate() &
                                  (com != "")) {
                                await ScopedModel.of<GameModel>(context)
                                    .ajouterCommentaire(com, login.pseudo);
                                await ScopedModel.of<GameModel>(context)
                                    .commentaire();
                                com = null;
                                _controller.clear();
                                Timer(Duration(seconds: 1), () {
                                  _scrollController.jumpTo(_scrollController
                                      .position.maxScrollExtent);
                                });
                                setState(() {
                                  com = "";
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                });
                              }
                            },
                            icon: (com == "") ? Container() : Icon(Icons.send),
                            color: Colors.white,
                          ),
                        ),
                        // validator: (value) {
                        //   if (value.isEmpty) {
                        //     return 'Commentaire';
                        //   }
                        //   return null;
                        // },
                        onChanged: (value) {
                          setState(() {
                            com = value;
                          });
                        },
                      ),
                    ),
                  ),
                ]);
          });
        }));
  }
}
