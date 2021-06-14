import 'dart:async';
import 'package:http/http.dart' as http;


class LoripsumBloc {
  static String lorim;

  final _streamcontroller = StreamController<String>();
  Stream <String> get stream => _streamcontroller.stream;

  fetch() async {
    String s = lorim ?? await LoripsumApi.getLoripsum();

    lorim = s;
    _streamcontroller.add(s);

    void dispose(){
      _streamcontroller.close();
    }
  }

  void dispose() {}


}

class LoripsumApi {
  static Future<String> getLoripsum() async {

    var url = 'https://loripsum.net/api';

    print("GET > $url");

    var response = await http.get(Uri.parse(url));

    String text = response.body;


    text = text.replaceAll("<p>", "");
    text = text.replaceAll("</p>", "");

    return text;
  }
}