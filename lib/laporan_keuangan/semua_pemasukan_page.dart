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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> pemasukanList = [];
  bool loading = true;
  int currentPage = 1;

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

    // Parse Tagihan Iuran (pemasukan otomatis)
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

    // Parse Pemasukan Lain (manual)
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA),

      body: Stack(
        children: [
          // ================= LOADING =================
          if (loading) const Center(child: CircularProgressIndicator()),

          if (!loading)
            Padding(
              padding: const EdgeInsets.only(
                top: 80,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),

                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Laporan Pemasukan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // LIST PEMASUKAN
                      Expanded(
                        child: ListView.builder(
                          itemCount: pemasukanList.length,
                          itemBuilder: (context, index) {
                            final item = pemasukanList[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "No: ${item['no']}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Icon(Icons.more_horiz),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    Text("Nama: ${item['nama']}"),
                                    Text("Jenis: ${item['jenis']}"),
                                    Text("Tanggal: ${item['tanggal']}"),
                                    Text(
                                      "Nominal: ${item['nominal']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Positioned(
            top: 20,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.go('/beranda/semua_menu'),
            ),
          ),
        ],
      ),
    );
  }
}
