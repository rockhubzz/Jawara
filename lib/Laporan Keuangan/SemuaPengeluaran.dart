import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class SemuaPengeluaran extends StatefulWidget {
  const SemuaPengeluaran({super.key});

  @override
  State<SemuaPengeluaran> createState() => _SemuaPengeluaranState();
}

class _SemuaPengeluaranState extends State<SemuaPengeluaran> {
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
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: const AppDrawer(email: "esa@gmail.com"),

      body: Stack(
        children: [
          // Tombol menu di atas
          Positioned(
            top: 30,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.menu, size: 28, color: Colors.black87),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),

          // Card utama isi tabel
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Judul
                    const Center(
                      child: Text(
                        "Laporan Pengeluaran",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tombol filter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(45, 40),
                            elevation: 0,
                          ),
                          child: const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Header tabel
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      child: const Row(
                        children: [
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

                    // Daftar isi tabel
                    Expanded(
                      child: ListView.separated(
                        itemCount: pengeluaranList.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = pengeluaranList[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: index % 2 == 0
                                  ? Colors.white
                                  : Colors.grey.shade50,
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: Text(item['no']!)),
                                Expanded(flex: 2, child: Text(item['nama']!)),
                                Expanded(flex: 3, child: Text(item['jenis']!)),
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
    );
  }
}
