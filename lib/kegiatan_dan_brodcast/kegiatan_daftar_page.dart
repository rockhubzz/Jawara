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

  final Color primaryGreen = const Color(0xFF2E7D32);
  final TextStyle baseFont = const TextStyle(fontFamily: "Poppins");

  // Pagination
  int _currentPage = 0;
  final int _itemsPerPage = 5;

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
          'biaya': row['biaya'] ?? '',
          'lokasi': row['lokasi'] ?? '',
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
      String tanggal, int biaya, String lokasi) async {
    final result = await KegiatanService.update(id, {
      "nama": nama,
      "kategori": kategori,
      "penanggung_jawab": pj,
      "tanggal": tanggal,
      "biaya": biaya,
      "lokasi": lokasi,
    });

    if (result['success'] == true) {
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
        SnackBar(
            content: Text("Gagal memperbarui data: ${result['message']}"),
            backgroundColor: Colors.red),
      );
    }
  }

  void showEditDialog(BuildContext context, Map data) {
    final namaC = TextEditingController(text: data['nama']);
    final kategoriC = TextEditingController(text: data['kategori']);
    final pjC = TextEditingController(text: data['pj']);
    final tanggalC = TextEditingController(text: data['tanggal']);
    final biayaC = TextEditingController(text: data['biaya'].toString());
    final lokasiC = TextEditingController(text: data['lokasi']);

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: primaryGreen),
              ),
              title: Text(
                "Edit Kegiatan",
                style: baseFont.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField("Nama", namaC),
                    const SizedBox(height: 12),
                    _buildTextField("Kategori", kategoriC),
                    const SizedBox(height: 12),
                    _buildTextField("Penanggung Jawab", pjC),
                    const SizedBox(height: 12),
                    _buildTextField("Tanggal", tanggalC,
                        readOnly: true, showCalendar: true),
                    const SizedBox(height: 12),
                    _buildTextField("Biaya", biayaC,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildTextField("Lokasi", lokasiC),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Batal",
                    style: baseFont.copyWith(color: primaryGreen),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await editKegiatan(
                      data['id'],
                      namaC.text,
                      kategoriC.text,
                      pjC.text,
                      tanggalC.text,
                      int.parse(biayaC.text),
                      lokasiC.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                  child: Text(
                    "Simpan",
                    style: baseFont.copyWith(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false,
      bool showCalendar = false,
      TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFE8F5E9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: showCalendar ? const Icon(Icons.calendar_today) : null,
      ),
      onTap: showCalendar
          ? () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate:
                    DateTime.tryParse(controller.text) ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                controller.text = picked.toIso8601String().split('T').first;
              }
            }
          : null,
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
    final totalPages = (_data.length / _itemsPerPage).ceil();
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex =
        (_currentPage + 1) * _itemsPerPage > _data.length ? _data.length : (_currentPage + 1) * _itemsPerPage;
    final pageItems = _data.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2E7D32)),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
        title: const Text(
          "Daftar Kegiatan",
          style: TextStyle(
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
                : _data.isEmpty
                    ? const Center(child: Text("Belum ada kegiatan"))
                    : Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ...pageItems.map((entry) {
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          primaryGreen.withOpacity(0.15),
                                      child: Text(entry['no'],
                                          style: baseFont.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: primaryGreen)),
                                    ),
                                    title: Text(entry['nama'],
                                        style: baseFont.copyWith(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                      "Kategori: ${entry['kategori']}\nPenanggung Jawab: ${entry['pj']}\nTanggal: ${entry['tanggal']}\nBiaya: ${entry['biaya']}\nLokasi: ${entry['lokasi']}",
                                      style: baseFont.copyWith(height: 1.3),
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'Edit') _editItem(entry);
                                        if (value == 'Hapus') _deleteItem(entry);
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 'Edit',
                                            child:
                                                Text('Edit', style: baseFont)),
                                        PopupMenuItem(
                                            value: 'Hapus',
                                            child:
                                                Text('Hapus', style: baseFont)),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 12),
                              // Pagination
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: _currentPage > 0
                                        ? () => setState(() => _currentPage--)
                                        : null,
                                    icon: const Icon(Icons.chevron_left),
                                  ),
                                  ...List.generate(totalPages, (index) {
                                    final isCurrent = index == _currentPage;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: GestureDetector(
                                        onTap: () =>
                                            setState(() => _currentPage = index),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isCurrent
                                                ? primaryGreen
                                                : Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            "${index + 1}",
                                            style: TextStyle(
                                                color: isCurrent
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  IconButton(
                                    onPressed: _currentPage < totalPages - 1
                                        ? () => setState(() => _currentPage++)
                                        : null,
                                    icon: const Icon(Icons.chevron_right),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
