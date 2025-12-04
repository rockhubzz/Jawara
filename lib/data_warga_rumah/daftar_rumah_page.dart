import 'package:flutter/material.dart';
import 'package:jawara/services/rumah_service.dart';
import 'rumah_form_page.dart';
import 'rumah_detail_page.dart';
import 'package:go_router/go_router.dart';

import 'package:jawara/widgets/appDrawer.dart';

class RumahListPage extends StatefulWidget {
  const RumahListPage({super.key});

  @override
  State<RumahListPage> createState() => _RumahListPageState();
}

class _RumahListPageState extends State<RumahListPage> {
  List<Map<String, dynamic>> rumahList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await RumahService.getAll();
      setState(() {
        rumahList = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Rumah"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
      ),

      // drawer: const AppDrawer(email: 'admin1@mail.com'),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: rumahList.length,
              itemBuilder: (_, i) {
                final r = rumahList[i];
                return ListTile(
                  title: Text(r['kode']),
                  subtitle: Text("Alamat: ${r['alamat']}"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RumahDetailPage(rumah: r),
                      ),
                    );
                    fetchData();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RumahFormPage()),
          );
          if (result == true) fetchData();
        },
      ),
    );
  }
}
