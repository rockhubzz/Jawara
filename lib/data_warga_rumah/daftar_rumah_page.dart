import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/services/rumah_service.dart';
import 'rumah_detail_page.dart';
import 'rumah_form_page.dart';

class RumahListPage extends StatefulWidget {
  const RumahListPage({super.key});

  @override
  State<RumahListPage> createState() => _RumahListPageState();
}

class _RumahListPageState extends State<RumahListPage> {
  List<Map<String, dynamic>> rumahList = [];
  bool loading = true;

  static const Color kombu = Color(0xFF374426);
  static const Color bgSoft = Color(0xFFF1F5EE);

  @override
  void initState() {
    super.initState();
    loadRumah();
  }

  Future<void> loadRumah() async {
    setState(() => loading = true);
    rumahList = await RumahService.getAll();
    setState(() {
      loading = false;
      currentPage = 1;
    });
  }

  void _openDetail(Map<String, dynamic> r) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RumahDetailPage(rumah: r)),
    );
  }

  void _openEdit(Map<String, dynamic> r) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RumahFormPage(data: r)),
      // MaterialPageRoute(builder: (_) => RumahFormPage(rumah: r)),
    ).then((_) => loadRumah());
  }

  void _confirmDelete(int id) {
    const primaryGreen = Color(0xFF2E7D32);
    const lightGreen = Color(0xFFE0F2F1);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: lightGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Hapus Rumah",
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen),
        ),
        content: const Text("Yakin ingin menghapus data rumah ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
            onPressed: () async {
              Navigator.pop(ctx);
              await RumahService.delete(id);
              loadRumah();
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      final data = await RumahService.getAll();
      setState(() {
        rumahList = data;
        loading = false;
      });
    } catch (_) {
      setState(() => loading = false);
    }
  }

  Future<void> _confirmDelete(int id) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah yakin ingin menghapus data rumah ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await RumahService.delete(id);
              fetchData();
            },
            child: const Text("Iya", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String from = 'semua';
    try {
      from = GoRouterState.of(context).uri.queryParameters['from'] ?? 'semua';
    } catch (_) {}

    return Scaffold(
      backgroundColor: bgSoft,

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kombu),
          onPressed: () {
            if (from == 'beranda') {
              context.go('/beranda');
            } else {
              context.go('/beranda/semua_menu');
            }
          },
        ),
        title: const Text(
          "Daftar Rumah",
          style: TextStyle(color: kombu, fontWeight: FontWeight.w600),
        ),
      ),

      /// BODY
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    children: rumahList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final r = entry.value;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            /// NOMOR
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: kombu,
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            /// DATA
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r['kode'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: kombu,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    r['alamat'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// MENU TITIK TIGA
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: kombu),
                              onSelected: (value) {
                                if (value == 'detail') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RumahDetailPage(rumah: r),
                                    ),
                                  ).then((_) => fetchData());
                                } else if (value == 'edit') {
                                  context.go('/data_rumah/edit/${r['id']}');
                                } else if (value == 'hapus') {
                                  _confirmDelete(r['id']);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'detail',
                                  child: Text("Detail"),
                                ),
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text("Edit"),
                                ),
                                PopupMenuItem(
                                  value: 'hapus',
                                  child: Text(
                                    "Hapus",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }
}
