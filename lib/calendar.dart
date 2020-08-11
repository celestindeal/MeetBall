import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meetballl/footer.dart';
import 'package:meetballl/main.dart';
import 'package:meetballl/models/Model_co.dart';
import 'package:meetballl/models/Model_img.dart';
import 'package:meetballl/models/Model_match.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Calendar> with TickerProviderStateMixin {
  Map<DateTime, List> _events = {};
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents = events;
    });
  }
   void _onDaySelectedlong(DateTime day, List events) {
   Navigator.pushNamed(context, '/Ajout_match');
   ScopedModel.of<GameModel>(context).Initdate('${day.day}-${day.month}-${day.year}','${day.hour}:${day.minute}');
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 0),
      () {
        setState(() {
          _events = ScopedModel.of<GameModel>(context).events;
        });
      },
    );
    return Scaffold(
      appBar: AppBar(
         centerTitle: true,
    title:   Text("Rencontre"),
        backgroundColor: Colors.indigo,
        leading: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/Ajout_match');
            }),
        
      ),
      persistentFooterButtons: <Widget>[
        Footer(),
      ],
      backgroundColor: back,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: 'fr_FR',
      availableCalendarFormats: const {
        CalendarFormat.month: 'Mois',
        CalendarFormat.week: 'Semaine',
      },
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        weekdayStyle: TextStyle().copyWith( fontSize: 20.0),
        weekendStyle: TextStyle().copyWith(color:Colors.deepOrange[400], fontSize: 25.0),
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.indigo,
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 25.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onDayLongPressed :  _onDaySelectedlong,
      calendarController: _calendarController,
      events: _events,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
    title:  Text(event['lieu'].toString() +
                      " à " +
                      event['heure'].toString()),
                  trailing: Container(
                    width: 40,
                    child: Row(
                      children: <Widget>[
                        Text(event['nombre_j'].toString() + " ",
                            softWrap: true,
                            style: Theme.of(context).textTheme.display3),
                        Icon(
                          Icons.people,
                          color: Colors.red,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    // on sélection la rencontre choisir
                    ScopedModel.of<GameModel>(context).lieu = event['lieu'];
                    ScopedModel.of<GameModel>(context).id_rencontre =
                        event['id'];
                    ScopedModel.of<GameModel>(context).nombJoueur =
                        int.parse(event['nombre_j'].toString());
                    ScopedModel.of<GameModel>(context).daterencontre =
                        event['jours'];
                    ScopedModel.of<GameModel>(context).heurerencontre =
                        event['heure'];
                    

                    // on prepare les image terrain et commentaire pour la page profil rencontre
                    ScopedModel.of<ImgModel>(context).Img();
                    ScopedModel.of<GameModel>(context).Terrain();
                    ScopedModel.of<GameModel>(context).Commentaire();

                    await ScopedModel.of<LoginModel>(context)
                        .Personne_propose(event['id']);

                    //  model.rencontre_visualiser = model.data_game[i]['id'];
                    Navigator.pushNamed(context, '/Profil_renctontre');
                  },
                ),
              ))
          .toList(),
    );
  }
}
