import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class DaftarPengeluaranPage extends StatefulWidget {
  const DaftarPengeluaranPage({Key? key}) : super(key: key);

  @override
  State<DaftarPengeluaranPage> createState() => _DaftarPengeluaranPageState();
}

class _DaftarPengeluaranPageState extends State<DaftarPengeluaranPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> pengeluaranList = [
    {
      "no": "1",
      "nama": "Kerja Bakti",
      "jenis": "Kegiatan Warga",
      "tanggal": "19 Oktober 2025",
      "nominal": "Rp 100.000,00",
    },
    {
      "no": "2",
      "nama": "Kerja Bakti",
      "jenis": "Pemeliharaan Fasilitas",
      "tanggal": "19 Oktober 2025",
      "nominal": "Rp 50.000,00",
    },
    {
      "no": "3",
      "nama": "Arka",
      "jenis": "Operasional RT/RW",
      "tanggal": "17 Oktober 2025",
      "nominal": "Rp 6,00",
    },
    {
      "no": "4",
      "nama": "adsad",
      "jenis": "Pemeliharaan Fasilitas",
      "tanggal": "02 Oktober 2025",
      "nominal": "Rp 2.112,00",
    },
  ];

  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(email: "esa@gmail.com"),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black, size: 30),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Judul
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        child: Text(
                          "Daftar Data Pengeluaran",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // Tombol filter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.filter_list,
                              color: Colors.white,
                            ),
                            label: const Text(''),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(50, 40),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Header tabel
                      Container(
                        color: Colors.grey.shade100,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "NO",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "NAMA",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "JENIS PENGELUARAN",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "TANGGAL",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "NOMINAL",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "AKSI",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1),

                      // Daftar data
                      Expanded(
                        child: ListView.separated(
                          itemCount: pengeluaranList.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = pengeluaranList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: Text(item['no']!)),
                                  Expanded(flex: 2, child: Text(item['nama']!)),
                                  Expanded(
                                    flex: 3,
                                    child: Text(item['jenis']!),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(item['tanggal']!),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(item['nominal']!),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: PopupMenuButton<String>(
                                      onSelected: (value) {},
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'hapus',
                                          child: Text('Hapus'),
                                        ),
                                      ],
                                      child: const Icon(Icons.more_horiz),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Pagination
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: currentPage > 1
                                ? () => setState(() => currentPage--)
                                : null,
                            icon: const Icon(Icons.chevron_left),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C63FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              currentPage.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
