import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/mutasi_service.dart';
import '../services/keluarga_service.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  final Color primaryGreen = const Color(0xFF2E7D32);

  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _keluargaList = [];
  bool _loading = true;

  int _currentPage = 0;
  final int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    try {
      _keluargaList = await KeluargaService.getKeluarga();
      final res = await MutasiService.getAll();

      final items = (res['data'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      _data = items.map((row) {
        final keluarga = _keluargaList.firstWhere(
          (k) => k['id'].toString() == row['keluarga_id'].toString(),
          orElse: () => {'nama_keluarga': '-'},
        );

        return {
          'id': row['id'],
          'nama_keluarga': keluarga['nama_keluarga'] ?? '-',
          'jenis_mutasi': row['jenis_mutasi'] ?? '-',
          'tanggal': row['tanggal'] ?? '-',
          'alasan': row['alasan'] ?? '-',
        };
      }).toList();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _editItem(Map item) {
    final jenisC = TextEditingController(text: item['jenis_mutasi']);
    final tanggalC = TextEditingController(text: item['tanggal']);
    final alasanC = TextEditingController(text: item['alasan']);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text("Edit Mutasi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: jenisC,
                decoration: const InputDecoration(labelText: "Jenis Mutasi"),
              ),
              TextField(
                controller: tanggalC,
                decoration: const InputDecoration(labelText: "Tanggal"),
              ),
              TextField(
                controller: alasanC,
                decoration: const InputDecoration(labelText: "Alasan"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                await MutasiService.update(item['id'], {
                  'jenis_mutasi': jenisC.text,
                  'tanggal': tanggalC.text,
                  'alasan': alasanC.text,
                });
                Navigator.pop(dialogCtx);
                _loadAll();
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItem(Map item) async {
    await MutasiService.delete(item['id']);
    _loadAll();
  }

  @override
  Widget build(BuildContext context) {
    final start = _currentPage * _itemsPerPage;
    final end = (start + _itemsPerPage > _data.length)
        ? _data.length
        : start + _itemsPerPage;
    final pageItems = _data.sublist(start, end);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Mutasi"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...pageItems.map(
                  (item) => Card(
                    child: ListTile(
                      title: Text(item['nama_keluarga']),
                      subtitle: Text(
                        "${item['jenis_mutasi']}\n${item['tanggal']}\n${item['alasan']}",
                      ),
                      trailing: PopupMenuButton(
                        onSelected: (v) =>
                            v == 'edit' ? _editItem(item) : _deleteItem(item),
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text("Edit")),
                          PopupMenuItem(value: 'delete', child: Text("Hapus")),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
