import 'package:flutter/material.dart';
import 'package:jawara/services/keluarga_service.dart';

class KeluargaDetailPage extends StatefulWidget {
  final int id;

  const KeluargaDetailPage({super.key, required this.id});

  @override
  State<KeluargaDetailPage> createState() => _KeluargaDetailPageState();
}

class _KeluargaDetailPageState extends State<KeluargaDetailPage> {
  Map<String, dynamic> data = {};
  List<dynamic> anggota = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    final res = await KeluargaService.getKeluargaById(widget.id);

    setState(() {
      data = res?['data'];
      anggota = res?['anggota'];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Keluarga")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================== DATA KELUARGA ====================
                  const Text(
                    "Informasi Keluarga",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Text("Nama Keluarga: ${data['nama_keluarga'] ?? '-'}"),
                  Text("Kepala Keluarga: ${data['kepala_keluarga'] ?? '-'}"),
                  Text("Alamat: ${data['alamat'] ?? '-'}"),
                  Text("Kepemilikan: ${data['kepemilikan'] ?? '-'}"),
                  Text("Status: ${data['status'] ?? '-'}"),

                  const SizedBox(height: 24),

                  // ==================== ANGGOTA KELUARGA ====================
                  const Text(
                    "Anggota Keluarga",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  anggota.isEmpty
                      ? const Text(
                          "Belum ada anggota keluarga.",
                          style: TextStyle(color: Colors.grey),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: anggota.length,
                          itemBuilder: (context, index) {
                            final item = anggota[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["nama"] ?? "-",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("NIK: ${item['nik'] ?? '-'}"),
                                  Text(
                                    "Jenis Kelamin: ${item['jenis_kelamin'] ?? '-'}",
                                  ),
                                  Text(
                                    "Status Domisili: ${item['status_domisili'] ?? '-'}",
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
