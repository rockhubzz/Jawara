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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F6F8),

      body: Stack(
        children: [
          if (loading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            ),

          if (!loading)
            Padding(
              padding: const EdgeInsets.only(
                top: 90,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= HEADER =================
                      const Center(
                        child: Text(
                          "Laporan Pemasukan",
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ================= LIST =================
                      Expanded(
                        child: ListView.builder(
                          itemCount: pemasukanList.length,
                          itemBuilder: (context, index) {
                            final item = pemasukanList[index];

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),

                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),

                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ICON LINGKARAN
                                      Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF2E7D32,
                                          ).withOpacity(0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.attach_money,
                                          color: Color(0xFF2E7D32),
                                          size: 26,
                                        ),
                                      ),

                                      const SizedBox(width: 14),

                                      // DATA UTAMA
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
                                              ),
                                            ),

                                            Text(
                                              "Tanggal: ${item["tanggal"]}",
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              item["nominal"],
                                              style: const TextStyle(
                                                color: Color(0xFF2E7D32),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // TITIK TIGA
                                      const Icon(Icons.more_vert),
                                    ],
                                  ),
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

          // BACK BUTTON
          Positioned(
            top: 22,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
              onPressed: () => context.go('/beranda/semua_menu'),
            ),
          ),
        ],
      ),
    );
  }
}
