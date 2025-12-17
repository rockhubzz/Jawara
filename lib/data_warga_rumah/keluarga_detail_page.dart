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
      data = res?['data'] ?? {};
      anggota = res?['anggota'] ?? [];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Keluarga",
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 235, 188),
              Color.fromARGB(255, 181, 255, 183),
            ],
          ),
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==================== DATA KELUARGA ====================
                        Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Informasi Keluarga",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Nama Keluarga: ${data['nama_keluarga'] ?? '-'}",
                              ),
                              Text(
                                "Kepala Keluarga: ${data['kepala_keluarga'] ?? '-'}",
                              ),
                              Text("Alamat: ${data['alamat'] ?? '-'}"),
                              Text(
                                "Kode Rumah: ${data['rumah']?['kode'] ?? '-'}",
                              ),
                              Text(
                                "Kepemilikan: ${data['kepemilikan'] ?? '-'}",
                              ),
                              Text("Status: ${data['status'] ?? '-'}"),
                            ],
                          ),
                        ),

                        // ==================== ANGGOTA KELUARGA ====================
                        const Text(
                          "Anggota Keluarga",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        anggota.isEmpty
                            ? const Text(
                                "Belum ada anggota keluarga.",
                                style: TextStyle(color: Colors.grey),
                              )
                            : Column(
                                children: anggota.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// NOMOR BULAT
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: const Color(
                                            0xFFE8F5E9,
                                          ),
                                          child: Text(
                                            (index + 1).toString(),
                                            style: const TextStyle(
                                              color: primaryGreen,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        /// DATA ANGGOTA
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item["nama"] ?? "-",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "NIK: ${item['nik'] ?? '-'}",
                                              ),
                                              Text(
                                                "Jenis Kelamin: ${item['jenis_kelamin'] ?? '-'}",
                                              ),
                                              Text(
                                                "Status Domisili: ${item['status_domisili'] ?? '-'}",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
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
