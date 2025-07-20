import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static const baseUrl = "https://countriesnow.space/api/v0.1";

  /// Get all countries
  static Future<List<String>> getAllCountries() async {
    final url = Uri.parse('$baseUrl/countries/iso');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return List<String>.from(body['data'].map((e) => e['name']));
    } else {
      throw Exception('Failed to load countries');
    }
  }

  /// Get all states using GET request (mobile safe)
  static Future<List<String>> getStates(String country) async {
    final encodedCountry = Uri.encodeComponent(country);
    final url = Uri.parse('$baseUrl/countries/states/q?country=$encodedCountry');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return List<String>.from(body['data']['states'].map((e) => e['name']));
    } else {
      throw Exception('Failed to load states for $country');
    }
  }

  /// Get cities using GET request (mobile safe)
  static Future<List<String>> getCities(String country, String state) async {
    final encodedCountry = Uri.encodeComponent(country);
    final encodedState = Uri.encodeComponent(state);
    final url = Uri.parse(
      '$baseUrl/countries/state/cities/q?country=$encodedCountry&state=$encodedState',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return List<String>.from(body['data']);
    } else {
      throw Exception('Failed to load cities for $state, $country');
    }
  }

  /// Get all country dial codes
  static Future<List<Map<String, String>>> getAllDialCodes() async {
    final url = Uri.parse('$baseUrl/countries/codes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return List<Map<String, String>>.from(body['data'].map((item) {
        return {
          'name': item['name'].toString(),
          'dial_code': item['dial_code'].toString(),
        };
      }));
    } else {
      throw Exception('Failed to load dial codes');
    }
  }
}
