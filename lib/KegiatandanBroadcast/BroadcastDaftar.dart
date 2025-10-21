import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class BroadcastDaftarPage extends StatelessWidget {
  const BroadcastDaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Daftar Broadcast",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(email: 'admin1@mail.com'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header (judul + tombol filter)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Daftar Broadcast",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list),
                      label: const Text("Filter"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔹 Tabel tanpa scroll horizontal
                Table(
                  border: TableBorder.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(0.6), // NO
                    1: FlexColumnWidth(1.4), // Pengirim
                    2: FlexColumnWidth(2.5), // Judul
                    3: FlexColumnWidth(1.4), // Tanggal
                    4: FlexColumnWidth(1.2), // Aksi
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    // 🔸 Header
                    TableRow(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F0FF),
                      ),
                      children: const [
                        _HeaderCell("NO"),
                        _HeaderCell("PENGIRIM"),
                        _HeaderCell("JUDUL"),
                        _HeaderCell("TANGGAL"),
                        _HeaderCell("AKSI"),
                      ],
                    ),

                    // 🔸 Data rows
                    _dataRowTable(1, "Admin Jawara",
                        "Gotong Royong di Kampus Polinema", "17 Oktober 2025"),
                    _dataRowTable(2, "Admin Jawara",
                        "Kerja Bakti Bersama Masyarakat Sekitar", "14 Oktober 2025"),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔹 Pagination
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {},
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C63FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "1",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {},
                      ),
                    ],
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

// 🔸 Widget Header Cell
class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

// 🔸 Table Row untuk data
TableRow _dataRowTable(int no, String pengirim, String judul, String tanggal) {
  return TableRow(
    children: [
      _DataCell(Text(no.toString())),
      _DataCell(Text(pengirim)),
      _DataCell(Text(judul)),
      _DataCell(Text(tanggal)),
      _DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.amber, size: 18),
              tooltip: 'Edit',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
              tooltip: 'Hapus',
              onPressed: () {},
            ),
          ],
        ),
      ),
    ],
  );
}

// 🔸 Widget Data Cell (biar rapi & padding rata)
class _DataCell extends StatelessWidget {
  final Widget child;
  const _DataCell(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        overflow: TextOverflow.ellipsis,
        child: child,
      ),
    );
  }
}
