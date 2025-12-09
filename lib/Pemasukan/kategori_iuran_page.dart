import 'package:flutter/material.dart';
import 'package:jawara/widgets/appDrawer.dart';
import 'package:jawara/services/kategori_iuran_service.dart';
import 'package:go_router/go_router.dart';

class KategoriIuranPage extends StatefulWidget {
  const KategoriIuranPage({super.key});

  @override
  State<KategoriIuranPage> createState() => _KategoriIuranPageState();
}

class _KategoriIuranPageState extends State<KategoriIuranPage> {
  List<Map<String, dynamic>> dataIuran = [];
  bool loading = true;

  final Color primaryGreen = const Color(0xFF2E7D32);
  final TextStyle baseFont = const TextStyle(fontFamily: "Poppins");

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      final items = await KategoriIuranService.getAll();
      setState(() {
        dataIuran = items
            .map(
              (e) => {
                'id': e['id'],
                'no': (items.indexOf(e) + 1).toString(),
                'nama': e['nama'],
                'jenis': e['jenis'],
                'nominal': formatRupiah(e['nominal']),
              },
            )
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memuat data. Periksa server.", style: baseFont),
        ),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  String formatRupiah(num number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  int parseNominal(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleaned) ?? 0;
  }

  // ==========================
  //   DIALOG TAMBAH IURAN
  // ==========================

  void openDialogTambah() {
    final nama = TextEditingController();
    final nominal = TextEditingController();
    String? selectedJenis;

    showDialog(
      context: context,
      builder: (_) => dialogIuran(
        title: "Tambah Iuran",
        namaController: nama,
        nominalController: nominal,
        selectedJenis: selectedJenis,
        onSave: () async {
          final payload = {
            "nama": nama.text,
            "jenis": selectedJenis,
            "nominal": parseNominal(nominal.text),
          };

          final res = await KategoriIuranService.create(payload);
          if (res["success"] == true) {
            await loadData();
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  // ==========================
  //   DIALOG EDIT IURAN
  // ==========================

  void openDialogEdit(Map<String, dynamic> item) {
    final nama = TextEditingController(text: item["nama"]);
    final nominal = TextEditingController(
      text: item["nominal"].toString().replaceAll(".", ""),
    );
    String? selectedJenis = item["jenis"];

    showDialog(
      context: context,
      builder: (_) => dialogIuran(
        title: "Edit Iuran",
        namaController: nama,
        nominalController: nominal,
        selectedJenis: selectedJenis,
        onSave: () async {
          final payload = {
            "nama": nama.text,
            "jenis": selectedJenis,
            "nominal": parseNominal(nominal.text),
          };

          final res = await KategoriIuranService.update(item["id"], payload);

          if (res["success"] == true) {
            await loadData();
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  // ==========================
  //   HAPUS IURAN
  // ==========================

  // Future<void> hapusIuran(String id) async {
  //   final res = await KategoriIuranService.delete(id);
  //   if (res["success"] == true) {
  //     await loadData();
  //   }
  // }

  Future<void> hapusIuran(int id) async {
    final res = await KategoriIuranService.delete(id);

    if (res == true) {
      await loadData();
    }
  }

  // ==========================
  //   WIDGET DIALOG REUSABLE
  // ==========================

  Widget dialogIuran({
    required String title,
    required TextEditingController namaController,
    required TextEditingController nominalController,
    required String? selectedJenis,
    required Function() onSave,
  }) {
    return StatefulBuilder(
      builder: (context, setStateDialog) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: primaryGreen, width: 1),
          ),
          title: Text(
            title,
            style: baseFont.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nama Iuran", style: baseFont),
                const SizedBox(height: 4),
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Masukkan nama iuran",
                    hintStyle: baseFont,
                  ),
                ),
                const SizedBox(height: 16),
                Text("Nominal (Rp)", style: baseFont),
                const SizedBox(height: 4),
                TextField(
                  controller: nominalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Masukkan nominal",
                    hintStyle: baseFont,
                  ),
                ),
                const SizedBox(height: 16),
                Text("Jenis Iuran", style: baseFont),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: selectedJenis,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "-- Pilih Jenis --",
                    hintStyle: baseFont,
                  ),
                  items: ["Rutin", "Khusus"]
                      .map(
                        (j) => DropdownMenuItem(
                          value: j,
                          child: Text(j, style: baseFont),
                        ),
                      )
                      .toList(),
                  onChanged: (v) =>
                      setStateDialog(() => selectedJenis = v.toString()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Batal",
                style: baseFont.copyWith(color: primaryGreen),
              ),
            ),
            ElevatedButton(
              onPressed: () => onSave(),
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
              child: Text(
                "Simpan",
                style: baseFont.copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================
  //   MAIN UI
  // ==========================

  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'semua';
    return Scaffold(
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: primaryGreen,
                        ),
                        onPressed: () {
                          if (from == 'pemasukan_menu') {
                            context.go('/beranda/pemasukan_menu');
                          } else {
                            context.go('/beranda/semua_menu');
                          }
                        },
                      ),
                      Text(
                        "Kategori Iuran",
                        style: baseFont.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: primaryGreen,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ========================
                  //     CARD INFO DI TENGAH
                  // ========================
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: primaryGreen.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        "Info:\n"
                        "• Iuran Rutin  : dibayar setiap hari/bulan/minggu.\n"
                        "• Iuran Khusus : sesuai kebutuhan tertentu.",
                        style: baseFont.copyWith(
                          color: primaryGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tombol tambah iuran
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryGreen, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                      ),
                      onPressed: openDialogTambah,
                      icon: Icon(Icons.add, color: primaryGreen),
                      label: Text(
                        "Tambah",
                        style: baseFont.copyWith(color: primaryGreen),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ========================
                  //        LIST IURAN
                  // ========================
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dataIuran.length,
                    itemBuilder: (context, index) {
                      final item = dataIuran[index];

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primaryGreen.withOpacity(0.15),
                            child: Text(
                              item['no'],
                              style: baseFont.copyWith(
                                fontWeight: FontWeight.bold,
                                color: primaryGreen,
                              ),
                            ),
                          ),
                          title: Text(
                            item['nama'],
                            style: baseFont.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Jenis: ${item['jenis']}\n"
                            "Nominal: Rp${item['nominal']}",
                            style: baseFont.copyWith(height: 1.2),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'Edit') {
                                openDialogEdit(item);
                              } else if (value == 'Hapus') {
                                hapusIuran(item["id"]);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'Edit',
                                child: Text('Edit', style: baseFont),
                              ),
                              PopupMenuItem(
                                value: 'Hapus',
                                child: Text('Hapus', style: baseFont),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
