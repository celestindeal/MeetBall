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

class _CommentaireState extends State<Commentaire> {
 

  ScrollController _scrollController = new ScrollController();
    final key_commentainer = GlobalKey<FormState>();
    String com;
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 1), () {
      if (ScopedModel.of<LoginModel>(context).boParticipation &&
          ScopedModel.of<GameModel>(context).commentaire.length >= 1) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Commentaire"),
          ),
          backgroundColor: Colors.indigo,
      
        ),
        // backgroundColor: Colors.black,
        persistentFooterButtons: <Widget>[
          Footer(),
        ],
        backgroundColor: back,
        body: ScopedModelDescendant<LoginModel>(builder: (context, child, login) {
        return ScopedModelDescendant<GameModel>(
            builder: (context, child, model) {
          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(children: <Widget>[
                              model.bocommentaire
                                  ? Column(
                                      children: <Widget>[
                                        Divider(color: Colors.grey[300]),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          color: Colors.grey,
                                          child: ListView.builder(
                                              controller: _scrollController,
                                              itemCount:
                                                  model.commentaire.length,
                                              itemBuilder: (context, i) {
                                                bool message;
                                                if (model.commentaire[i]
                                                            ['pseudo']
                                                        .toString() ==
                                                    ScopedModel.of<LoginModel>(
                                                            context)
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
                                                          ? MainAxisAlignment
                                                              .end
                                                          : MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child:
                                                              GestureDetector(
                                                            onLongPress: () {
                                                              if (message) {}
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
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
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                      model.commentaire[
                                                                              i]
                                                                          [
                                                                          'commentaire'],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .display3),
                                                                  Text(model
                                                                          .commentaire[i]
                                                                      [
                                                                      'pseudo']),
                                                                  Text(model
                                                                          .commentaire[i]
                                                                      ['date']),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 10,
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                      ],
                                    )
                                  : Container(),

                              // formulaire pour commenter
                              Form(
                                key: key_commentainer,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      color: Colors.indigo,
                                      child: TextFormField(
                                        autocorrect: true,
                                        cursorColor: Colors.white,
                                        style: TextStyle(
                                            color: Colors.white,
                                            decorationColor: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: 'Ecrivez un message...',
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          suffixIcon: IconButton(
                                            onPressed: () async {
                                              if (key_commentainer.currentState
                                                  .validate()) {
                                                await ScopedModel.of<GameModel>(
                                                        context)
                                                    .Ajouter_ommentaire(
                                                        com, login.pseudo);
                                                await ScopedModel.of<GameModel>(
                                                        context)
                                                    .Commentaire();
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
                                  ],
                                ),
                              ),
                            ]),
                          );
            }
        );
        }
        )
        );
  }
}
