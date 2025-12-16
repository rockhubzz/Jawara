import 'dart:convert';
import 'dart:io';
import 'auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PemasukanService {
  static String? get baseUrl => AuthService.baseUrl;

  // Ambil token dari SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, dynamic>> getAll(int page) async {
    final token = await _getToken();
    final uri = Uri.parse(
      "$baseUrl/pemasukan",
    ).replace(queryParameters: {'page': page.toString()});

    final res = await http.get(uri, headers: {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> create(
    Map<String, String> body, {
    String? filePath,
  }) async {
    final token = await _getToken();

    if (filePath == null) {
      final resp = await http.post(
        Uri.parse("$baseUrl/pemasukan"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );
      return json.decode(resp.body);
    } else {
      final uri = Uri.parse("$baseUrl/pemasukan");
      final request = http.MultipartRequest('POST', uri);

      request.fields.addAll(body);

      final file = await http.MultipartFile.fromPath(
        'bukti',
        filePath,
        filename: basename(filePath),
      );

      request.files.add(file);

      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      final streamed = await request.send();
      final resp = await http.Response.fromStream(streamed);
      return json.decode(resp.body);
    }
  }

  static Future<Map<String, dynamic>> update(
    int id,
    Map<String, String> body, {
    String? filePath,
  }) async {
    final token = await _getToken();

    if (filePath == null) {
      final resp = await http.put(
        Uri.parse("$baseUrl/pemasukan/$id"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );
      return json.decode(resp.body);
    } else {
      final uri = Uri.parse("$baseUrl/pemasukan/$id");
      final request = http.MultipartRequest('PUT', uri);

      request.fields.addAll(body);

      final file = await http.MultipartFile.fromPath(
        'bukti',
        filePath,
        filename: basename(filePath),
      );

      request.files.add(file);

      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      final streamed = await request.send();
      final resp = await http.Response.fromStream(streamed);
      return json.decode(resp.body);
    }
  }

  static Future<bool> delete(int id) async {
    final token = await _getToken();
    final res = await http.delete(Uri.parse("$baseUrl/pemasukan/$id"), headers: {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });
    return res.statusCode == 200;
  }
}
