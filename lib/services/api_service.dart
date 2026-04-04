import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<String> fetchDailyQuote() async {
    try {
      final response = await http.get(Uri.parse('https://zenquotes.io/api/today'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[0]['q'] + " - " + data[0]['a'];
      }
      return "Keep pushing forward!";
    } catch (e) {
      return "The only way to do great work is to love what you do.";
    }
  }
}