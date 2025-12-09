import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/appDrawer.dart';
import 'EditPengguna.dart';
import 'tambah_pengguna_page.dart';
import 'package:go_router/go_router.dart';

class DaftarPenggunaPage extends StatefulWidget {
  const DaftarPenggunaPage({super.key});

  @override
  State<DaftarPenggunaPage> createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends State<DaftarPenggunaPage> {
  List<dynamic> users = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    try {
      final result = await UserService.getUsers();
      setState(() {
        users = result;
        isLoading = false;
        isError = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  void _openEdit(Map<String, dynamic> user) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditUserPage(user: user)),
    );
    if (updated == true) loadData();
  }

  void _deleteUser(int userId) {
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
            "Hapus Pengguna",
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen),
          ),
          content: const Text(
            "Yakin ingin menghapus pengguna ini?",
            style: TextStyle(color: Colors.black87, fontSize: 14),
          ),
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: primaryGreen),
              onPressed: () => Navigator.of(context).pop(),
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
                  final success = await UserService.deleteUser(userId);
                  if (success) {
                    loadData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gagal menghapus pengguna")),
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

  Widget _buildCard(Map<String, dynamic> user, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, // <--- ini bikin card tetap putih
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ListTile(
        title: Text(
          user['name'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(user['email'] ?? ''),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 1.5),
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () => _openEdit(user),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 1.5),
              ),
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteUser(user['id']),
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
          "Daftar Pengguna",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        //tombol reload, sementara di nonaktifin
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh, color: Color(0xFF2E7D32)),
        //     onPressed: loadData,
        //   ),
        // ],
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
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
                MaterialPageRoute(
                  builder: (_) => const TambahAkunPenggunaPage(),
                ),
              );
              if (added == true) loadData();
            },
            child: const Center(
              child: Icon(Icons.add, color: Color(0xFF2E7D32), size: 30),
            ),
          ),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Container(
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
                        children: users
                            .asMap()
                            .entries
                            .map((entry) => _buildCard(entry.value, entry.key))
                            .toList(),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
