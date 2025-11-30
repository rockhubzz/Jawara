import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class PenerimaanWargaPage extends StatelessWidget {
  const PenerimaanWargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    final data = [
      {
        "no": 1,
        "nama": "Budi Santoso",
        "nik": "3509123400010001",
        "email": "budi@mail.com",
        "jk": "Laki-laki",
        "foto": "foto_ktp1.jpg",
        "status": "Disetujui",
      },
      {
        "no": 2,
        "nama": "Siti Aminah",
        "nik": "3509123400010002",
        "email": "siti@mail.com",
        "jk": "Perempuan",
        "foto": "foto_ktp2.jpg",
        "status": "Menunggu",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Penerimaan Warga",
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
                          "Penerimaan Warga",
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
        constraints: const BoxConstraints(minWidth: 1000),
        child: Table(
          border: TableBorder.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
          columnWidths: const {
            0: FlexColumnWidth(0.4),
            1: FlexColumnWidth(1.4),
            2: FlexColumnWidth(1.2),
            3: FlexColumnWidth(1.6),
            4: FlexColumnWidth(1.2),
            5: FlexColumnWidth(1.6),
            6: FlexColumnWidth(1.2),
            7: FlexColumnWidth(1.0),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Color(0xFFF3F0FF)),
              children: [
                _HeaderCell("NO"),
                _HeaderCell("NAMA"),
                _HeaderCell("NIK"),
                _HeaderCell("EMAIL"),
                _HeaderCell("JENIS KELAMIN"),
                _HeaderCell("FOTO IDENTITAS"),
                _HeaderCell("STATUS REGISTRASI"),
                _HeaderCell("AKSI"),
              ],
            ),
            ...data.map((item) => _dataRowTable(
                  item["no"],
                  item["nama"],
                  item["nik"],
                  item["email"],
                  item["jk"],
                  item["foto"],
                  item["status"],
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
                      "${item["nama"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 16),
                        const SizedBox(width: 4),
                        Text("${item["nik"]}"),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, size: 16),
                        const SizedBox(width: 4),
                        Text("${item["email"]}"),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.male, size: 16),
                        const SizedBox(width: 4),
                        Text("${item["jk"]}"),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.image, size: 16),
                        const SizedBox(width: 4),
                        Text("${item["foto"]}"),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: item["status"] == "Disetujui"
                                ? Colors.green.withOpacity(0.15)
                                : item["status"] == "Menunggu"
                                    ? Colors.orange.withOpacity(0.15)
                                    : Colors.red.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item["status"],
                            style: TextStyle(
                              color: item["status"] == "Disetujui"
                                  ? Colors.green[700]
                                  : item["status"] == "Menunggu"
                                      ? Colors.orange[700]
                                      : Colors.red[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Colors.amber, size: 20),
                          tooltip: 'Edit',
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
TableRow _dataRowTable(int no, String nama, String nik, String email,
    String jk, String foto, String status) {
  return TableRow(
    children: [
      _DataCell(Text(no.toString())),
      _DataCell(Text(nama)),
      _DataCell(Text(nik)),
      _DataCell(Text(email)),
      _DataCell(Text(jk)),
      _DataCell(
        Row(
          children: [
            const Icon(Icons.image, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Text(foto),
          ],
        ),
      ),
      _DataCell(
        Text(
          status,
          style: TextStyle(
            color: status == "Disetujui"
                ? Colors.green
                : status == "Menunggu"
                    ? Colors.orange
                    : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      _DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
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
