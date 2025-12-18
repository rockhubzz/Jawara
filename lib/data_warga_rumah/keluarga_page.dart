import 'package:flutter/material.dart';
import 'package:jawara/services/keluarga_service.dart';
import 'keluarga_formpage.dart';
import 'keluarga_detail_page.dart';
import 'package:go_router/go_router.dart';

class DataKeluargaPage extends StatefulWidget {
  const DataKeluargaPage({super.key});

  @override
  State<DataKeluargaPage> createState() => _DataKeluargaPageState();
}

class _DataKeluargaPageState extends State<DataKeluargaPage> {
  List<Map<String, dynamic>> keluarga = [];
  bool loading = true;

  int currentPage = 1;
  final int perPage = 6;

  List<Map<String, dynamic>> get paginatedKeluarga {
    final start = (currentPage - 1) * perPage;
    final end = start + perPage;
    if (start >= keluarga.length) return [];
    return keluarga.sublist(
      start,
      end > keluarga.length ? keluarga.length : end,
    );
  }

  int get totalPages => (keluarga.length / perPage).ceil();

  @override
  void initState() {
    super.initState();
    loadKeluarga();
  }

  Future<void> loadKeluarga() async {
    setState(() => loading = true);
    keluarga = await KeluargaService.getKeluarga();
    setState(() {
      loading = false;
      currentPage = 1;
    });
  }

  void _openEdit(Map<String, dynamic> k) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KeluargaFormPage(data: k), // kirim data untuk edit
      ),
    );

    // result = true jika berhasil submit, bisa reload list
    if (result == true) {
      loadKeluarga(); // atau setState untuk refresh list
    }
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Yakin ingin menghapus keluarga ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await KeluargaService.deleteKeluarga(id);
              loadKeluarga();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> k, int index) {
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

            /// Info keluarga
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    k['nama_keluarga'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Kepala: ${k['kepala_keluarga']}\nAlamat: ${k['alamat']}",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'detail':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KeluargaDetailPage(id: k['id']),
                      ),
                    );
                    break;

                  case 'edit':
                    _openEdit(k);
                    break;

                  case 'hapus':
                    _confirmDelete(k['id']);
                    break;
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
          "Data Keluarga",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white, // background putih
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2E7D32), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              final added = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KeluargaFormPage()),
              );
              if (added == true) loadKeluarga();
            },
            child: const Center(
              child: Icon(Icons.add, color: Color(0xFF2E7D32), size: 30),
            ),
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
                        ...paginatedKeluarga
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

                        /// Pagination
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
