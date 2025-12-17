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

  int currentPage = 1;
  final int perPage = 5;

  List<Map<String, dynamic>> get paginatedRumah {
    final start = (currentPage - 1) * perPage;
    final end = start + perPage;
    if (start >= rumahList.length) return [];
    return rumahList.sublist(
      start,
      end > rumahList.length ? rumahList.length : end,
    );
  }

  int get totalPages => (rumahList.length / perPage).ceil();

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

  Widget _buildCard(Map<String, dynamic> r, int index) {
    const primaryGreen = Color(0xFF2E7D32);

    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Nomor
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFE8F5E9),
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// Info rumah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r['kode'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Alamat: ${r['alamat']}",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            /// Titik tiga (⋮)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: primaryGreen),
              onSelected: (value) {
                if (value == 'detail') {
                  _openDetail(r);
                } else if (value == 'edit') {
                  _openEdit(r);
                } else if (value == 'hapus') {
                  _confirmDelete(r['id']);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'detail',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 18),
                      SizedBox(width: 8),
                      Text('Detail'),
                    ],
                  ),
                ),
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
                      Icon(Icons.delete, size: 18, color: Colors.red),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryGreen),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
        title: const Text(
          "Daftar Rumah",
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: [
                        ...paginatedRumah.asMap().entries.map(
                          (e) => _buildCard(
                            e.value,
                            e.key + ((currentPage - 1) * perPage),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
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
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: active
                                        ? const Color(0xFF2E7D32)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: const Color(0xFF2E7D32),
                                    ),
                                  ),
                                  child: Text(
                                    page.toString(),
                                    style: TextStyle(
                                      color: active
                                          ? Colors.white
                                          : const Color(0xFF2E7D32),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }),

                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: currentPage < totalPages
                                  ? () => setState(() => currentPage++)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
