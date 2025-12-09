import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/mutasi_service.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = true;
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData({int page = 1}) async {
    setState(() => isLoading = true);
    try {
      final res = await MutasiService.getAll(page: page);
      setState(() {
        data = (res['data'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        currentPage = res['current_page'] ?? page;
        lastPage = res['last_page'] ?? page;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ========= DELETE POPUP ==========
  Future<void> _confirmDelete(Map<String, dynamic> item) async {
    final id = item['id'];

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Hapus Mutasi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            child: const Text(
              "Batal",
              style: TextStyle(color: Color(0xFF2E7D32)),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (ok == true) {
      final deleted = await MutasiService.delete(id);
      if (deleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Mutasi berhasil dihapus"),
            backgroundColor: Colors.green,
          ),
        );
        loadData(page: currentPage);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menghapus"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ========= NAVIGASI EDIT ==========
  void _openEdit(Map<String, dynamic> item) {
    context.go('/mutasi/tambah?id=${item['id']}');
  }

  // ========= NAVIGASI DETAIL (API BELUM SIAP) ==========
  void _openDetail(Map<String, dynamic> item) {
    // API backend detail belum siap
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("API detail belum tersedia"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'semua';
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (from == 'beranda') {
              context.go('/beranda');
            } else {
              context.go('/beranda/semua_menu');
            }
          },
        ),
        title: const Text(
          "Mutasi Keluarga",
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== HEADER =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Daftar Mutasi Keluarga",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => context.go('/mutasi/tambah'),
                          icon: const Icon(Icons.add),
                          label: const Text("Tambah"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (isMobile)
                      _buildMobileCardView(data)
                    else
                      _buildTableView(data),

                    const SizedBox(height: 20),

                    // ===== PAGINATION =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: currentPage > 1
                              ? () => loadData(page: currentPage - 1)
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            currentPage.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: currentPage < lastPage
                              ? () => loadData(page: currentPage + 1)
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

  // =============== TABLE VIEW (DEKSTOP) =================
  Widget _buildTableView(List data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(0.5),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(1.5),
          4: FlexColumnWidth(0.8),
        },
        border: TableBorder.all(color: Color(0xFFE0E0E0)),
        children: [
          const TableRow(
            decoration: BoxDecoration(color: Color(0xFFE8F5E9)),
            children: [
              _HeaderCell("NO"),
              _HeaderCell("TANGGAL"),
              _HeaderCell("KELUARGA"),
              _HeaderCell("JENIS MUTASI"),
              _HeaderCell("AKSI"),
            ],
          ),

          // ==== DATA ROW ====
          ...List.generate(data.length, (i) {
            final item = data[i];
            final no = ((currentPage - 1) * 10) + i + 1;

            return TableRow(
              children: [
                _DataCell(Text(no.toString())),
                _DataCell(Text(item['tanggal'] ?? '-')),
                _DataCell(Text(item['keluarga']?['nama_keluarga'] ?? '-')),
                _DataCell(
                  Text(
                    item['jenis_mutasi'] ?? '-',
                    style: TextStyle(
                      color: (item['jenis_mutasi'] == "Pindah Masuk")
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ====== TITIK TIGA ======
                _DataCell(
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == "detail") _openDetail(item);
                      if (value == "edit") _openEdit(item);
                      if (value == "hapus") _confirmDelete(item);
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: "detail", child: Text("Detail")),
                      PopupMenuItem(value: "edit", child: Text("Edit")),
                      PopupMenuItem(value: "hapus", child: Text("Hapus")),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // =============== MOBILE CARD VIEW =================
  Widget _buildMobileCardView(List data) {
    return Column(
      children: data.map((item) {
        final jenis = item['jenis_mutasi'] ?? "-";
        final keluarga = item['keluarga']?['nama_keluarga'] ?? "-";

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAMA KELUARGA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      keluarga,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    // TITIK TIGA
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == "detail") _openDetail(item);
                        if (value == "edit") _openEdit(item);
                        if (value == "hapus") _confirmDelete(item);
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: "detail", child: Text("Detail")),
                        PopupMenuItem(value: "edit", child: Text("Edit")),
                        PopupMenuItem(value: "hapus", child: Text("Hapus")),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 6),
                    Text(item['tanggal'] ?? "-"),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  jenis,
                  style: TextStyle(
                    color: jenis == "Pindah Masuk"
                        ? Colors.green
                        : Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ================= HELPER WIDGETS =================

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final Widget child;
  const _DataCell(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(12), child: child);
  }
}
