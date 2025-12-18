import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';
import 'package:jawara/services/semua_pemasukan_service.dart';
import 'package:go_router/go_router.dart';

class SemuaPemasukan extends StatefulWidget {
  const SemuaPemasukan({Key? key}) : super(key: key);

  @override
  State<SemuaPemasukan> createState() => _SemuaPemasukanState();
}

class _SemuaPemasukanState extends State<SemuaPemasukan> {
  List<Map<String, dynamic>> pemasukanList = [];
  bool loading = true;

  int currentPage = 1;
  final int perPage = 4;

  List<Map<String, dynamic>> get paginatedPemasukan {
    final start = (currentPage - 1) * perPage;
    final end = start + perPage;
    if (start >= pemasukanList.length) return [];
    return pemasukanList.sublist(
      start,
      end > pemasukanList.length ? pemasukanList.length : end,
    );
  }

  int get totalPages => (pemasukanList.length / perPage).ceil();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final res = await SemuaPemasukanService.getPemasukan();

    List tagihan = res["tagihan_iuran"] ?? [];
    List lain = res["pemasukan_lain"] ?? [];

    final List<Map<String, dynamic>> combined = [];
    int index = 1;

    for (var item in tagihan) {
      combined.add({
        "no": index.toString(),
        "nama": item["nama_keluarga"],
        "jenis": item["nama_iuran"],
        "tanggal": item["tanggal_bayar"],
        "nominal": "Rp ${item["nominal"]}",
      });
      index++;
    }

    for (var item in lain) {
      combined.add({
        "no": index.toString(),
        "nama": item["nama"],
        "jenis": item["jenis"],
        "tanggal": item["tanggal"],
        "nominal": "Rp ${item["nominal"]}",
      });
      index++;
    }

    setState(() {
      pemasukanList = combined;
      loading = false;
      currentPage = 1;
    });
  }

  Widget _buildCard(Map<String, dynamic> item, int index) {
    const primaryGreen = Color(0xFF2E7D32);

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
            // Nomor urut
            CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFE8F5E9),
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Kolom 1: Jenis & Tanggal
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

            // Kolom 2: Nominal
            Expanded(
              flex: 1,
              child: Text(
                item["nominal"],
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 18, // lebih besar
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2E7D32)),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
        title: const Text(
          "Laporan Pemasukan",
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
                        ...paginatedPemasukan
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
