import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class SemuaPemasukan extends StatefulWidget {
  const SemuaPemasukan({Key? key}) : super(key: key);

  @override
  State<SemuaPemasukan> createState() => _SemuaPemasukanState();
}

class _SemuaPemasukanState extends State<SemuaPemasukan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> pemasukanList = [
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
                          label: const Text(
                            '',
                            style: TextStyle(color: Colors.white),
                          ),
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
                              "JENIS PEMASUKAN",
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
                        itemCount: pemasukanList.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = pemasukanList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
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

          Positioned(
            top: 20,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.menu, size: 28, color: Colors.black87),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }
}
