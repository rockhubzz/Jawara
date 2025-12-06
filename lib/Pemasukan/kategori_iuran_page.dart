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

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      loading = true;
    });
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
        const SnackBar(content: Text("Gagal memuat data. Periksa server.")),
      );
    } finally {
      setState(() {
        loading = false;
      });
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

  void openTambahDialog() {
    final TextEditingController namaController = TextEditingController();
    final TextEditingController nominalController = TextEditingController();
    String? selectedJenis;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Buat Iuran Baru",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                const Text("Nama Iuran"),
                const SizedBox(height: 4),
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                    hintText: "Masukkan nama iuran",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Nominal (Rp)"),
                const SizedBox(height: 4),
                TextField(
                  controller: nominalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Masukkan jumlah nominal (Rp.)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Jenis Iuran"),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: selectedJenis,
                  items: ["Rutin", "Khusus"].map((jenis) {
                    return DropdownMenuItem(value: jenis, child: Text(jenis));
                  }).toList(),
                  onChanged: (value) {
                    selectedJenis = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "-- Pilih Jenis --",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (namaController.text.isNotEmpty &&
                    nominalController.text.isNotEmpty &&
                    selectedJenis != null) {
                  final payload = {
                    "nama": namaController.text,
                    "jenis": selectedJenis,
                    "nominal": parseNominal(nominalController.text),
                  };

                  final res = await KategoriIuranService.create(payload);
                  if (res["success"] == true) {
                    // add to local list keeping layout same
                    setState(() {
                      final newItem = res["data"];
                      dataIuran.insert(0, {
                        "id": newItem['id'],
                        "no": (dataIuran.length + 1).toString(),
                        "nama": newItem['nama'],
                        "jenis": newItem['jenis'],
                        "nominal": formatRupiah(newItem['nominal']),
                      });
                    });
                    Navigator.pop(context);
                  } else {
                    final msg = res["errors"]?.toString() ?? "Gagal membuat";
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg)));
                  }
                }
              },
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void openFilterDialog() {
    // belum berfungsi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),

        title: const Text(
          "Kategori Iuran",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Section
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.blue.shade50,
                  child: const Text(
                    "Info:\n"
                    "Iuran Bulanan: Dibayar setiap bulan sekali secara rutin.\n"
                    "Iuran Khusus: Dibayar sesuai jadwal atau kebutuhan tertentu.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),

                // Add and Filter Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onPressed: openTambahDialog,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Tambah',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onPressed: openFilterDialog,
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      label: const Text(
                        'Filter',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // List Cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dataIuran.length,
                  itemBuilder: (context, index) {
                    final item = dataIuran[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(child: Text(item['no']!)),
                        title: Text(item['nama']!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Jenis: ${item['jenis']}"),
                            Text("Nominal: Rp.${item['nominal']}"),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            final id =
                                int.tryParse(item['id'].toString()) ?? -1;
                            if (value == 'Edit') {
                              // open a similar dialog prefilled (you can reuse openTambahDialog but prefill)
                              final TextEditingController namaController =
                                  TextEditingController(text: item['nama']);
                              final TextEditingController nominalController =
                                  TextEditingController(
                                    text: item['nominal']!.replaceAll(
                                      RegExp(r'[^0-9]'),
                                      '',
                                    ),
                                  );
                              String selectedJenis = item['jenis']!;
                              // show dialog like openTambahDialog but on save call update
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Edit Iuran"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: namaController,
                                            decoration: const InputDecoration(
                                              labelText: "Nama",
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: nominalController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: "Nominal (Rp.)",
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          DropdownButtonFormField<String>(
                                            value: selectedJenis,
                                            items: ["Rutin", "Khusus"]
                                                .map(
                                                  (e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Text(e),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (v) =>
                                                selectedJenis = v!,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text("Batal"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final payload = {
                                            'nama': namaController.text,
                                            'jenis': selectedJenis,
                                            'nominal': parseNominal(
                                              nominalController.text,
                                            ),
                                          };
                                          final res =
                                              await KategoriIuranService.update(
                                                id,
                                                payload,
                                              );
                                          if (res['success'] == true) {
                                            // update local list
                                            setState(() {
                                              final idx = dataIuran.indexWhere(
                                                (it) =>
                                                    it['id'].toString() == id,
                                              );
                                              if (idx != -1) {
                                                dataIuran[idx]['nama'] =
                                                    payload['nama'];
                                                dataIuran[idx]['jenis'] =
                                                    payload['jenis'];
                                                dataIuran[idx]['nominal'] =
                                                    formatRupiah(
                                                      payload['nominal'] as num,
                                                    );
                                              }
                                            });
                                            Navigator.pop(context, true);
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  res['errors'].toString(),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text("Simpan"),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (ok == true) {
                                // optional: feedback
                              }
                            } else if (value == 'Hapus') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Konfirmasi Hapus"),
                                  content: Text(
                                    "Yakin ingin menghapus ${item['nama']}?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text("Batal"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text("Hapus"),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                final ok = await KategoriIuranService.delete(
                                  id,
                                );
                                if (ok) {
                                  setState(() {
                                    dataIuran.removeWhere(
                                      (it) => it['id'] == id,
                                    );
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Gagal menghapus"),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return ['Edit', 'Hapus'].map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
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
    );
  }
}
