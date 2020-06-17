import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';
import 'appBar.dart';
import 'drawer.dart';
import 'footer.dart';
import 'models/Model_co.dart';
import 'models/Model_match.dart';
import 'models/Model_terrain.dart';
String lieuchoisi = "choix du lieu";
  List<String> reportList = [
    "Not relevant",
    "Illegal",
    "Spam",
    "Offensive",
    "Uncivil"
  ];
  String _date = "date";
  String _time = "heure";
var nombre_jo ;
var pseudo;


class Ajout_match extends StatefulWidget {
  @override
  _Ajout_matchState createState() => _Ajout_matchState();
}
class _Ajout_matchState extends State<Ajout_match> {
      final _formKey = GlobalKey<FormState>();
  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("choisi ton lieu"),
            content:MultiSelectChip(reportList),
           actions: <Widget>[
              FlatButton(
                child: Text("valider"),
                onPressed: () {
                  setState(() {
                   
                  });
                  Navigator.of(context).pop();
                  }
              )
            ],
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
     Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            RaisedButton(
              padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                 onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(2030, 12, 31),
                      theme: DatePickerTheme(
                          headerColor: Colors.red,
                          // backgroundColor: Colors.blue,
                          itemStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                          doneStyle: TextStyle(color: Colors.black, fontSize: 16)),
                      onChanged: (date) {
                  }, onConfirm: (date) {
                    _date = '${date.year}-${date.month}-${date.day}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.fr);
                }, child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                                Text(
                                  " $_date",
                                  style: TextStyle(
                                      color: Colors.white,
                                     
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
                color: Colors.black,
              ),
             /* SizedBox(
                height: 20.0,
              ),
             */ RaisedButton(
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(context,
                   theme: DatePickerTheme(
                          headerColor: Colors.red,
                          // backgroundColor: Colors.blue,
                          itemStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                          doneStyle: TextStyle(color: Colors.black, fontSize: 16)),
                    
                      showTitleActions: true, onConfirm: (time) {
                    _time = '${time.hour}:${time.minute}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.fr);
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                                Text(
                                  " $_time",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                color: Colors.black,
              ),
              

           ScopedModelDescendant<GameModel>(
          builder:(context, child, model){
            return 
            ScopedModelDescendant<LoginModel>(
            builder:(context, child, model){
             
              pseudo = model.pseudo;
             return                 
            Form(
              key: _formKey,
              child:SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                    RaisedButton(
                      child: Text("lieu"),
                      onPressed: () async {   
                          await ScopedModel.of<TerrainModel>(context).List();
                          reportList = ScopedModel.of<TerrainModel>(context).nomlist;
                      _showReportDialog();
                      }
                    ),
                    Text(lieuchoisi),

                    TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    cursorColor: Colors.black54, 
                    style: TextStyle(color: Colors.white, decorationColor:  Colors.white  ),
                    decoration: const InputDecoration(
                      hintText: 'nombre de joueurs',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {return 'Please enter some text'; } return null;},
                      onChanged: (value){
                        nombre_jo = value;
                      },
                    ),
                  Padding(
                    
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () async{
                        if (_formKey.currentState.validate()) {
                          
                            await ScopedModel.of<GameModel>(context).Ajout_match( lieuchoisi , _date , _time , nombre_jo,pseudo);
                            await ScopedModel.of<GameModel>(context).Match();
                            Navigator.pushNamedAndRemoveUntil(context, '/Match', (Route<dynamic> route) => false);
                        }
                      },
                      child: Text('proposer'),
                    ),
                  ),
                ],
              ),
              )
            );
        });
        })
            ],
          ),
        ),
      )
      );
    }
}
              



              
class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;  MultiSelectChip(this.reportList);  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}class _MultiSelectChipState extends State<MultiSelectChip> {
  String selectedChoice = "";  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = List();    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
              lieuchoisi = item;
            });
          },
        ),
      ));
    });    
    return choices;
  }  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}