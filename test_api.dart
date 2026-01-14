import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  print('Testing CBR API...');

  try {
    final client = http.Client();
    final response = await client.get(Uri.parse('https://api.cbr.ru/publications')).timeout(Duration(seconds: 10));

    print('Status Code: ${response.statusCode}');
    print('Response: ${response.body.substring(0, 200)}...');

    client.close();
  } catch (e) {
    print('Error: $e');
  }
}