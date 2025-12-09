import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChannelTransferService {
  static String? get baseUrl => AuthService.baseUrl;

  // Ambil token dari SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // GET all
  static Future<List<Map<String, dynamic>>> getAll() async {
    final token = await _getToken();
    final resp = await http.get(
      Uri.parse('$baseUrl/channel-transfer'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final Map<String, dynamic> js = json.decode(resp.body);
      final List data = js['data'] ?? [];
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Failed to load channels: ${resp.statusCode}');
    }
  }

  // GET by id
  static Future<Map<String, dynamic>?> getById(int id) async {
    final token = await _getToken();
    final resp = await http.get(
      Uri.parse('$baseUrl/channel-transfer/$id'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final Map<String, dynamic> js = json.decode(resp.body);
      return Map<String, dynamic>.from(js['data']);
    } else if (resp.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load: ${resp.statusCode}');
    }
  }

  // CREATE with optional file
  // filePath can be null
  static Future<Map<String, dynamic>> create(
    Map<String, String> body, {
    String? filePath,
  }) async {
    final token = await _getToken();

    if (filePath == null) {
      final resp = await http.post(
        Uri.parse('$baseUrl/channel-transfer'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );
      return json.decode(resp.body);
    } else {
      final uri = Uri.parse('$baseUrl/channel-transfer');
      final request = http.MultipartRequest('POST', uri);

      request.fields.addAll(body);

      final file = await http.MultipartFile.fromPath(
        'thumbnail',
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

  // UPDATE with optional file
  static Future<Map<String, dynamic>> update(
    int id,
    Map<String, String> body, {
    String? filePath,
  }) async {
    final token = await _getToken();
    if (filePath == null) {
      final resp = await http.put(
        Uri.parse('$baseUrl/channel-transfer/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );
      return json.decode(resp.body);
    } else {
      final uri = Uri.parse('$baseUrl/channel-transfer/$id');
      final request = http.MultipartRequest(
        'POST',
        uri,
      ); // using POST or PUT depending backend
      request.fields.addAll(body);
      // Some backends require _method=PUT when using multipart; Laravel accepts PUT if you send as PUT
      request.fields['_method'] = 'PUT';
      final file = await http.MultipartFile.fromPath(
        'thumbnail',
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

  // DELETE
  static Future<bool> delete(int id) async {
    final token = await _getToken();
    final resp = await http.delete(
      Uri.parse('$baseUrl/channel-transfer/$id'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final m = json.decode(resp.body);
      return m['success'] == true;
    } else {
      return false;
    }
  }

  static String imageUrl(String path) {
    final base = AuthService.baseUrl?.replaceAll('/api', '');
    return '$base/storage/$path';
  }
}
