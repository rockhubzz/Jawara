import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class DaftarMetodePembayaranPage extends StatelessWidget {
  const DaftarMetodePembayaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> metodePembayaran = [
      {
        'no': 1,
        'nama': 'QRIS Resmi RT 08',
        'tipe': 'qris',
        'an': 'RW 08 Karangploso',
        'thumbnail':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTergSPbr_HF8MzOEwAk8MhgoB3JoMog0g1Kg&s',
      },
      {
        'no': 2,
        'nama': 'BCA',
        'tipe': 'bank',
        'an': 'jose',
        'thumbnail':
            'https://buatlogoonline.com/wp-content/uploads/2022/10/Logo-BCA-PNG.png',
      },
      {
        'no': 3,
        'nama': '234234',
        'tipe': 'ewallet',
        'an': '23234',
        'thumbnail': '',
      },
      {
        'no': 4,
        'nama': 'Transfer via BCA',
        'tipe': 'bank',
        'an': 'RT Jawara Karangploso',
        'thumbnail': '',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Daftar Metode Pembayaran',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: metodePembayaran.length,
          itemBuilder: (context, index) {
            final item = metodePembayaran[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === Nomor ===
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFE0E7FF),
                      child: Text(
                        item['no'].toString(),
                        style: const TextStyle(
                          color: Color(0xFF3730A3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // === Data utama (expand to avoid overflow) ===
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['nama'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _infoChip('Tipe', item['tipe']),
                              _infoChip('A/N', item['an']),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // === Thumbnail (responsive size) ===
                    if (item['thumbnail'] != null &&
                        item['thumbnail'].toString().isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item['thumbnail'],
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                      )
                    else
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '-',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),

                    // === Tombol Aksi ===
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz),
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 13, color: Colors.black87),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
