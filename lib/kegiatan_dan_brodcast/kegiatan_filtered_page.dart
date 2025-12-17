import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/services/kegiatan_service.dart';

class KegiatanFilteredPage extends StatefulWidget {
  final String when; // 'overdue' | 'today' | 'upcoming'
  const KegiatanFilteredPage({super.key, required this.when});

  @override
  State<KegiatanFilteredPage> createState() => _KegiatanFilteredPageState();
}

class _KegiatanFilteredPageState extends State<KegiatanFilteredPage> {
  List<Map<String, dynamic>> _data = [];
  bool _loading = true;
  String? _error;

  final Color primaryGreen = const Color(0xFF2E7D32);
  final TextStyle baseFont = const TextStyle(fontFamily: "Poppins");

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  String _titleForWhen() {
    switch (widget.when) {
      case 'overdue':
        return 'Kegiatan - Sudah Lewat';
      case 'today':
        return 'Kegiatan - Hari Ini';
      case 'upcoming':
        return 'Kegiatan - Akan Datang';
      default:
        return 'Daftar Kegiatan';
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
      _data = [];
    });

    try {
      final items = await KegiatanService.getFiltered(widget.when);
      _data = items.asMap().entries.map((e) {
        final idx = e.key;
        final row = e.value;
        return {
          'no': (idx + 1).toString(),
          'id': row['id'],
          'nama': row['nama'] ?? '',
          'kategori': row['kategori'] ?? '',
          'pj': row['penanggung_jawab'] ?? '',
          'tanggal': row['tanggal'] ?? '',
          'biaya': row['biaya'] ?? '',
          'lokasi': row['lokasi'] ?? '',
        };
      }).toList();
    } catch (e) {
      _error = 'Gagal memuat data: $e';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2E7D32)),
          onPressed: () => context.go('/dashboard/kegiatan'),
        ),
        title: Text(
          _titleForWhen(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 235, 188),
              Color.fromARGB(255, 181, 255, 183),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text(_error!))
                : _data.isEmpty
                ? const Center(child: Text('Tidak ada kegiatan'))
                : Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: _data.map((entry) {
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: primaryGreen.withOpacity(0.15),
                                child: Text(
                                  entry['no'],
                                  style: baseFont.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryGreen,
                                  ),
                                ),
                              ),
                              title: Text(
                                entry['nama'],
                                style: baseFont.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Kategori: ${entry['kategori']}\nPenanggung Jawab: ${entry['pj']}\nTanggal: ${entry['tanggal']}\nBiaya: ${entry['biaya']}\nLokasi: ${entry['lokasi']}",
                                style: baseFont.copyWith(height: 1.3),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
