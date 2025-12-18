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

  static const Color kombu = Color(0xFF374426);
  static const Color bgSoft = Color(0xFFF1F5EE);

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

  void _confirmBayar(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Konfirmasi Pembayaran",
          style: TextStyle(fontWeight: FontWeight.bold, color: kombu),
        ),
        content: const Text("Tandai tagihan ini sebagai sudah dibayar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: kombu)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kombu),
            onPressed: () async {
              Navigator.pop(context);

              await TagihanService.update(item['id'], {
                'keluarga_id': item['keluarga']['id'],
                'kategori_iuran_id': item['kategori_iuran']['id'],
                'tanggal_tagihan': item['tanggal_tagihan'],
                'status': 'sudah_bayar',
                // jumlah is required by backend
                'jumlah': item['kategori_iuran']['nominal'],
              });

              loadTagihan();
            },
            child: const Text("Bayar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ---------- CHIP ----------
  Widget _chip(String text, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final isBelum = status.toLowerCase().contains("belum");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isBelum ? const Color(0xFFFFF8E1) : const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isBelum ? "Belum Bayar" : "Lunas",
        style: TextStyle(
          fontSize: 12,
          color: isBelum ? Colors.brown : kombu,
          fontWeight: FontWeight.w600,
        ),
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
          style: TextStyle(fontWeight: FontWeight.bold, color: kombu),
        ),
        content: const Text("Apakah Anda yakin ingin menghapus tagihan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak", style: TextStyle(color: kombu)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kombu),
            onPressed: () async {
              await TagihanService.delete(id);
              Navigator.pop(context);
              loadTagihan();
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ---------- CARD ----------
  Widget _buildCard(Map<String, dynamic> item, int number) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: kombu,
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _chip(
                          "Iuran: ${item['kategori_iuran']?['nama'] ?? '-'}",
                          const Color(0xFFE8F5E9),
                        ),
                        _chip(
                          "Nominal: ${item['kategori_iuran']?['nominal'] ?? '-'}",
                          const Color(0xFFFFF3E0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'hapus') _confirmDelete(item['id']);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                ],
                icon: const Icon(Icons.more_vert, color: kombu),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                item['tanggal_tagihan'] ?? '',
                style: const TextStyle(fontSize: 13),
              ),
              const Spacer(),

              if ((item['status'] ?? '').toLowerCase() == 'belum_bayar') ...[
                TextButton.icon(
                  onPressed: () => _confirmBayar(item),
                  icon: const Icon(Icons.payments, size: 16),
                  label: const Text("Bayar"),
                  style: TextButton.styleFrom(
                    foregroundColor: kombu,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              _statusBadge(item['status'] ?? ''),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- BUILD ----------
  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'semua';

    return Scaffold(
      backgroundColor: bgSoft,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kombu),
          onPressed: () {
            if (from == 'pemasukan_menu') {
              context.go('/beranda/pemasukan_menu');
            } else {
              context.go('/beranda/semua_menu');
            }
          },
        ),
        title: const Text(
          "Tagihan",
          style: TextStyle(color: kombu, fontWeight: FontWeight.w600),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: dataIuran.length,
              itemBuilder: (context, index) =>
                  _buildCard(dataIuran[index], index + 1),
            ),
    );
  }
}
