import 'package:flutter/material.dart';
import 'package:jawara/widgets/appDrawer.dart';
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
  List<Map<String, dynamic>> dataKeluarga = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final result = await KeluargaService.getKeluarga();
      setState(() {
        dataKeluarga = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  void _openDetail(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => KeluargaDetailPage(id: item['id'])),
    );
  }

  void _openEdit(Map<String, dynamic> item) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => KeluargaFormPage(data: item)),
    );

    if (updated == true) {
      loadData();
    }
  }

  void _deleteItem(int id) async {
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
            "Hapus Keluarga",
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
                  final success = await KeluargaService.deleteKeluarga(id);
                  if (success) {
                    loadData(); // pastikan ini method reload data
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gagal menghapus data")),
                    );
                  }
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

  Widget _buildBadge(String text) {
    bool aktif = text.toLowerCase() == 'aktif';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: aktif ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: aktif ? Colors.green.shade800 : Colors.red.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ListTile(
        title: Text(
          item['nama_keluarga'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "Kepala: ${item['kepala_keluarga']}\nAlamat: ${item['alamat']}",
        ),
        onTap: () => _openDetail(item),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ICON EDIT
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 1.5),
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () => _openEdit(item),
              ),
            ),
            const SizedBox(width: 8),
            // ICON DELETE
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 1.5),
              ),
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteItem(item['id']),
              ),
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
        backgroundColor: Colors.white,
        elevation: 0.5,
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
              if (added == true) loadData();
            },
            child: const Center(
              child: Icon(Icons.add, color: Color(0xFF2E7D32), size: 30),
            ),
          ),
        ),
      ),
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : isError
            ? const Center(child: Text("Gagal memuat data. Periksa server."))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: dataKeluarga
                          .asMap()
                          .entries
                          .map((entry) => _buildCard(entry.value, entry.key))
                          .toList(),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
