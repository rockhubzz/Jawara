import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class InformasiAspirasiPage extends StatelessWidget {
  const InformasiAspirasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Informasi Aspirasi",
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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Container(
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header (judul + tombol filter)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Informasi Aspirasi",
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

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 800),
                        child: Table(
                          border: TableBorder.all(
                            color: const Color(0xFFE0E0E0),
                            width: 1,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(0.6),
                            1: FlexColumnWidth(1.4),
                            2: FlexColumnWidth(2.5),
                            3: FlexColumnWidth(1.4),
                            4: FlexColumnWidth(1.4),
                            5: FlexColumnWidth(1.2),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            // Header
                            const TableRow(
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F0FF),
                              ),
                              children: [
                                _HeaderCell("NO"),
                                _HeaderCell("PENGIRIM"),
                                _HeaderCell("JUDUL"),
                                _HeaderCell("STATUS"),
                                _HeaderCell("TANGGAL DIBUAT"),
                                _HeaderCell("AKSI"),
                              ],
                            ),

                            // Data rows
                            _dataRowTable(
                              1,
                              "Admin Jawara",
                              "Gotong Royong di Kampus Polinema",
                              "Terkirim",
                              "17 Oktober 2025",
                            ),
                            _dataRowTable(
                              2,
                              "Admin Jawara",
                              "Kerja Bakti Bersama Masyarakat Sekitar",
                              "Dijadwalkan",
                              "14 Oktober 2025",
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Pagination
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
        ),
      ),
    );
  }
}

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

TableRow _dataRowTable(
  int no,
  String pengirim,
  String judul,
  String status,
  String tanggal,
) {
  return TableRow(
    children: [
      _DataCell(Text(no.toString())),
      _DataCell(Text(pengirim)),
      _DataCell(Text(judul)),
      _DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: status == "Terkirim"
                ? Colors.green.withOpacity(0.15)
                : Colors.orange.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: status == "Terkirim"
                  ? Colors.green[700]
                  : Colors.orange[700],
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
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
