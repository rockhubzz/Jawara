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
  int currentPage = 1;
  int perPage = 5;

  bool _loading = true;
  String? cleanUrl;
  List<Map<String, dynamic>> metodePembayaran = [];

  List<Map<String, dynamic>> get paginatedData {
    final start = (currentPage - 1) * perPage;
    final end = start + perPage;
    if (start >= metodePembayaran.length) return [];
    return metodePembayaran.sublist(
      start,
      end > metodePembayaran.length ? metodePembayaran.length : end,
    );
  }

  int get totalPages => (metodePembayaran.length / perPage).ceil();

  final Color kombuGreen = const Color(0xFF374426);
  final Color softBg = const Color(0xFFF4F7F2);

  @override
  void initState() {
    super.initState();
    cleanUrl = AuthService.baseUrl!.replaceFirst('/api', '/storage');
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final result = await ChannelTransferService.getAll();
      setState(() {
        metodePembayaran = result;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Color _typeColor(String tipe) {
    final t = tipe.toLowerCase();
    if (t.contains('bank')) return Colors.blue;
    if (t.contains('wallet')) return Colors.green;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: kombuGreen),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
        title: Text(
          'Daftar Metode Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: kombuGreen),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: paginatedData.length,
                    itemBuilder: (context, index) {
                      final item = paginatedData[index];
                      final typeColor = _typeColor(item['tipe'] ?? '');

                      return Card(
                        color: Colors.white,
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: typeColor.withOpacity(0.35)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // NOMOR
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: kombuGreen,
                                child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // INFO
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['nama'] ?? '-',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: kombuGreen,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: [
                                        _infoChip(
                                          'Tipe',
                                          item['tipe'] ?? '-',
                                          typeColor,
                                        ),
                                        _infoChip(
                                          'A/N',
                                          item['an'] ?? '-',
                                          typeColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // THUMBNAIL
                              Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: typeColor),
                                ),
                                child:
                                    item['thumbnail'] != null &&
                                        item['thumbnail'].toString().isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          '$cleanUrl/${item['thumbnail']}',
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                    : Icon(
                                        Icons.image_not_supported,
                                        color: typeColor.withOpacity(0.6),
                                      ),
                              ),

                              // MENU
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: kombuGreen),
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    context.go('/channel/edit/${item['id']}');
                                  } else {
                                    _confirmDelete(item['id']);
                                  }
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: Color(0xFF374426),
                                        ),
                                        SizedBox(width: 8),
                                        Text("Edit"),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'hapus',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 8),
                                        Text("Hapus"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // PAGINATION
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        color: kombuGreen,
                        onPressed: currentPage > 1
                            ? () => setState(() => currentPage--)
                            : null,
                      ),
                      ...List.generate(totalPages, (i) {
                        final page = i + 1;
                        final active = page == currentPage;
                        return GestureDetector(
                          onTap: () => setState(() => currentPage = page),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: active ? kombuGreen : Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: kombuGreen),
                            ),
                            child: Text(
                              '$page',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: active ? Colors.white : kombuGreen,
                              ),
                            ),
                          ),
                        );
                      }),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        color: kombuGreen,
                        onPressed: currentPage < totalPages
                            ? () => setState(() => currentPage++)
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _infoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$label: $value",
        style: TextStyle(fontSize: 12, color: color),
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Hapus Data",
          style: TextStyle(fontWeight: FontWeight.bold, color: kombuGreen),
        ),
        content: const Text("Yakin ingin menghapus channel ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: kombuGreen)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kombuGreen),
            onPressed: () {
              Navigator.pop(context);
              ChannelTransferService.delete(id).then((_) => _loadData());
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }
}
