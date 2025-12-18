import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';
import '../services/kegiatan_service.dart';
import 'package:go_router/go_router.dart';

class SemuaPengeluaran extends StatefulWidget {
  const SemuaPengeluaran({super.key});

  @override
  State<SemuaPengeluaran> createState() => _SemuaPengeluaranState();
}

class _SemuaPengeluaranState extends State<SemuaPengeluaran> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> pengeluaranList = [];
  bool loading = true;

  int currentPage = 1;
  final int perPage = 4;

  List<Map<String, dynamic>> get paginatedPengeluaran {
    final start = (currentPage - 1) * perPage;
    final end = start + perPage;
    if (start >= pengeluaranList.length) return [];
    return pengeluaranList.sublist(
      start,
      end > pengeluaranList.length ? pengeluaranList.length : end,
    );
  }

  int get totalPages => (pengeluaranList.length / perPage).ceil();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final kegiatan = await KegiatanService.getAll();

      final List<Map<String, dynamic>> mapped = kegiatan.map((k) {
        return {
          'nama': k['nama'] ?? '-',
          'jenis': k['kategori'] ?? '-',
          'tanggal': formatTanggal(k['tanggal']),
          'nominal': formatRupiah(k['biaya']),
        };
      }).toList();

      setState(() {
        pengeluaranList = mapped;
        loading = false;
        currentPage = 1;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      debugPrint("Error loading pengeluaran: $e");
    }
  }

  String formatRupiah(dynamic value) {
    final intVal = (value is num)
        ? value.toInt()
        : int.tryParse(value?.toString() ?? '') ?? 0;
    return "Rp ${intVal.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}";
  }

  String formatTanggal(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '-';

    try {
      final date = DateTime.parse(isoDate);
      const months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];

      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return isoDate;
    }
  }

  Widget _buildCard(Map<String, dynamic> item, int index) {
    const red = Color(0xFFB00020);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFF8EDEB),
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(
                  color: Color(0xFFB00020),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["nama"] ?? "-",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Jenis: ${item["jenis"]}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Tanggal: ${item["tanggal"]}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                item["nominal"],
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: red,
                ),
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
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2E7D32)),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
        title: const Text(
          "Laporan Pengeluaran",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: [
                        ...paginatedPengeluaran
                            .asMap()
                            .entries
                            .map(
                              (e) => _buildCard(
                                e.value,
                                e.key + ((currentPage - 1) * perPage),
                              ),
                            )
                            .toList(),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: currentPage > 1
                                  ? () => setState(() => currentPage--)
                                  : null,
                            ),
                            ...List.generate(totalPages, (i) {
                              final page = i + 1;
                              final active = page == currentPage;
                              return GestureDetector(
                                onTap: () => setState(() => currentPage = page),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: active
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
                                      color: active
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
    );
  }
}
