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

  @override
  void initState() {
    super.initState();
    loadWarga();
  }

  Future<void> loadWarga() async {
    setState(() => loading = true);
    warga = await WargaService.getAll();
    setState(() => loading = false);
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) {
        // warna custom
        const Color lightGreen = Color(0xFFE0F2F1);
        const Color primaryGreen = Color(0xFF2E7D32);

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
            "Yakin ingin menghapus data ini?",
            style: TextStyle(color: Colors.black87, fontSize: 14),
          ),
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: primaryGreen),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Batal",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await WargaService.delete(id);
                  loadWarga();
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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

  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri?.queryParameters?['from'] ?? 'semua';
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2E7D32)),
          onPressed: () {
            if (from == 'beranda') {
              context.go('/beranda');
            } else {
              context.go('/beranda/semua_menu');
            }
          },
        ),
        title: const Text(
          "Daftar Warga",
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
          borderRadius: BorderRadius.circular(
            8,
          ), // bentuk kotak dengan sudut membulat tipis
          border: Border.all(
            color: const Color(0xFF2E7D32), // garis hijau
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TambahWargaPage()),
            ).then((_) => loadWarga()),
            child: const Center(
              child: Icon(Icons.add, color: Color(0xFF2E7D32), size: 30),
            ),
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 235, 188),
              Color.fromARGB(255, 181, 255, 183),
            ],
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
                      children: warga.map((w) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              w['nama'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text("NIK: ${w['nik']}"),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WargaDetailPage(warga: w),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // ICON EDIT
                                Container(
                                  width: 32, // ukuran container lebih kecil
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.orange,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets
                                        .zero, // hilangkan padding default
                                    iconSize: 18, // ubah ukuran ikon
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            WargaEditPage(wargaId: w['id']),
                                      ),
                                    ).then((_) => loadWarga()),
                                  ),
                                ),
                                // Container(
                                //   width: 32, // ukuran container lebih kecil
                                //   height: 32,
                                //   decoration: BoxDecoration(
                                //     shape: BoxShape.circle,
                                //     border: Border.all(
                                //       color: Colors.orange,
                                //       width: 1.5,
                                //     ),
                                //   ),
                                //   child: IconButton(
                                //     icon: const Icon(
                                //       Icons.edit,
                                //       color: Colors.orange,
                                //     ),
                                //     onPressed: () => Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (_) =>
                                //             WargaEditPage(wargaId: w['id']),
                                //       ),
                                //     ).then((_) => loadWarga()),
                                //   ),
                                // ),
                                const SizedBox(width: 8),
                                // ICON DELETE
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 18,
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => confirmDelete(w['id']),
                                  ),
                                ),
                                // Container(
                                //   decoration: BoxDecoration(
                                //     shape: BoxShape.circle,
                                //     border: Border.all(
                                //       color: Colors.red,
                                //       width: 1.5,
                                //     ),
                                //   ),
                                //   child: IconButton(
                                //     icon: const Icon(
                                //       Icons.delete,
                                //       color: Colors.red,
                                //     ),
                                //     onPressed: () => confirmDelete(w['id']),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
