import 'package:flutter/material.dart';
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

  static const Color kombu = Color(0xFF374426);
  static const Color bgSoft = Color(0xFFF1F5EE);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // =====================
  // LOAD DATA
  // =====================
  Future<void> loadData() async {
    setState(() => loading = true);
    final items = await KategoriIuranService.getAll();
    setState(() {
      dataIuran = items
          .asMap()
          .entries
          .map(
            (e) => {
              'id': e.value['id'],
              'no': (e.key + 1).toString(),
              'nama': e.value['nama'],
              'jenis': e.value['jenis'],
              'nominal': e.value['nominal'],
            },
          )
          .toList();
      loading = false;
    });
  }

  // =====================
  // TAMBAH IURAN
  // =====================
  void openDialogTambah() {
    final nama = TextEditingController();
    final nominal = TextEditingController();
    String? jenis;

    showDialog(
      context: context,
      builder: (_) => _dialogIuran(
        title: "Tambah Iuran",
        nama: nama,
        nominal: nominal,
        selectedJenis: jenis,
        onSave: () async {
          await KategoriIuranService.create({
            "nama": nama.text,
            "jenis": jenis,
            "nominal": int.parse(nominal.text),
          });
          Navigator.pop(context);
          loadData();
        },
      ),
    );
  }

  // =====================
  // EDIT IURAN
  // =====================
  void openDialogEdit(Map<String, dynamic> item) {
    final nama = TextEditingController(text: item['nama']);
    final nominal = TextEditingController(text: item['nominal'].toString());
    String? jenis = item['jenis'];

    showDialog(
      context: context,
      builder: (_) => _dialogIuran(
        title: "Edit Iuran",
        nama: nama,
        nominal: nominal,
        selectedJenis: jenis,
        onSave: () async {
          await KategoriIuranService.update(item['id'], {
            "nama": nama.text,
            "jenis": jenis,
            "nominal": int.parse(nominal.text),
          });
          Navigator.pop(context);
          loadData();
        },
      ),
    );
  }

  // =====================
  // KONFIRMASI HAPUS
  // =====================
  void confirmHapus(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah anda yakin menghapus tagihan iuran ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await KategoriIuranService.delete(id);
              loadData();
            },
            child: const Text("Iya", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // =====================
  // DIALOG REUSABLE
  // =====================
  Widget _dialogIuran({
    required String title,
    required TextEditingController nama,
    required TextEditingController nominal,
    required String? selectedJenis,
    required Function() onSave,
  }) {
    return StatefulBuilder(
      builder: (context, setStateDialog) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(color: kombu)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nama,
                decoration: const InputDecoration(labelText: "Nama Iuran"),
              ),
              TextField(
                controller: nominal,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nominal"),
              ),
              DropdownButtonFormField<String>(
                value: selectedJenis,
                hint: const Text("Pilih Jenis"),
                items: const [
                  DropdownMenuItem(value: "Rutin", child: Text("Rutin")),
                  DropdownMenuItem(value: "Khusus", child: Text("Khusus")),
                ],
                onChanged: (v) => setStateDialog(() => selectedJenis = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(onPressed: onSave, child: const Text("Simpan")),
          ],
        );
      },
    );
  }

  // =====================
  // UI
  // =====================
  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'semua';

    return Scaffold(
      backgroundColor: bgSoft,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kombu),
          onPressed: () {
            context.go(
              from == 'pemasukan_menu'
                  ? '/beranda/pemasukan_menu'
                  : '/beranda/semua_menu',
            );
          },
        ),
        title: const Text(
          "Kategori Iuran",
          style: TextStyle(color: kombu, fontWeight: FontWeight.w600),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlinedButton.icon(
                        onPressed: openDialogTambah,
                        icon: const Icon(Icons.add, color: kombu),
                        label: const Text(
                          "Tambah",
                          style: TextStyle(color: kombu),
                        ),
                      ),
                      const SizedBox(height: 14),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: kombu),
                        ),
                        child: const Text(
                          "Info:\n• Iuran Rutin dibayar berkala\n• Iuran Khusus sesuai kebutuhan",
                          style: TextStyle(color: kombu, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 20),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dataIuran.length,
                        itemBuilder: (context, index) {
                          final item = dataIuran[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 8),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: kombu,
                                  child: Text(
                                    item['no'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['nama'],
                                        style: const TextStyle(color: kombu),
                                      ),
                                      Text(
                                        "Jenis: ${item['jenis']} | Rp${item['nominal']}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: kombu,
                                  ),
                                  onSelected: (v) {
                                    if (v == 'edit') {
                                      openDialogEdit(item);
                                    } else {
                                      confirmHapus(item['id']);
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text("Edit"),
                                    ),
                                    PopupMenuItem(
                                      value: 'hapus',
                                      child: Text("Hapus"),
                                    ),
                                  ],
                                ),
                              ],
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
