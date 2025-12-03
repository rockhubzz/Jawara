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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() => loading = true);
    try {
      users = await UserService.getUsers();
    } catch (_) {}
    setState(() => loading = false);
  }

  void _confirmDelete(int userId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete User"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await UserService.deleteUser(userId);
              if (success) fetchUsers();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const AppDrawer(email: "admin1@mail.com"),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/beranda'),
        ),

        title: const Text("Daftar Pengguna"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchUsers),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahAkunPenggunaPage()),
          );
          fetchUsers();
        },
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text("${index + 1}")),
                    title: Text(user["name"]),
                    subtitle: Text(user["email"]),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "edit") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditUserPage(user: user),
                            ),
                          ).then((_) => fetchUsers());
                        } else if (value == "delete") {
                          _confirmDelete(user["id"]);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: "edit",
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue),
                              SizedBox(width: 10),
                              Text("Edit"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: "delete",
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 10),
                              Text("Delete"),
                            ],
                          ),
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
