import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/widgets/appDrawer.dart';

class DaftarWargaPage extends StatefulWidget {
  const DaftarWargaPage({super.key});

  @override
  State<DaftarWargaPage> createState() => _DaftarWargaPageState();
}

class _DaftarWargaPageState extends State<DaftarWargaPage> {
  final List<Map<String, String>> wargaList = [
    {
      'no': '1',
      'nama': 'Rizkya Salsabila',
      'nik': '3578123409876543',
      'keluarga': 'Keluarga Salsabila',
      'jenis_kelamin': 'Perempuan',
      'status_domisili': 'Aktif',
      'status_hidup': 'Hidup',
    },
    {
      'no': '2',
      'nama': 'Muhammad Rifda Musyaffa’',
      'nik': '3578123401234567',
      'keluarga': 'Keluarga Musyaffa’',
      'jenis_kelamin': 'Laki-laki',
      'status_domisili': 'Aktif',
      'status_hidup': 'Hidup',
    },
    {
      'no': '3',
      'nama': 'Yan Daffa Putra Liandhie',
      'nik': '3578123412345678',
      'keluarga': 'Keluarga Liandhie',
      'jenis_kelamin': 'Laki-laki',
      'status_domisili': 'Tidak Aktif',
      'status_hidup': 'Hidup',
    },
    {
      'no': '4',
      'nama': 'Dwi Ahmad Khairy',
      'nik': '3578123423456789',
      'keluarga': 'Keluarga Khairy',
      'jenis_kelamin': 'Laki-laki',
      'status_domisili': 'Aktif',
      'status_hidup': 'Hidup',
    },
    {
      'no': '5',
      'nama': 'Abdullah Shamil Basayev',
      'nik': '3578123434567890',
      'keluarga': 'Keluarga Basayev',
      'jenis_kelamin': 'Laki-laki',
      'status_domisili': 'Tidak Aktif',
      'status_hidup': 'Wafat',
    },
  ];

  List<Map<String, String>> filteredList = [];
  String filterNama = '';
  String filterJenisKelamin = '';
  String filterStatusDomisili = '';
  String filterStatusHidup = '';

  @override
  void initState() {
    super.initState();
    filteredList = List.from(wargaList);
  }

  void openFilterDialog() {
    String tempNama = filterNama;
    String tempJK = filterJenisKelamin;
    String tempDomisili = filterStatusDomisili;
    String tempHidup = filterStatusHidup;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Filter Warga",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Nama",
                hintText: "Cari nama...",
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: tempNama),
              onChanged: (value) => tempNama = value,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Jenis Kelamin",
                border: OutlineInputBorder(),
              ),
              value: tempJK.isEmpty ? null : tempJK,
              items: const [
                DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
                DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
              ],
              onChanged: (value) => tempJK = value ?? '',
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Status Domisili",
                border: OutlineInputBorder(),
              ),
              value: tempDomisili.isEmpty ? null : tempDomisili,
              items: const [
                DropdownMenuItem(value: "Aktif", child: Text("Aktif")),
                DropdownMenuItem(
                  value: "Tidak Aktif",
                  child: Text("Tidak Aktif"),
                ),
              ],
              onChanged: (value) => tempDomisili = value ?? '',
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Status Hidup",
                border: OutlineInputBorder(),
              ),
              value: tempHidup.isEmpty ? null : tempHidup,
              items: const [
                DropdownMenuItem(value: "Hidup", child: Text("Hidup")),
                DropdownMenuItem(value: "Wafat", child: Text("Wafat")),
              ],
              onChanged: (value) => tempHidup = value ?? '',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                filterNama = '';
                filterJenisKelamin = '';
                filterStatusDomisili = '';
                filterStatusHidup = '';
                filteredList = List.from(wargaList);
              });
              Navigator.pop(context);
            },
            child: const Text("Reset"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                filterNama = tempNama;
                filterJenisKelamin = tempJK;
                filterStatusDomisili = tempDomisili;
                filterStatusHidup = tempHidup;

                filteredList = wargaList.where((w) {
                  final matchNama = w['nama']!.toLowerCase().contains(
                    filterNama.toLowerCase(),
                  );
                  final matchJK = filterJenisKelamin.isEmpty
                      ? true
                      : w['jenis_kelamin'] == filterJenisKelamin;
                  final matchDomisili = filterStatusDomisili.isEmpty
                      ? true
                      : w['status_domisili'] == filterStatusDomisili;
                  final matchHidup = filterStatusHidup.isEmpty
                      ? true
                      : w['status_hidup'] == filterStatusHidup;
                  return matchNama && matchJK && matchDomisili && matchHidup;
                }).toList();
              });
              Navigator.pop(context);
            },
            child: const Text("Terapkan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          "Daftar Warga",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: AppDrawer(email: 'admin1@mail.com'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: openFilterDialog,
                icon: const Icon(Icons.filter_list),
                label: const Text("Filter"),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: filteredList.map((w) {
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${w['no']}. ${w['nama']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text("NIK: ${w['nik']}"),
                        Text("Keluarga: ${w['keluarga']}"),
                        Text("JK: ${w['jenis_kelamin']}"),
                        const SizedBox(height: 10),

                        // Tambahan Badge Status
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: w['status_domisili'] == 'Aktif'
                                    ? Colors.green[100]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                w['status_domisili']!,
                                style: TextStyle(
                                  color: w['status_domisili'] == 'Aktif'
                                      ? Colors.green[800]
                                      : Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: w['status_hidup'] == 'Hidup'
                                    ? Colors.blue[100]
                                    : Colors.red[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                w['status_hidup']!,
                                style: TextStyle(
                                  color: w['status_hidup'] == 'Hidup'
                                      ? Colors.blue[800]
                                      : Colors.red[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Tombol Aksi (Detail, Edit, Hapus)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.info,
                                color: Color(0xFF6C63FF),
                              ),
                              tooltip: 'Detail',
                              onPressed: () {
                                // Navigasi ke halaman detail
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                              tooltip: 'Edit',
                              onPressed: () {
                                // context.go('/data_warga/edit/${w['no']}');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Hapus',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Konfirmasi Hapus"),
                                    content: Text(
                                      "Yakin ingin menghapus data ${w['nama']}?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text("Batal"),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            wargaList.removeWhere(
                                              (item) => item['no'] == w['no'],
                                            );
                                            filteredList.removeWhere(
                                              (item) => item['no'] == w['no'],
                                            );
                                          });
                                          Navigator.pop(ctx);
                                        },
                                        child: const Text("Hapus"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
