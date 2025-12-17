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
  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _keluargaList = [];
  bool _loading = true;
  String? _error;

  final Color primaryGreen = const Color(0xFF2E7D32);
  final TextStyle baseFont = const TextStyle(fontFamily: "Poppins");

  // Pagination
  int _currentPage = 0;
  final int _itemsPerPage = 5;

  // List Jenis Mutasi
  final List<String> jenisList = [
    'Pindah Keluar',
    'Pindah Masuk',
    'Pindah Domisili',
    'Perubahan Status',
    'Kematian',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _loadKeluarga();
  }

  Future<void> _loadKeluarga() async {
    setState(() => _loading = true);
    try {
      _keluargaList = await KeluargaService.getKeluarga();
      await _loadData();
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "Gagal memuat keluarga: $e";
      });
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await MutasiService.getAll();
      final items = (res['data'] as List).map((e) => e as Map<String, dynamic>).toList();

      _data = items.asMap().entries.map((e) {
        final idx = e.key;
        final row = e.value;

        final keluargaIdStr = row['keluarga_id'].toString();
        final keluargaName = _keluargaList.firstWhere(
          (k) => k['id'].toString() == keluargaIdStr,
          orElse: () => {'nama_keluarga': '-'},
        )['nama_keluarga'];

        return {
          'no': (idx + 1).toString(),
          'id': row['id'],
          'keluarga_id': row['keluarga_id'] ?? '-',
          'nama_keluarga': keluargaName ?? '-',
          'jenis_mutasi': row['jenis_mutasi'] ?? '-',
          'tanggal': row['tanggal'] ?? '-',
          'alasan': row['alasan'] ?? '-',
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
      final success = await MutasiService.delete(item['id']);
      if (success) {
        _data.removeWhere((d) => d['id'] == item['id']);
        if (mounted) setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mutasi berhasil dihapus!"), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghapus data"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _editItem(Map item) => _openEditDialog(context, item);

  Future<void> _updateMutasi(Map item, String jenis, String tanggal, String alasan) async {
    final result = await MutasiService.update(item['id'], {
      "jenis_mutasi": jenis,
      "tanggal": tanggal,
      "alasan": alasan,
    });

    if (result['success'] == true) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mutasi berhasil diperbarui!"), backgroundColor: Colors.green),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui data: ${result['message']}"), backgroundColor: Colors.red),
      );
    }
  }

  void _openEditDialog(BuildContext context, Map data) {
    String? selectedJenis = data['jenis_mutasi'];
    final tanggalC = TextEditingController(text: data['tanggal']);
    final alasanC = TextEditingController(text: data['alasan']);

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
              title: Text("Edit Mutasi", style: baseFont.copyWith(fontWeight: FontWeight.bold, color: primaryGreen)),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown Jenis Mutasi
                    DropdownButtonFormField<String>(
                      value: selectedJenis,
                      decoration: InputDecoration(
                        labelText: 'Jenis Mutasi',
                        filled: true,
                        fillColor: const Color(0xFFE8F5E9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: jenisList.map((j) => DropdownMenuItem(value: j, child: Text(j))).toList(),
                      onChanged: (v) => setStateDialog(() => selectedJenis = v),
                      validator: (v) => v == null || v.isEmpty ? 'Pilih jenis mutasi' : null,
                    ),
                    const SizedBox(height: 12),
                    // Tanggal
                    TextField(
                      controller: tanggalC,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Tanggal',
                        filled: true,
                        fillColor: const Color(0xFFE8F5E9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.tryParse(tanggalC.text) ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setStateDialog(() {
                            tanggalC.text =
                                "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    // Alasan
                    TextField(
                      controller: alasanC,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Alasan',
                        filled: true,
                        fillColor: const Color(0xFFE8F5E9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Batal", style: baseFont.copyWith(color: primaryGreen)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedJenis == null || selectedJenis!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Pilih jenis mutasi"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    await _updateMutasi(data, selectedJenis!, tanggalC.text, alasanC.text);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                  child: Text("Simpan", style: baseFont.copyWith(color: Colors.white)),
                ),
              ],
            );
          },
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Hapus"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (_data.length / _itemsPerPage).ceil();
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (_currentPage + 1) * _itemsPerPage > _data.length
        ? _data.length
        : (_currentPage + 1) * _itemsPerPage;
    final pageItems = _data.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2E7D32)),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
        title: const Text(
          "Daftar Mutasi",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 235, 188), Color.fromARGB(255, 181, 255, 183)],
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
                    ? const Center(child: Text("Belum ada mutasi"))
                    : Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ...pageItems.map((entry) {
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: primaryGreen.withOpacity(0.15),
                                      child: Text(entry['no'], style: baseFont.copyWith(fontWeight: FontWeight.bold, color: primaryGreen)),
                                    ),
                                    title: Text("Keluarga: ${entry['nama_keluarga']}", style: baseFont.copyWith(fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                      "Jenis Mutasi: ${entry['jenis_mutasi']}\nTanggal: ${entry['tanggal']}\nAlasan: ${entry['alasan']}",
                                      style: baseFont.copyWith(height: 1.3),
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'Edit') _editItem(entry);
                                        if (value == 'Hapus') _deleteItem(entry);
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(value: 'Edit', child: Text('Edit', style: baseFont)),
                                        PopupMenuItem(value: 'Hapus', child: Text('Hapus', style: baseFont)),
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
                                    onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                                    icon: const Icon(Icons.chevron_left),
                                  ),
                                  ...List.generate(totalPages, (index) {
                                    final isCurrent = index == _currentPage;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: GestureDetector(
                                        onTap: () => setState(() => _currentPage = index),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isCurrent ? primaryGreen : Colors.grey[300],
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text("${index + 1}", style: TextStyle(color: isCurrent ? Colors.white : Colors.black)),
                                        ),
                                      ),
                                    );
                                  }),
                                  IconButton(
                                    onPressed: _currentPage < totalPages - 1 ? () => setState(() => _currentPage++) : null,
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