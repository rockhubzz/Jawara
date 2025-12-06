import 'package:flutter/material.dart';
import '../../services/warga_service.dart';
import 'tambahWarga_page.dart';
import 'warga_edit_page.dart';
import 'warga_detail_page.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/appDrawer.dart';

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
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Warga"),
        content: const Text("Yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              await WargaService.delete(id);
              Navigator.pop(ctx);
              loadWarga();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Warga"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TambahWargaPage()),
        ).then((_) => loadWarga()),
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: warga.length,
              itemBuilder: (context, i) {
                final w = warga[i];

                return Card(
                  child: ListTile(
                    title: Text(w['nama']),
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
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WargaEditPage(wargaId: w['id']),
                            ),
                          ).then((_) => loadWarga()),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => confirmDelete(w['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
