// lib/country_list.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchCountries() async {
  final response = await http.get(
    Uri.parse('https://restcountries.com/v3.1/all?fields=name'),
  );

  if (response.statusCode == 200) {
    List<dynamic> countriesJson = json.decode(response.body);
    List<String> countryList = countriesJson
        .map((country) => country['name']['common'] as String)
        .toList();
    
    // Sort alphabetically for better UX in the DropdownButton
    countryList.sort();
    return countryList;
  } else {
    // Preserving the detailed exception for ongoing system monitoring
    throw Exception('Failed to load countries: Status ${response.statusCode}');
  }
}