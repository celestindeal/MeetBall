import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class   ImgModel extends Model {
  var data_img = [] ;
  int taille_img = 0;
  

  

  
  Future<String> Img() async{
    var url = 'http://51.210.103.151/get_img.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    data_img = data;
    taille_img = data.length;
  notifyListeners();
return " fin de fonction" ;
}
}


