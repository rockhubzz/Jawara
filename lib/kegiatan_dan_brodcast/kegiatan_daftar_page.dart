import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/services/kegiatan_service.dart';

class KegiatanDaftarPage extends StatefulWidget {
  const KegiatanDaftarPage({super.key});

  @override
  State<KegiatanDaftarPage> createState() => _KegiatanDaftarPageState();
}

class _KegiatanDaftarPageState extends State<KegiatanDaftarPage> {
  List<Map<String, dynamic>> _data = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final items = await KegiatanService.getAll();
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
        };
      }).toList();
    } catch (e) {
      _error = "Gagal memuat data: $e";
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteItem(Map item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => _deleteDialog(),
    );

    if (confirm == true) {
      final success = await KegiatanService.delete(item['id']);
      if (success == true) {
        _data.removeWhere((d) => d['id'] == item['id']);
        if (mounted) setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Kegiatan berhasil dihapus!"),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Gagal menghapus data"),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _editItem(Map item) => showEditDialog(context, item);

  Future<void> editKegiatan(int id, String nama, String kategori, String pj,
      String tanggal) async {
    final success = await KegiatanService.update(id, {
      "nama": nama,
      "kategori": kategori,
      "penanggung_jawab": pj,
      "tanggal": tanggal,
    });

    if (success == true) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Kegiatan berhasil diperbarui!"),
            backgroundColor: Colors.green),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Gagal memperbarui data"),
            backgroundColor: Colors.red),
      );
    }
  }

  void showEditDialog(BuildContext context, Map data) {
    final namaC = TextEditingController(text: data['nama']);
    final kategoriC = TextEditingController(text: data['kategori']);
    final pjC = TextEditingController(text: data['pj']);
    final tanggalC = TextEditingController(text: data['tanggal']);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text(
            "Edit Kegiatan",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaC,
                  decoration: InputDecoration(
                    labelText: "Nama",
                    filled: true,
                    fillColor: const Color(0xFFF4D9B2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: kategoriC,
                  decoration: InputDecoration(
                    labelText: "Kategori",
                    filled: true,
                    fillColor: const Color(0xFFF4D9B2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: pjC,
                  decoration: InputDecoration(
                    labelText: "Penanggung Jawab",
                    filled: true,
                    fillColor: const Color(0xFFF4D9B2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: tanggalC,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Tanggal",
                    filled: true,
                    fillColor: const Color(0xFFF4D9B2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate:
                          DateTime.tryParse(tanggalC.text) ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      tanggalC.text =
                          picked.toIso8601String().split('T').first;
                    }
                  },
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color(0xFFF4D9B2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await editKegiatan(
                  data['id'],
                  namaC.text,
                  kategoriC.text,
                  pjC.text,
                  tanggalC.text,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFBC6C25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  Widget _deleteDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(mainAxisSize: MainAxisSize.min, children: const [
        Icon(Icons.warning_rounded, color: Colors.red, size: 60),
        SizedBox(height: 12),
        Text(
          "Apakah Anda yakin ingin menghapus data ini?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ]),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFF3D4),
              foregroundColor: Colors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: const Text("Hapus"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 235, 188),
              Color.fromARGB(255, 181, 255, 183),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 10),
                    child: IconButton(
                      onPressed: () => context.go('/beranda/semua_menu'),
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Daftar Kegiatan",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildMainContainer(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 255, 204),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          if (_loading)
            const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()))
          else if (_error != null)
            Padding(padding: const EdgeInsets.all(8.0), child: Text(_error!))
          else if (_data.isEmpty)
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Belum ada kegiatan"))
          else
            Column(
              children: _data
                  .asMap()
                  .entries
                  .map(
                    (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _kegiatanCard(e.value, e.key + 1)),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _kegiatanCard(Map item, int number) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFBC6C25), width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 3))
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFBC6C25),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(number.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['nama'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("Kategori: ${item['kategori']}"),
                Text("Penanggung Jawab: ${item['pj']}"),
                Text("Tanggal: ${item['tanggal']}"),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () => _editItem(item),
                        child: const Icon(Icons.edit, color: Colors.orange)),
                    const SizedBox(width: 20),
                    InkWell(
                        onTap: () => _deleteItem(item),
                        child: const Icon(Icons.delete, color: Colors.red)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
