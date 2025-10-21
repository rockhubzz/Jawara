import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class KegiatanDaftarPage extends StatelessWidget {
  const KegiatanDaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Daftar Kegiatan",
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
      drawer: AppDrawer(email: 'admin1@mail.com'),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: screenWidth, // ✅ lebar penuh
            constraints: const BoxConstraints(maxWidth: 1200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header judul & tombol tambah
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Daftar Kegiatan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.add, color: Colors.white, size: 18),
                      label: const Text(
                        "Tambah Kegiatan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 🔹 Tabel full width, tidak scroll horizontal
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Table(
                      border: TableBorder.symmetric(
                        inside: const BorderSide(color: Colors.black12),
                        outside: BorderSide.none,
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(50), // No
                        1: FlexColumnWidth(2.5), // Nama
                        2: FlexColumnWidth(1.5), // Kategori
                        3: FlexColumnWidth(2.2), // Penanggung jawab
                        4: FlexColumnWidth(1.5), // Tanggal
                        5: FlexColumnWidth(1.2), // Aksi
                      },
                      children: [
                        _buildHeaderRow(),
                        _buildDataRow(1, "Pelatihan Flutter", "Workshop",
                            "Budi Santoso", "2025-10-20"),
                        _buildDataRow(
                            2, "Rapat Dosen", "Rapat", "Dr. Rini", "2025-10-22"),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 6),

                // 🔹 Pagination
                Row(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Header tabel
  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFF2F2FF)),
      children: const [
        _HeaderCell("No"),
        _HeaderCell("Nama Kegiatan"),
        _HeaderCell("Kategori"),
        _HeaderCell("Penanggung Jawab"),
        _HeaderCell("Tanggal"),
        _HeaderCell("Aksi"),
      ],
    );
  }

  // 🔹 Baris data
  TableRow _buildDataRow(
      int no, String nama, String kategori, String pj, String tanggal) {
    return TableRow(
      children: [
        _DataCell(Text(no.toString())),
        _DataCell(Text(nama)),
        _DataCell(Text(kategori)),
        _DataCell(Text(pj)),
        _DataCell(Text(tanggal)),
        _DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.amber, size: 18),
                tooltip: 'Edit',
                onPressed: () {},
              ),
              IconButton(
                icon:
                    const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                tooltip: 'Hapus',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 🔸 Widget kecil untuk header & cell
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

class _DataCell extends StatelessWidget {
  final Widget child;
  const _DataCell(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: child,
    );
  }
}
