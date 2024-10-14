import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map> getDrinkApi(String _search) async {
  http.Response response;
  response = await http.get(Uri.parse("https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$_search"));
  return json.decode(response.body);
} 
