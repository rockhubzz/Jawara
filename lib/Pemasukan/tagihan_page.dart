import 'package:flutter/material.dart';
import 'package:jawara/services/tagihan_service.dart';
import 'package:go_router/go_router.dart';

class TagihanPage extends StatefulWidget {
  const TagihanPage({super.key});

  @override
  State<TagihanPage> createState() => _TagihanPageState();
}

class _TagihanPageState extends State<TagihanPage> {
  List<dynamic> dataIuran = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTagihan();
  }

  void loadTagihan() async {
    final res = await TagihanService.getAll();
    setState(() {
      dataIuran = res;
      isLoading = false;
    });
  }

  // ---------- BADGE ----------
  Widget _buildBadge(String text, {Color? bg, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bg ?? const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? const Color(0xFF2E7D32),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _smallInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }

  // ---------- POPUP DELETE ----------
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Hapus Tagihan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        content: const Text("Apakah Anda yakin ingin menghapus tagihan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            onPressed: () async {
              await TagihanService.delete(id);
              Navigator.pop(context);
              loadTagihan();
            },
            child: const Text(
              "Hapus",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- CARD ----------
  Widget _buildCard(Map<String, dynamic> item, int number) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- ROW ATAS -----
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFE8F5E9),
                  child: Text(
                    number.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['keluarga']?['nama_keluarga'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _smallInfoChip(
                            "Iuran: ${item['kategori_iuran']?['nama'] ?? '-'}",
                          ),
                          _smallInfoChip(
                            "Nominal: ${item['kategori_iuran']?['nominal'] ?? '-'}",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ----- STATUS -----
                _buildBadge(
                  item['keluarga']?['status'] ?? '',
                  bg:
                      (item['keluarga']?['status'] ?? '').toLowerCase() ==
                          'aktif'
                      ? const Color(0xFFE8F5E9)
                      : Colors.red.shade50,
                  textColor:
                      (item['keluarga']?['status'] ?? '').toLowerCase() ==
                          'aktif'
                      ? const Color(0xFF2E7D32)
                      : Colors.red.shade700,
                ),

                // ----- MENU HAPUS ONLY -----
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'hapus') _confirmDelete(item['id']);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ----- ROW BAWAH -----
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 15, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  item['tanggal_tagihan'] ?? '',
                  style: const TextStyle(fontSize: 13),
                ),
                const Spacer(),

                _buildBadge(
                  (item['status'] ?? '').toLowerCase().contains("belum")
                      ? "Belum Bayar"
                      : "Lunas",
                  bg: (item['status'] ?? '').toLowerCase().contains("belum")
                      ? const Color(0xFFFFF8E1)
                      : const Color(0xFFE8F5E9),
                  textColor:
                      (item['status'] ?? '').toLowerCase().contains("belum")
                      ? const Color(0xFF795548)
                      : const Color(0xFF2E7D32),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------- BUILD ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

        child: Column(
          children: [
            // APPBAR
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF2E7D32),
                ),
                onPressed: () => context.go('/beranda/semua_menu'),
              ),
              title: const Text(
                "Tagihan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ----- LIST -----
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: dataIuran.length,
                itemBuilder: (context, index) =>
                    _buildCard(dataIuran[index], index + 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
