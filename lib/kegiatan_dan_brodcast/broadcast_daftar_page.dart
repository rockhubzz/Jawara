import 'package:flutter/material.dart';

class BroadcastDaftarPage extends StatelessWidget {
  const BroadcastDaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // halaman putih
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row Back Button + Judul
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 8),
                Text(
                  "Daftar Broadcast",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Card pembungkus seluruh konten
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, // card pembungkus putih
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Tombol Tambah & Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFBC6C25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.add, color: Colors.white),
                        label: Text("Tambah",
                            style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDCA15D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.filter_list, color: Colors.white),
                        label: Text("Filter",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // List broadcast tanpa scroll internal
                  Column(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _broadcastCard(index + 1),
                      ),
                    ),
                  ),

                  // Pagination di dalam card
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chevron_left, color: Color(0xFFBC6C25)),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFBC6C25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "1",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Color(0xFFBC6C25)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CARD BROADCAST 
  Widget _broadcastCard(int number) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF4D9B2), // cream background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFBC6C25),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Angka bulat 
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFBC6C25),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16),

          // Isi teks + tombol edit & delete
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Judul Broadcast",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text("Kategori : Informasi"),
                Text("Penanggung Jawab : Admin"),
                Text("Tanggal : 18-11-2025"),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.edit, color: Colors.orange),
                    SizedBox(width: 20),
                    Icon(Icons.delete, color: Colors.red),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
