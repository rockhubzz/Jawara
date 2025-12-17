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

  // PAGINATED DATA
  List<Map<String, dynamic>> get paginatedData {
    final start = (currentPage - 1) * perPage;
    final end = start + perPage;

    if (start >= metodePembayaran.length) return [];

    return metodePembayaran.sublist(
      start,
      end > metodePembayaran.length ? metodePembayaran.length : end,
    );
  }

  // TOTAL PAGE
  int get totalPages => (metodePembayaran.length / perPage).ceil();

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
      body: Container(
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

        child: Column(
          children: [
            // ===== APPBAR =====
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF2E7D32),
                ),
                onPressed: () => context.go('/beranda/semua_menu'),
              ),
              title: const Text(
                'Daftar Metode Pembayaran',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: paginatedData.length,
                        itemBuilder: (context, index) {
                          final item = paginatedData[index];

                          return GestureDetector(
                            onTap: () {
                              // Arahkan ke halaman detail channel
                              context.push(
                                '/channel/detail/${item['id']}',
                                extra: {'channel': item, 'cleanUrl': cleanUrl},
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              margin: const EdgeInsets.only(bottom: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: const Color(0xFFE8F5E9),
                                      child: Text(
                                        (index + 1).toString(),
                                        style: const TextStyle(
                                          color: Color(0xFF2E7D32),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['nama'] ?? '-',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                255,
                                                21,
                                                44,
                                                22,
                                              ),
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
                                              ),
                                              _infoChip(
                                                'A/N',
                                                item['an'] ?? '-',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46,
                                      width: 46,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: primaryGreen,
                                          width: 1,
                                        ),
                                        color: Colors.white,
                                      ),
                                      child:
                                          item['thumbnail'] != null &&
                                              item['thumbnail']
                                                  .toString()
                                                  .isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                '$cleanUrl/${item['thumbnail']}',
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                          : Icon(
                                              Icons.image_not_supported,
                                              size: 22,
                                              color: primaryGreen.withOpacity(
                                                0.6,
                                              ),
                                            ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Color(0xFF2E7D32),
                                      ),
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          context.go(
                                            '/channel/edit/${item['id']}',
                                          );
                                        } else if (value == 'hapus') {
                                          _confirmDelete(item['id']);
                                        }
                                      },
                                      itemBuilder: (context) => const [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, size: 18),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'hapus',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                size: 18,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 8),
                                              Text('Hapus'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    color: primaryGreen,
                    onPressed: currentPage > 1
                        ? () => setState(() => currentPage--)
                        : null,
                  ),

                  ...List.generate(totalPages, (index) {
                    final page = index + 1;
                    final isActive = page == currentPage;

                    return GestureDetector(
                      onTap: () => setState(() => currentPage = page),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? primaryGreen : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: primaryGreen),
                        ),
                        child: Text(
                          page.toString(),
                          style: TextStyle(
                            color: isActive ? Colors.white : primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),

                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    color: primaryGreen,
                    onPressed: currentPage < totalPages
                        ? () => setState(() => currentPage++)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
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
