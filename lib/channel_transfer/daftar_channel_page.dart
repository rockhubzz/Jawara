import 'package:flutter/material.dart';
import 'package:jawara/services/auth_service.dart';
import '../services/channel_transfer_service.dart';
import 'package:go_router/go_router.dart';

class DaftarMetodePembayaranPage extends StatefulWidget {
  const DaftarMetodePembayaranPage({super.key});

  @override
  State<DaftarMetodePembayaranPage> createState() =>
      _DaftarMetodePembayaranPageState();
}

class _DaftarMetodePembayaranPageState
    extends State<DaftarMetodePembayaranPage> {
  bool _loading = true;
  String? cleanUrl;
  List<Map<String, dynamic>> metodePembayaran = [];

  @override
  void initState() {
    String? baseUrl = AuthService.baseUrl;
    cleanUrl = baseUrl!.replaceFirst('/api', '/storage');
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final result = await ChannelTransferService.getAll();

      setState(() {
        metodePembayaran = result;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _delete(int id) async {
    final ok = await ChannelTransferService.delete(id);
    if (ok) {
      _loadData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Berhasil dihapus")));
    }
  }

  void _showActionMenu(BuildContext ctx, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.go('/channel/edit/${item['id']}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Hapus'),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(item['id']);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Hapus Data"),
          content: const Text("Yakin ingin menghapus channel ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
                _delete(id);
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Daftar Metode Pembayaran',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: metodePembayaran.length,
                itemBuilder: (context, index) {
                  final item = metodePembayaran[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xFFE0E7FF),
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                color: Color(0xFF3730A3),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama'] ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    _infoChip('Tipe', item['tipe'] ?? '-'),
                                    _infoChip('A/N', item['an'] ?? '-'),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          if (item['thumbnail'] != null &&
                              item['thumbnail'].toString().isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '$cleanUrl/${item['thumbnail']}',
                                height: 50,
                                width: 50,
                                fit: BoxFit.contain,
                              ),
                            )
                          else
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '-',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),

                          IconButton(
                            onPressed: () => _showActionMenu(context, item),
                            icon: const Icon(Icons.more_horiz),
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/channel_transfer/tambah'),
        backgroundColor: const Color(0xFF5B43F1),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 13, color: Colors.black87),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
