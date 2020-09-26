import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ImgModel extends Model {
  var vaDataImg = [];
  int inTailleImg = 0;
  List imagelieu = [];
  Future<String> listImage() async {
    var url = 'http://51.210.103.151/get_img.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    vaDataImg = data;
    inTailleImg = data.length;
    notifyListeners();
    return " fin de fonction";
  }

  Future<List> imageTerrainId(String id) async {
    // cette fonction est utiliser lors d'un appuye sur le calendrier
    String url = 'http://51.210.103.151/post_img_terrain_id.php';
    String json = '{"lieu":"$id"}';
    Response response = await post(url, body: json);
    List data = jsonDecode(response.body);
    imagelieu = data;
    notifyListeners();
    return data;
  }
}
