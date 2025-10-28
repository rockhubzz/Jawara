import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class PemasukanLainDaftar extends StatefulWidget {
  const PemasukanLainDaftar({Key? key}) : super(key: key);

  @override
  State<PemasukanLainDaftar> createState() => _PemasukanLainDaftarState();
}

class _PemasukanLainDaftarState extends State<PemasukanLainDaftar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> pemasukanList = [
    {
      "no": "1",
      "nama": "Sungcheol",
      "jenis": "Uang Sumbangan",
      "tanggal": "19 Oktober 2025",
      "nominal": "Rp 1.000.000,00",
    },
    {
      "no": "2",
      "nama": "Haechan",
      "jenis": "Danus Warga",
      "tanggal": "19 Oktober 2025",
      "nominal": "Rp 500.000,00",
    },
    {
      "no": "3",
      "nama": "Yeri",
      "jenis": "Iuran Warga",
      "tanggal": "17 Oktober 2025",
      "nominal": "Rp 6.000.000,00",
    },
  ];

  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(email: "esa@gmail.com"),
      backgroundColor: const Color(0xFFF5F7FA),

      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 30),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
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
                        "Daftar Data Pemasukan",
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
                                  // Baris atas: No + Aksi
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
                                      PopupMenuButton<String>(
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
                                    ],
                                  ),
                                  const SizedBox(height: 6),

                                  Text(
                                    "Nama: ${item['nama']}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    "Jenis Pemasukan: ${item['jenis']}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    "Tanggal: ${item['tanggal']}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    "Nominal: ${item['nominal']}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
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
