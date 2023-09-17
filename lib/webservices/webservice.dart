import 'package:http/http.dart' as http;

class WebServices {
  Future callProfileApi() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=a608dd06f460b5f250f532b3ec9beba0');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      return response;
    }

    return null;
  }
}
