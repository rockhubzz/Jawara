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

  static const kombu = Color(0xFF374426);
  static const bgSoft = Color(0xFFEFF3EA);

  @override
  void initState() {
    super.initState();
    loadData(currentPage);
  }

  Future<void> loadData(int page) async {
    if (isPaginating) return;

    setState(() {
      if (page == 1) isLoading = true;
      isPaginating = true;
    });

    try {
      final res = await PemasukanService.getAll(page);

      setState(() {
        pemasukanList = List.from(res['data']['data']);
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: Image.network(imageUrl, fit: BoxFit.contain),
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
      backgroundColor: bgSoft,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kombu),
          onPressed: () {
            if (from == 'pemasukan_menu') {
              context.go('/beranda/pemasukan_menu');
            } else {
              context.go('/beranda/semua_menu');
            }
          },
        ),
        title: const Text(
          "Daftar Pemasukan Lainnya",
          style: TextStyle(color: kombu, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            const Text(
              "List Data Pemasukan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kombu,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: pemasukanList.length,
                      itemBuilder: (context, index) {
                        final item = pemasukanList[index];

                        return InkWell(
                          onTap:
                              item['bukti'] != null &&
                                  item['bukti'].toString().isNotEmpty
                              ? () => _showBuktiImage(item['bukti'])
                              : null,
                          child: Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "No: ${item['id']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kombu,
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (value) async {
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
                                                    child: const Text("Tidak"),
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
                                                      if (success) {
                                                        loadData(currentPage);
                                                      }
                                                    },
                                                    child: const Text("Iya"),
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
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text("Nama: ${item['nama']}"),
                                  Text("Jenis Pemasukan: ${item['jenis']}"),
                                  Text("Tanggal: ${item['tanggal']}"),
                                  Text(
                                    "Nominal: Rp ${formatRupiah(item['nominal'])}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: kombu,
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

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: kombu),
                  onPressed: currentPage > 1 && !isPaginating
                      ? () => loadData(currentPage - 1)
                      : null,
                ),
                Text(
                  "< $currentPage >",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kombu,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: kombu),
                  onPressed: currentPage < lastPage && !isPaginating
                      ? () => loadData(currentPage + 1)
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
