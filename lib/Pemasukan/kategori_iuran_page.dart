import 'package:flutter/material.dart';
import 'package:jawara/widgets/appDrawer.dart';

class KategoriIuranPage extends StatefulWidget {
  const KategoriIuranPage({super.key});

  @override
  State<KategoriIuranPage> createState() => _KategoriIuranPageState();
}

class _KategoriIuranPageState extends State<KategoriIuranPage> {
  final List<Map<String, String>> dataIuran = [
    {
      "no": "1",
      "nama": "Iuran Bulanan",
      "jenis": "Rutin",
      "nominal": "Rp 5.000,00",
    },
    {
      "no": "2",
      "nama": "Iuran Harian",
      "jenis": "Khusus",
      "nominal": "Rp 2.000,00",
    },
    {
      "no": "3",
      "nama": "Iuran Kerja Bakti",
      "jenis": "Khusus",
      "nominal": "Rp 5.000,00",
    },
    {
      "no": "4",
      "nama": "Iuran Bersih Desa",
      "jenis": "Khusus",
      "nominal": "Rp 200.000,00",
    },
    {
      "no": "5",
      "nama": "Iuran Mingguan",
      "jenis": "Khusus",
      "nominal": "Rp 12.000,00",
    },
    {
      "no": "6",
      "nama": "Iuran Agustusan",
      "jenis": "Khusus",
      "nominal": "Rp 15.000,00",
    },
  ];

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
                    hintText: "Masukkan jumlah nominal",
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
              onPressed: () {
                // Validasi sederhana
                if (namaController.text.isNotEmpty &&
                    nominalController.text.isNotEmpty &&
                    selectedJenis != null) {
                  // Tambah ke list (jika ingin real-time)
                  setState(() {
                    dataIuran.add({
                      "no": (dataIuran.length + 1).toString(),
                      "nama": namaController.text,
                      "jenis": selectedJenis!,
                      "nominal": "Rp ${nominalController.text},00",
                    });
                  });

                  Navigator.pop(context);
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
                            Text("Nominal: ${item['nominal']}"),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            // Handle actions
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
