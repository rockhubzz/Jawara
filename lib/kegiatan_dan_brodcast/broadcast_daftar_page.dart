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
  List<Map<String, dynamic>> _filtered = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // load data
  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await BroadcastService.getAll();
      final List list = res['data'] ?? [];
      _data = list.map((e) => Map<String, dynamic>.from(e)).toList();

      _filtered = [..._data];
    } catch (e) {
      _error = "Gagal memuat: $e";
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // delete
  Future<void> _deleteItem(Map item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => _deleteDialog(),
    );

    if (confirm == true) {
      final success = await  BroadcastService.delete(item['id']);
      if (success == true) {
        _data.removeWhere((d) => d['id'] == item['id']);
        _filtered = [..._data];
        if (mounted) setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Broadcast berhasil dihapus!"), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghapus data"), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Menampilkan popup edit (title, body, sender, date)
  void _editItem(Map item) => showEditDialog(context, item);

  Future<void> editBroadcast(int id, String title, String body, String sender, String date) async {
    final success = await BroadcastService.update(id, {
      "title": title,
      "body": body,
      "sender": sender,
      "date": date,
    });

    if (success == true) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Broadcast berhasil diperbarui!"), backgroundColor: Colors.green),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memperbarui data"), backgroundColor: Colors.red),
      );
    }
  }

  void showEditDialog(BuildContext context, Map data) {
    final titleC = TextEditingController(text: data['title']?.toString() ?? '');
    final bodyC = TextEditingController(text: data['body']?.toString() ?? '');
    final senderC = TextEditingController(text: data['sender']?.toString() ?? '');
    final dateC = TextEditingController(text: data['date']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),

          title: const Text(
            "Edit Broadcast",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                TextField(
                  controller: titleC,
                  decoration: InputDecoration(
                    labelText: "Judul",
                    filled: true,
                    fillColor: const Color(0xFFF4D9B2),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),

                // Body
                TextField(
                  controller: bodyC,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Deskripsi",
                    filled: true,
                    fillColor: const Color(0xFFF4D9B2),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),

                // Sender
                TextField(
                  controller: senderC,
                  decoration: InputDecoration(
                    labelText: "Pengirim",
                    filled: true,
                    fillColor: const Color(0xFFF4D9B2),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),

                // Date picker
                TextField(
                  controller: dateC,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Tanggal",
                    filled: true,
                    fillColor: const Color(0xFFF4D9B2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.tryParse(dateC.text) ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      dateC.text = picked.toIso8601String().split('T').first;  
                      // hasil: YYYY-MM-DD
                    }
                  },
                ),
              ],
            ),
          ),

          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color(0xFFF4D9B2),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Batal"),
            ),

            TextButton(
              onPressed: () async {
                context.go('beranda/semua_menu');
                await editBroadcast(
                  data['id'],
                  titleC.text,
                  bodyC.text,
                  senderC.text,
                  dateC.text,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFBC6C25),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 235, 188), Color.fromARGB(255, 181, 255, 183)],
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
                    padding: const EdgeInsets.only(left: 16, top: 10), // beri jarak dari tepi kiri
                    child: IconButton(
                      onPressed: () => context.go('/beranda/semua_menu'),
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Daftar Broadcast",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
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
      decoration: BoxDecoration(color: const Color.fromARGB(255, 247, 255, 204), borderRadius: BorderRadius.circular(14), boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
      ]),
      child: Column(children: [
        if (_loading)
          const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()))
        else if (_error != null)
          Padding(padding: const EdgeInsets.all(8.0), child: Text(_error!))
        else if (_filtered.isEmpty)
          const Padding(padding: EdgeInsets.all(8.0), child: Text("Tidak ada data ditemukan"))
        else
          Column(
            children: _filtered.asMap().entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 16), child: _broadcastCard(e.value, e.key + 1))).toList(),
          ),
        const SizedBox(height: 14),
        _pagination(),
      ]),
    );
  }

  Widget _broadcastCard(Map item, int number) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFBC6C25), width: 2), boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 3)),
      ]),
      child: Row(children: [
        // number circle
        Container(width: 40, height: 40, decoration: const BoxDecoration(color: Color(0xFFBC6C25), shape: BoxShape.circle), alignment: Alignment.center, child: Text(number.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item['title'] ?? "-", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Deskripsi : ${item['body'] ?? '-'}"),
            Text("Pengirim : ${item['sender'] ?? '-'}"),
            Text("Tanggal : ${item['date'] ?? '-'}"),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              InkWell(onTap: () => _editItem(item), child: const Icon(Icons.edit, color: Colors.orange)),
              const SizedBox(width: 20),
              InkWell(onTap: () => _deleteItem(item), child: const Icon(Icons.delete, color: Colors.red)),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _deleteDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(mainAxisSize: MainAxisSize.min, children: const [
        Icon(Icons.warning_rounded, color: Colors.red, size: 60),
        SizedBox(height: 12),
        Text("Apakah Anda yakin ingin menghapus data ini?", textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.black87)),
      ]),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFF3D4), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: const Text("Hapus"),
        ),
      ],
    );
  }

  Widget _pagination() {
    return const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.chevron_left, color: Color(0xFFBC6C25)),
      SizedBox(width: 8),
      Text("1", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFBC6C25))),
      SizedBox(width: 8),
      Icon(Icons.chevron_right, color: Color(0xFFBC6C25)),
    ]);
  }
}
