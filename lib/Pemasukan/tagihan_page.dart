import 'package:flutter/material.dart';
import 'package:jawara/widgets/appDrawer.dart';

class TagihanPage extends StatefulWidget {
  const TagihanPage({super.key});

  @override
  State<TagihanPage> createState() => _TagihanPageState();
}

class _TagihanPageState extends State<TagihanPage> {
  final List<Map<String, String>> dataIuran = [
    {
      "no": "1",
      "nama_keluarga": "Keluarga Habibie Ed Dien",
      "status_keluarga": "Aktif",
      "iuran": "Mingguan",
      "kode_tagihan": "IR175458A501",
      "nominal": "Rp 10,00",
      "periode": "8 Oktober 2025",
      "status_bayar": "Belum Dibayar",
    },
    {
      "no": "2",
      "nama_keluarga": "Keluarga Mara Nunez",
      "status_keluarga": "Aktif",
      "iuran": "Agustusan",
      "kode_tagihan": "IR224406BC02",
      "nominal": "Rp 15,00",
      "periode": "10 Oktober 2025",
      "status_bayar": "Belum Dibayar",
    },
    {
      "no": "3",
      "nama_keluarga": "Keluarga Habibie Ed Dien",
      "status_keluarga": "Aktif",
      "iuran": "Mingguan",
      "kode_tagihan": "IR185702KX01",
      "nominal": "Rp 10,00",
      "periode": "15 Oktober 2025",
      "status_bayar": "Belum Dibayar",
    },
  ];

  void openFilterDialog() {
    // Aksi untuk membuka dialog filter
  }

  Widget _buildBadge(String text, {Color? bg, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg ?? Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.green.shade800,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _smallInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }

  Widget _buildCard(Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris atas: no, nama keluarga, status, aksi
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade100,
                  child: Text(
                    item['no'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),

                // Nama dan info kecil
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nama_keluarga'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _smallInfoChip("Iuran: ${item['iuran'] ?? '-'}"),
                          _smallInfoChip("Kode: ${item['kode_tagihan'] ?? '-'}"),
                          _smallInfoChip("Nominal: ${item['nominal'] ?? '-'}"),
                        ],
                      ),
                    ],
                  ),
                ),

                _buildBadge(
                  item['status_keluarga'] ?? '',
                  bg: Colors.green.shade50,
                  textColor: Colors.green.shade800,
                ),

                const SizedBox(width: 8),

                PopupMenuButton<String>(
                  onSelected: (v) {
                    // handle actions (Detail, Edit, Hapus, dll)
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'detail', child: Text('Detail')),
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Baris bawah: tanggal & status bayar
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  item['periode'] ?? '',
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const Spacer(),
                if ((item['status_bayar'] ?? '')
                    .toLowerCase()
                    .contains('belum'))
                  _buildBadge(
                    item['status_bayar'] ?? '',
                    bg: Colors.yellow.shade100,
                    textColor: Colors.brown.shade700,
                  )
                else
                  _buildBadge(
                    item['status_bayar'] ?? '',
                    bg: Colors.green.shade50,
                    textColor: Colors.green.shade800,
                  ),
              ],
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
        title: const Text("Tagihan", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: AppDrawer(email: 'admin1@mail.com'),
      body: Column(
        children: [
          // Tombol aksi kanan atas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
                const SizedBox(width: 12),
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
                  onPressed: () {
                    // cetak pdf
                  },
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: const Text(
                    'Cetak PDF',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Daftar tagihan
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: dataIuran.length,
              itemBuilder: (context, index) =>
                  _buildCard(dataIuran[index]),
            ),
          ),
        ],
      ),
    );
  }
}