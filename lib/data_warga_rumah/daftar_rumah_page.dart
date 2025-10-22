import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/widgets/appDrawer.dart';

class DaftarRumahPage extends StatefulWidget {
  const DaftarRumahPage({super.key});

  @override
  State<DaftarRumahPage> createState() => _DaftarRumahPageState();
}

class _DaftarRumahPageState extends State<DaftarRumahPage> {
  final List<Map<String, String>> rumahList = [
    {"no": "1", "alamat": "Jl. Melati No. 12, Malang", "status": "Tersedia"},
    {
      "no": "2",
      "alamat": "Jl. Sukarno Hatta No. 45, Malang",
      "status": "Ditempati",
    },
    {"no": "3", "alamat": "Jl. Ijen No. 8, Malang", "status": "Ditempati"},
    {
      "no": "4",
      "alamat": "Komplek Graha Cempaka Lantai 2, Malang",
      "status": "Nonaktif",
    },
    {"no": "5", "alamat": "Jl. Merbabu No. 23, Malang", "status": "Tersedia"},
    {"no": "6", "alamat": "Jl. Kawi No. 17, Malang", "status": "Ditempati"},
    {"no": "7", "alamat": "Griya Shanta L203, Malang", "status": "Ditempati"},
    {"no": "8", "alamat": "Jl. Tidar No. 5, Malang", "status": "Tersedia"},
    {
      "no": "9",
      "alamat": "Jl. Baru Bangun No. 10, Malang",
      "status": "Nonaktif",
    },
    {"no": "10", "alamat": "Jl. Veteran No. 2, Malang", "status": "Tersedia"},
  ];

  List<Map<String, String>> filteredList = [];
  int currentPage = 1;

  // Filter values
  String filterAlamat = '';
  String filterStatus = '';

  @override
  void initState() {
    super.initState();
    filteredList = List.from(rumahList);
  }

  void openFilterDialog() {
    String tempAlamat = filterAlamat;
    String tempStatus = filterStatus;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Filter Rumah",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 300, // agar dialog tidak terlalu sempit
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Field Alamat
              TextField(
                decoration: const InputDecoration(
                  labelText: "Alamat",
                  hintText: "Cari nama...",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onChanged: (value) {
                  tempAlamat = value;
                },
                controller: TextEditingController(text: tempAlamat),
              ),
              const SizedBox(height: 16),
              // Dropdown Status
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                value: tempStatus.isEmpty ? null : tempStatus,
                items: const [
                  DropdownMenuItem(value: "Tersedia", child: Text("Tersedia")),
                  DropdownMenuItem(
                    value: "Ditempati",
                    child: Text("Ditempati"),
                  ),
                  DropdownMenuItem(value: "Nonaktif", child: Text("Nonaktif")),
                ],
                onChanged: (value) {
                  tempStatus = value ?? '';
                },
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        filterAlamat = '';
                        filterStatus = '';
                        filteredList = List.from(rumahList);
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Reset Filter"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filterAlamat = tempAlamat;
                        filterStatus = tempStatus;

                        filteredList = rumahList.where((rumah) {
                          final matchesAlamat = rumah['alamat']!
                              .toLowerCase()
                              .contains(filterAlamat.toLowerCase());
                          final matchesStatus = filterStatus.isEmpty
                              ? true
                              : rumah['status'] == filterStatus;
                          return matchesAlamat && matchesStatus;
                        }).toList();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Terapkan"),
                  ),
                ),
              ],
            ),
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
          "Daftar Rumah",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: AppDrawer(email: 'admin1@mail.com'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tombol Filter
                Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton.icon(
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
                ),
                const SizedBox(height: 24),

                // Tabel Header
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F2F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'NO',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'ALAMAT',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'STATUS',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'AKSI',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // Isi Data
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    children: filteredList.map((data) {
                      bool tersedia = data['status'] == 'Tersedia';
                      Color backgroundColor;
                      Color textColor;

                      switch (data['status']) {
                        case 'Tersedia':
                          backgroundColor = const Color(
                            0xFFDFF6E0,
                          ); // hijau muda
                          textColor = const Color(0xFF3AA76D); // hijau gelap
                          break;
                        case 'Ditempati':
                          backgroundColor = const Color(
                            0xFFE3E8F9,
                          ); // biru muda
                          textColor = const Color(0xFF3E64FF); // biru gelap
                          break;
                        case 'Nonaktif':
                          backgroundColor = const Color(
                            0xFFF5E5E5,
                          ); // abu-abu muda
                          textColor = const Color(0xFF9E9E9E); // abu-abu gelap
                          break;
                        default:
                          backgroundColor = Colors.grey;
                          textColor = Colors.black;
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Text(data['no']!)),
                            Expanded(flex: 3, child: Text(data['alamat']!)),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: tersedia
                                      ? const Color(0xFFDFF6E0)
                                      : const Color(0xFFE3E8F9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  data['status']!,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.more_horiz,
                                  color: Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // Pagination
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: currentPage > 1
                          ? () {
                              setState(() {
                                currentPage--;
                              });
                            }
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$currentPage',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          currentPage++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
