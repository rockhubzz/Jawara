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
  int currentPage = 1;
  final int perPage = 6;

  List<dynamic> users = [];

  // PAGINATED DATA
  List<dynamic> get paginatedUsers {
    final start = (currentPage - 1) * perPage;
    final end = start + perPage;

    if (start >= users.length) return [];

    return users.sublist(start, end > users.length ? users.length : end);
  }

  int get totalPages => (users.length / perPage).ceil();

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
        currentPage = 1;
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
    const Color primaryGreen = Color(0xFF2E7D32);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOMOR
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

            // INFO USER
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'] ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color.fromARGB(255, 21, 44, 22),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user['email'] ?? '-',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            // TITIK 3
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: primaryGreen),
              onSelected: (value) {
                if (value == 'edit') {
                  _openEdit(user);
                } else if (value == 'hapus') {
                  _deleteUser(user['id']);
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
                        children: [
                          ...paginatedUsers
                              .asMap()
                              .entries
                              .map(
                                (entry) => _buildCard(
                                  entry.value,
                                  entry.key + ((currentPage - 1) * perPage),
                                ),
                              )
                              .toList(),

                          const SizedBox(height: 16),

                          // ===== PAGINATION =====
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                color: const Color(0xFF2E7D32),
                                onPressed: currentPage > 1
                                    ? () => setState(() => currentPage--)
                                    : null,
                              ),

                              ...List.generate(totalPages, (index) {
                                final page = index + 1;
                                final isActive = page == currentPage;

                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => currentPage = page),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
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
                                        color: isActive
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
                                color: const Color(0xFF2E7D32),
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
      ),
    );
  }
}
