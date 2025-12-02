import 'package:flutter/material.dart';
import 'package:jawara/widgets/appDrawer.dart';

class DataKeluargaPage extends StatefulWidget {
  const DataKeluargaPage({super.key});

  @override
  State<DataKeluargaPage> createState() => _DataKeluargaPageState();
}

class _DataKeluargaPageState extends State<DataKeluargaPage> {
  final List<Map<String, String>> dataKeluarga = [
    {
      'no': '1',
      'nama_keluarga': 'Keluarga Andika Pratama',
      'kepala_keluarga': 'Andika Pratama',
      'alamat': 'Jl. Mawar No. 12, Kelurahan Sukun, Malang',
      'status_kepemilikan': 'Pemilik',
      'status': 'Aktif',
    },
    {
      'no': '2',
      'nama_keluarga': 'Keluarga Rizky Ananda',
      'kepala_keluarga': 'Rizky Ananda',
      'alamat': 'Jl. Melati No. 8, Kelurahan Lowokwaru, Malang',
      'status_kepemilikan': 'Penyewa',
      'status': 'Aktif',
    },
    {
      'no': '3',
      'nama_keluarga': 'Keluarga Dewi Lestari',
      'kepala_keluarga': 'Dewi Lestari',
      'alamat': 'Jl. Anggrek No. 3, Kelurahan Blimbing, Malang',
      'status_kepemilikan': 'Pemilik',
      'status': 'Aktif',
    },
    {
      'no': '4',
      'nama_keluarga': 'Keluarga Rudi Hartono',
      'kepala_keluarga': 'Rudi Hartono',
      'alamat': 'Jl. Cendana No. 21, Kelurahan Tlogomas, Malang',
      'status_kepemilikan': 'Penyewa',
      'status': 'Nonaktif',
    },
    {
      'no': '5',
      'nama_keluarga': 'Keluarga Siti Maesaroh',
      'kepala_keluarga': 'Siti Maesaroh',
      'alamat': 'Jl. Kenanga No. 5, Kelurahan Dinoyo, Malang',
      'status_kepemilikan': 'Pemilik',
      'status': 'Aktif',
    },
  ];

  void openFilterDialog() {}

  Widget _buildBadge(String text) {
    bool aktif = text.toLowerCase() == 'aktif';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: aktif ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: aktif ? Colors.green.shade800 : Colors.red.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris atas: nomor dan nama keluarga
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade100,
                  child: Text(
                    item['no'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item['nama_keluarga'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {},
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'detail', child: Text('Detail')),
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),
            // Informasi utama
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kepala: ${item['kepala_keluarga'] ?? '-'}",
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  "Kepemilikan: ${item['status_kepemilikan'] ?? '-'}",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 6),
            Text(
              "Alamat: ${item['alamat'] ?? '-'}",
              style: const TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: _buildBadge(item['status'] ?? 'Aktif'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          "Data Keluarga",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Tombol aksi atas (Filter di sebelah kiri)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // kiri
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
                  onPressed: openFilterDialog,
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  label: const Text(
                    'Filter',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Daftar keluarga
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: dataKeluarga.length,
              itemBuilder: (context, index) => _buildCard(dataKeluarga[index]),
            ),
          ),
        ],
      ),
    );
  }
}
