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

  final Color primaryGreen = const Color(0xFF2E7D32);
  final Color softGreenBg = const Color(0xFFE8F5E9);

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

  // Bottom Sheet (Edit / Hapus)
  void _showActionMenu(BuildContext ctx, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: primaryGreen),
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

  // Alert delete popup
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            "Hapus Data",
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen),
          ),
          content: const Text("Yakin ingin menghapus channel ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal", style: TextStyle(color: primaryGreen)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
              onPressed: () {
                Navigator.pop(context);
                _delete(id);
              },
              child: const Text("Hapus", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softGreenBg,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Daftar Metode Pembayaran',
          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: primaryGreen),
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
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: primaryGreen.withOpacity(0.15),
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                color: primaryGreen,
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '-',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),

                          IconButton(
                            onPressed: () => _showActionMenu(context, item),
                            icon: Icon(Icons.more_horiz, color: primaryGreen),
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
        backgroundColor: primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$label: $value",
        style: TextStyle(fontSize: 13, color: primaryGreen),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
