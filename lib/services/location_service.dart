import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static const baseUrl = "https://countriesnow.space/api/v0.1";

  static Future<List<String>> getAllCountries() async {
    final url = Uri.parse('$baseUrl/countries/iso');
    final response = await http.get(url);
    final body = json.decode(response.body);
    return List<String>.from(body['data'].map((e) => e['name']));
  }

  static Future<List<String>> getStates(String country) async {
    final url = Uri.parse('$baseUrl/countries/states');
    final response = await http.post(
      url,
      body: json.encode({"country": country}),
      headers: {"Content-Type": "application/json"},
    );
    final body = json.decode(response.body);
    return List<String>.from(body['data']['states'].map((e) => e['name']));
  }

  static Future<List<String>> getCities(String country, String state) async {
    final url = Uri.parse('$baseUrl/countries/state/cities');
    final response = await http.post(
      url,
      body: json.encode({"country": country, "state": state}),
      headers: {"Content-Type": "application/json"},
    );
    final body = json.decode(response.body);
    return List<String>.from(body['data']);
  }

  static Future<List<Map<String, String>>> getAllDialCodes() async {
    final response = await http.get(Uri.parse('$baseUrl/countries/codes'));
    final body = json.decode(response.body);

    return List<Map<String, String>>.from(body['data'].map((item) {
      return {
        'name': item['name'].toString(),
        'dial_code': item['dial_code'].toString(),
      };
    }));
  }
}















