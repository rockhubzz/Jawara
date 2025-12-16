import 'package:flutter/material.dart';
import '../services/pemasukan_lain_service.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class PemasukanLainDaftar extends StatefulWidget {
  const PemasukanLainDaftar({Key? key}) : super(key: key);

  @override
  State<PemasukanLainDaftar> createState() => _PemasukanLainDaftarState();
}

class _PemasukanLainDaftarState extends State<PemasukanLainDaftar> {
  List<dynamic> pemasukanList = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = true;
  bool isPaginating = false;

  @override
  void initState() {
    super.initState();
    loadData(currentPage);
  }

  Future<void> loadData(int page) async {
    if (isPaginating) return;

    setState(() {
      if (page == 1) {
        isLoading = true;
      }
      isPaginating = true;
    });

    try {
      final res = await PemasukanService.getAll(page);

      setState(() {
        pemasukanList = List.from(res['data']['data']); // ensure clean reset
        currentPage = res['data']['current_page'];
        lastPage = res['data']['last_page'];
        isLoading = false;
        isPaginating = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isPaginating = false;
      });

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

  void _showBuktiImage(String buktiPath) {
    final baseUrl = AuthService.baseUrl ?? '';
    final imageUrl = baseUrl.replaceFirst('/api', '/storage/') + buktiPath;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Bukti Pemasukan'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxHeight: 400),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text('Gagal memuat gambar'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'semua';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
          onPressed: () {
            if (from == 'pemasukan_menu') {
              context.go('/beranda/pemasukan_menu');
            } else {
              context.go('/beranda/semua_menu');
            }
          },
        ),

        title: const Text(
          "Daftar Pemasukan Lain",
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
      ),

      body: Container(
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

        child: Padding(
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
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(
                      "Daftar Data Pemasukan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),

                  // Tombol filter
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     ElevatedButton.icon(
                  //       onPressed: () {},
                  //       icon: const Icon(
                  //         Icons.filter_list,
                  //         color: Colors.white,
                  //       ),
                  //       label: const Text(''),
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: const Color(0xFF2E7D32),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(8),
                  //         ),
                  //         minimumSize: const Size(50, 40),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.builder(
                      itemCount: pemasukanList.length,
                      itemBuilder: (context, index) {
                        final item = pemasukanList[index];
                        return InkWell(
                          onTap: item['bukti'] != null && item['bukti'].toString().isNotEmpty
                              ? () => _showBuktiImage(item['bukti'])
                              : null,
                          child: Card(
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
                                  // Baris atas
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "No: ${item['id']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF2E7D32),
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
                                        itemBuilder: (context) => const [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Text('Edit'),
                                          ),
                                          PopupMenuItem(
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
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                  if (item['bukti'] != null && item['bukti'].toString().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        "📎 Bukti tersedia - Tap untuk lihat",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
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
                        onPressed: (currentPage > 1 && !isPaginating)
                            ? () => loadData(currentPage - 1)
                            : null,
                        icon: const Icon(Icons.chevron_left),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: isPaginating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "$currentPage / $lastPage",
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),

                      IconButton(
                        onPressed: (currentPage < lastPage && !isPaginating)
                            ? () => loadData(currentPage + 1)
                            : null,
                        icon: const Icon(Icons.chevron_right),
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
