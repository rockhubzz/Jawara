import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class DaftarPenggunaPage extends StatelessWidget {
  const DaftarPenggunaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {
        'no': 1,
        'nama': 'mimin',
        'email': 'mimin@gmail.com',
        'status': 'Diterima',
      },
      {
        'no': 2,
        'nama': 'Farhan',
        'email': 'farhan@gmail.com',
        'status': 'Diterima',
      },
      {
        'no': 3,
        'nama': 'dewqedwddw',
        'email': 'admiwewen1@gmail.com',
        'status': 'Diterima',
      },
      {
        'no': 4,
        'nama': 'Rendha Putra Rahmadya',
        'email': 'rendhazuper@gmail.com',
        'status': 'Diterima',
      },
      {'no': 5, 'nama': 'bla', 'email': 'y@gmail.com', 'status': 'Diterima'},
      {
        'no': 6,
        'nama': 'Anti Micin',
        'email': 'antimicin3@gmail.com',
        'status': 'Diterima',
      },
      {
        'no': 7,
        'nama': 'ijat4',
        'email': 'ijat4@gmail.com',
        'status': 'Diterima',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Daftar Pengguna',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Column(
            children: [
              // === Filter Button ===
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  label: const Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // === Card List ===
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // === Number Circle ===
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFFE0E7FF),
                              child: Text(
                                user['no'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4338CA),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // === User Info ===
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['nama'].toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user['email'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // === Status Badge ===
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD1FAE5),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      user['status'].toString(),
                                      style: const TextStyle(
                                        color: Color(0xFF047857),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // === Action Button ===
                            IconButton(
                              icon: const Icon(
                                Icons.more_horiz,
                                color: Colors.black54,
                              ),
                              onPressed: () {},
                              tooltip: 'Lihat Detail',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
