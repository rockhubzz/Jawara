import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';
import '../services/pemasukan_lain_service.dart';
import 'package:go_router/go_router.dart';

class PemasukanLainDaftar extends StatefulWidget {
  const PemasukanLainDaftar({Key? key}) : super(key: key);

  @override
  State<PemasukanLainDaftar> createState() => _PemasukanLainDaftarState();
}

class _PemasukanLainDaftarState extends State<PemasukanLainDaftar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> pemasukanList = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData(currentPage);
  }

  Future<void> loadData(int page) async {
    setState(() => isLoading = true);

    try {
      final res = await PemasukanService.getAll(page);

      setState(() {
        pemasukanList = res['data']['data'];
        currentPage = res['data']['current_page'];
        lastPage = res['data']['last_page'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
    }
  }

  String formatRupiah(num number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  int parseNominal(String value) {
    // Hapus titik, koma, dan spasi
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleaned) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),

        title: const Text(
          "Daftar Pemasukan Lain",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF5F7FA),

      body: Stack(
        children: [
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
                                        "No: ${item['id']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            context.push(
                                              '/pemasukan-lain/edit',
                                              extra: item,
                                            );
                                          } else if (value == 'hapus') {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text("Hapus Data"),
                                                content: const Text(
                                                  "Yakin ingin menghapus data ini?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text("Batal"),
                                                  ),
                                                  ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      final success =
                                                          await PemasukanService.delete(
                                                            item['id'],
                                                          );
                                                      if (success)
                                                        loadData(currentPage);
                                                    },
                                                    child: const Text("Hapus"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
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
                                    "Nominal: Rp. ${formatRupiah(item['nominal'])}",
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
