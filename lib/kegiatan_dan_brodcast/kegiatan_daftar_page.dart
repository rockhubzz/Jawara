import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/widgets/appDrawer.dart';
import 'package:jawara/services/kegiatan_service.dart';

class KegiatanDaftarPage extends StatefulWidget {
  const KegiatanDaftarPage({super.key});

  @override
  State<KegiatanDaftarPage> createState() => _KegiatanDaftarPageState();
}

class _KegiatanDaftarPageState extends State<KegiatanDaftarPage> {
  List<Map<String, dynamic>> data = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      final items = await KegiatanService.getAll();
      // ensure each item has string fields used by UI
      setState(() {
        data = items.asMap().entries.map((e) {
          final idx = e.key;
          final row = e.value;
          return {
            'no': (idx + 1).toString(),
            'id': row['id'],
            'nama': row['nama'] ?? '',
            'kategori': row['kategori'] ?? '',
            'pj': row['penanggung_jawab'] ?? '',
            'tanggal': row['tanggal'] ?? '',
          };
        }).toList();
      });
    } catch (err) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $err')));
    } finally {
      setState(() => loading = false);
    }
  }

  Widget _buildTableView() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 700),
        child: Table(
          border: TableBorder.symmetric(
            inside: const BorderSide(color: Colors.black12),
            outside: BorderSide.none,
          ),
          columnWidths: const {
            0: FixedColumnWidth(50),
            1: FlexColumnWidth(2.5),
            2: FlexColumnWidth(1.5),
            3: FlexColumnWidth(2.2),
            4: FlexColumnWidth(1.5),
            5: FlexColumnWidth(1.2),
          },
          children: [
            _buildHeaderRow(),
            ...data.map(
              (d) => _buildDataRow(
                d['no'],
                d['nama'],
                d['kategori'],
                d['pj'],
                d['tanggal'],
                d['id'],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileCardView() {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: data
          .map(
            (item) => Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
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
                        const Icon(Icons.category_outlined, size: 16),
                        const SizedBox(width: 4),
                        Text("${item["kategori"]}"),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 16),
                        const SizedBox(width: 4),
                        Text("${item["pj"]}"),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.date_range_outlined, size: 16),
                        const SizedBox(width: 4),
                        Text("${item["tanggal"]}"),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.amber,
                            size: 20,
                          ),
                          tooltip: 'Edit',
                          onPressed: () =>
                              context.go('/kegiatan/tambah/${item['id']}'),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                          tooltip: 'Hapus',
                          onPressed: () => _confirmDelete(item),
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

  TableRow _buildDataRow(
    String no,
    String nama,
    String kategori,
    String pj,
    String tanggal,
    dynamic id,
  ) {
    return TableRow(
      children: [
        _DataCell(Text(no)),
        _DataCell(Text(nama)),
        _DataCell(Text(kategori)),
        _DataCell(Text(pj)),
        _DataCell(Text(tanggal)),
        _DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.amber, size: 18),
                tooltip: 'Edit',
                onPressed: () => _openEdit({
                  'id': id,
                  'nama': nama,
                  'kategori': kategori,
                  'pj': pj,
                  'tanggal': tanggal,
                }),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: 18,
                ),
                tooltip: 'Hapus',
                onPressed: () => _confirmDelete({'id': id, 'nama': nama}),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openEdit(Map<String, dynamic> item) {
    // open your edit page or dialog.
    // Example: context.go('/kegiatan/edit/${item['id']}');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Open edit (hook here)')));
  }

  void _confirmDelete(dynamic item) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Hapus Kegiatan"),
          content: Text("Yakin ingin menghapus kegiatan '${item['nama']}'?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(ctx),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Hapus"),
              onPressed: () async {
                Navigator.pop(ctx); // tutup dialog

                final parentContext =
                    context; // simpan context sebelum pop halaman

                final res = await KegiatanService.delete(item['id']);

                ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(
                    content: Text(
                      res == true
                          ? "Kegiatan berhasil dihapus"
                          : "Gagal menghapus kegiatan",
                    ),
                    backgroundColor: res == true ? Colors.green : Colors.red,
                  ),
                );

                // Panggil ulang list
                if (res == true) {
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'semua';
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (from == 'beranda') {
              context.go('/beranda');
            } else {
              context.go('/beranda/semua_menu');
            }
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Daftar Kegiatan",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
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
                // header + add button kept same
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
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        context.go('/kegiatan/tambah/new');
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        "Tambah Kegiatan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (!isMobile) _buildTableView() else _buildMobileCardView(),

                const SizedBox(height: 16),

                // pagination placeholder kept same
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {},
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
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
