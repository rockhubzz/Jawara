import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/broadcast_service.dart';

class BroadcastDaftarPage extends StatefulWidget {
  const BroadcastDaftarPage({super.key});

  @override
  State<BroadcastDaftarPage> createState() => _BroadcastDaftarPageState();
}

class _BroadcastDaftarPageState extends State<BroadcastDaftarPage> {
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
      final res = await BroadcastService.getAll();
      final List list = res['data'] ?? [];

      // Jangan reversed, biar item baru tetap di bawah
      _data = list.map((row) {
        return {
          'id': row['id'],
          'title': row['title'] ?? '',
          'body': row['body'] ?? '',
          'sender': row['sender'] ?? '',
          'date': row['date'] ?? '',
        };
      }).toList();
      _updateNumbers();
    } catch (e) {
      _error = "Gagal memuat data: $e";
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _updateNumbers() {
    for (int i = 0; i < _data.length; i++) {
      _data[i]['no'] = (i + 1).toString();
    }
  }

  Future<void> _deleteItem(Map item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => _deleteDialog(),
    );

    if (confirm == true) {
      final success = await BroadcastService.delete(item['id']);
      if (success == true) {
        _data.removeWhere((d) => d['id'] == item['id']);
        _updateNumbers(); // update nomor urut
        if (mounted) setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Broadcast berhasil dihapus!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menghapus data"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _editItem(Map item) => showEditDialog(context, item);

  Future<void> editBroadcast(
      int id, String title, String body, String sender, String date) async {
    final result = await BroadcastService.update(id, {
      "title": title,
      "body": body,
      "sender": sender,
      "date": date,
    });

    if (result['success'] == true) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Broadcast berhasil diperbarui!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memperbarui data: ${result['message']}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showEditDialog(BuildContext context, Map data) {
    final titleC = TextEditingController(text: data['title']);
    final bodyC = TextEditingController(text: data['body']);
    final senderC = TextEditingController(text: data['sender']);
    final dateC = TextEditingController(text: data['date']);

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
                "Edit Broadcast",
                style: baseFont.copyWith(
                    fontWeight: FontWeight.bold, color: primaryGreen),
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField("Judul", titleC),
                    const SizedBox(height: 12),
                    _buildTextField("Deskripsi", bodyC, maxLines: 3),
                    const SizedBox(height: 12),
                    _buildTextField("Pengirim", senderC),
                    const SizedBox(height: 12),
                    _buildTextField("Tanggal", dateC,
                        readOnly: true, showCalendar: true),
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
                    await editBroadcast(data['id'], titleC.text, bodyC.text,
                        senderC.text, dateC.text);
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
      {bool readOnly = false, bool showCalendar = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
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
    final endIndex = (_currentPage + 1) * _itemsPerPage > _data.length
        ? _data.length
        : (_currentPage + 1) * _itemsPerPage;
    final pageItems = _data.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryGreen),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
        title: Text(
          "Daftar Broadcast",
          style: baseFont.copyWith(
              fontWeight: FontWeight.bold, color: primaryGreen),
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
                    ? const Center(child: Text("Belum ada broadcast"))
                    : Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ...pageItems.map((item) {
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          primaryGreen.withOpacity(0.15),
                                      child: Text(item['no'],
                                          style: baseFont.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: primaryGreen)),
                                    ),
                                    title: Text(item['title'],
                                        style: baseFont.copyWith(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                      "Deskripsi: ${item['body']}\nPengirim: ${item['sender']}\nTanggal: ${item['date']}",
                                      style: baseFont.copyWith(height: 1.3),
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'Edit') _editItem(item);
                                        if (value == 'Hapus') _deleteItem(item);
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
