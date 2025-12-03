import 'package:flutter/material.dart';

class KeluargaDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const KeluargaDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Keluarga")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Keluarga: ${data['nama_keluarga']}"),
            Text("Kepala Keluarga: ${data['kepala_keluarga']}"),
            Text("Alamat: ${data['alamat']}"),
            Text("Kepemilikan: ${data['kepemilikan']}"),
            Text("Status: ${data['status']}"),
          ],
        ),
      ),
    );
  }
}
