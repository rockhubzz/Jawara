import 'package:flutter/material.dart';

class WargaDetailPage extends StatelessWidget {
  final Map<String, dynamic> warga;

  const WargaDetailPage({super.key, required this.warga});

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text("$label")),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Warga",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row("NIK", warga['nik'] ?? ''),
                _row("Nama", warga['nama'] ?? ''),
                _row("Jenis Kelamin", warga['jenis_kelamin'] ?? ''),
                _row("Alamat", warga['keluarga']?['alamat'] ?? ''),
                _row("Keluarga", warga['keluarga']?['nama_keluarga'] ?? "-"),
                _row("Status", warga['status_domisili'] ?? ''),
                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("OK"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
