import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  static String? get baseUrl => AuthService.baseUrl;

  // Ambil token dari SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // GET SALDO
  static Future<int> getSaldo() async {
    final token = await _getToken();

    final resp = await http.get(
      Uri.parse('$baseUrl/glance/saldo'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);

      // Backend format asumsi: { "saldo": 123456 }
      return (data['saldo'] as num).toInt();
    } else {
      throw Exception('Gagal mengambil saldo: ${resp.statusCode}');
    }
  }

  static Future<int> getKeluarga() async {
    final token = await _getToken();

    final resp = await http.get(
      Uri.parse('$baseUrl/glance/keluarga'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);

      return (data['total_keluarga'] as num).toInt();
    } else {
      throw Exception('Gagal mengambil saldo: ${resp.statusCode}');
    }
  }

  static Future<int> getKegiatan() async {
    final token = await _getToken();

    final resp = await http.get(
      Uri.parse('$baseUrl/glance/kegiatan'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);

      return (data['data']?['hari_ini'] + data['data']?['setelah_hari_ini']
              as num)
          .toInt();
    } else {
      throw Exception('Gagal mengambil saldo: ${resp.statusCode}');
    }
  }

  // GET rekap keuangan and return only the current month's entry
  static Future<Map<String, dynamic>> getRekapKeuanganCurrentMonth() async {
    final token = await _getToken();

    final resp = await http.get(
      Uri.parse('$baseUrl/glance/rekap-keuangan'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final List<dynamic> list = data['data'] ?? [];

      final now = DateTime.now();
      final String monthStr =
          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}';

      final matched = list.firstWhere(
        (e) => (e['bulan'] as String).startsWith(monthStr),
        orElse: () => null,
      );

      if (matched != null) {
        final m = Map<String, dynamic>.from(matched);
        // normalize totals to integers
        final int pemasukan = int.tryParse(m['total_pemasukan']?.toString() ?? '') ?? 0;
        final int pengeluaran = int.tryParse(m['total_pengeluaran']?.toString() ?? '') ?? 0;
        return {
          'bulan': m['bulan'],
          'total_pemasukan': pemasukan,
          'total_pengeluaran': pengeluaran,
        };
      } else {
        return {
          'bulan': monthStr,
          'total_pemasukan': 0,
          'total_pengeluaran': 0,
        };
      }
    } else {
      throw Exception('Gagal mengambil rekap keuangan: ${resp.statusCode}');
    }
  }
}
