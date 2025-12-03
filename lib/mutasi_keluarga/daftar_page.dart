import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class DaftarPage extends StatelessWidget {
  const DaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    final data = [
      {
        "no": 1,
        "tanggal": "17 Oktober 2025",
        "keluarga": "Keluarga Budi Santoso",
        "jenisMutasi": "Pindah Masuk",
      },
      {
        "no": 2,
        "tanggal": "14 Oktober 2025",
        "keluarga": "Keluarga Siti Aminah",
        "jenisMutasi": "Pindah Keluar",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Mutasi Keluarga",
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Daftar Mutasi Keluarga",
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

                    // Table atau Card
                    if (!isMobile)
                      _buildTableView(data)
                    else
                      _buildMobileCardView(data),

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

  Widget _buildTableView(List<Map<String, dynamic>> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 700),
        child: Table(
          border: TableBorder.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
          columnWidths: const {
            0: FlexColumnWidth(0.5),
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(2.0),
            3: FlexColumnWidth(1.6),
            4: FlexColumnWidth(1.0),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Color(0xFFF3F0FF)),
              children: [
                _HeaderCell("NO"),
                _HeaderCell("TANGGAL"),
                _HeaderCell("KELUARGA"),
                _HeaderCell("JENIS MUTASI"),
                _HeaderCell("AKSI"),
              ],
            ),
            ...data.map((item) => _dataRowTable(
                  item["no"],
                  item["tanggal"],
                  item["keluarga"],
                  item["jenisMutasi"],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileCardView(List<Map<String, dynamic>> data) {
    return Column(
      children: data
          .map(
            (item) => Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item["keluarga"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text("${item["tanggal"]}"),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${item["jenisMutasi"]}",
                          style: TextStyle(
                            color: item["jenisMutasi"] == "Pindah Masuk"
                                ? Colors.green
                                : Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.visibility, color: Colors.blue, size: 20),
                          tooltip: 'Lihat Detail',
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.redAccent, size: 20),
                          tooltip: 'Hapus',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

// Reusable Table Cell Widgets
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        overflow: TextOverflow.ellipsis,
        child: child,
      ),
    );
  }
}

// Data row builder
TableRow _dataRowTable(int no, String tanggal, String keluarga, String jenisMutasi) {
  return TableRow(
    children: [
      _DataCell(Text(no.toString())),
      _DataCell(Text(tanggal)),
      _DataCell(Text(keluarga)),
      _DataCell(
        Text(
          jenisMutasi,
          style: TextStyle(
            color: jenisMutasi == "Pindah Masuk"
                ? Colors.green
                : Colors.redAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      _DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blue, size: 18),
              tooltip: 'Lihat Detail',
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
