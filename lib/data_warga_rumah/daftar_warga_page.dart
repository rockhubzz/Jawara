import 'package:flutter/material.dart';
import '../../services/warga_service.dart';
import 'tambahWarga_page.dart';
import 'warga_edit_page.dart';
import 'warga_detail_page.dart';
import 'package:go_router/go_router.dart';

class WargaListPage extends StatefulWidget {
  const WargaListPage({super.key});

  @override
  State<WargaListPage> createState() => _WargaListPageState();
}

class _WargaListPageState extends State<WargaListPage> {
  List<Map<String, dynamic>> warga = [];
  bool loading = true;

  int currentPage = 1;
  final int perPage = 6;

  List<Map<String, dynamic>> get paginatedWarga {
    final start = (currentPage - 1) * perPage;
    final end = start + perPage;
    if (start >= warga.length) return [];
    return warga.sublist(start, end > warga.length ? warga.length : end);
  }

  int get totalPages => (warga.length / perPage).ceil();

  @override
  void initState() {
    super.initState();
    loadWarga();
  }

  Future<void> loadWarga() async {
    setState(() => loading = true);
    warga = await WargaService.getAll();
    setState(() {
      loading = false;
      currentPage = 1;
    });
  }

  void _openEdit(Map<String, dynamic> w) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WargaEditPage(wargaId: w['id'])),
    ).then((_) => loadWarga());
  }

  void _confirmDelete(int id) {
    const Color lightGreen = Color(0xFFE0F2F1);
    const Color primaryGreen = Color(0xFF2E7D32);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Hapus Warga",
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen),
          ),
          content: const Text(
            "Yakin ingin menghapus data warga ini?",
            style: TextStyle(color: Colors.black87, fontSize: 14),
          ),
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: primaryGreen),
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                "Batal",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await WargaService.delete(id);
                  loadWarga();
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(Map<String, dynamic> w, int index) {
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

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    w['nama'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "NIK: ${w['nik']}",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: primaryGreen),
              onSelected: (value) {
                if (value == 'detail') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WargaDetailPage(warga: w),
                    ),
                  );
                } else if (value == 'edit') {
                  _openEdit(w);
                } else if (value == 'hapus') {
                  _confirmDelete(w['id']);
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2E7D32)),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
        title: const Text(
          "Daftar Warga",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
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
                        ...paginatedWarga
                            .asMap()
                            .entries
                            .map(
                              (e) => _buildCard(
                                e.value,
                                e.key + ((currentPage - 1) * perPage),
                              ),
                            )
                            .toList(),

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
