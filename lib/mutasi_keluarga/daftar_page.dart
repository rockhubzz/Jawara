import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';
import 'package:go_router/go_router.dart';
import '../services/mutasi_service.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = true;
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData({int page = 1}) async {
    setState(() => isLoading = true);
    try {
      final res = await MutasiService.getAll(page: page);
      setState(() {
        data = (res['data'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        currentPage = res['current_page'] ?? page;
        lastPage = res['last_page'] ?? page;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _confirmDelete(Map<String, dynamic> item) async {
    final id = item['id'];
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Hapus data mutasi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (ok == true) {
      final deleted = await MutasiService.delete(id as int);
      if (deleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Mutasi berhasil dihapus"),
            backgroundColor: Colors.green,
          ),
        );
        loadData(page: currentPage);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menghapus"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openEdit(Map<String, dynamic> item) {
    // navigate to the tambah page in edit mode, pass id in query param
    context.go('/mutasi/tambah?id=${item['id']}');
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
          "Mutasi Keluarga",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
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
                          onPressed: () => context.go('/mutasi/tambah'),
                          icon: const Icon(Icons.add),
                          label: const Text("Tambah"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (!isMobile)
                      _buildTableView(data)
                    else
                      _buildMobileCardView(data),
                    const SizedBox(height: 20),

                    // Pagination controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: currentPage > 1
                              ? () => loadData(page: currentPage - 1)
                              : null,
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
                          child: Text(
                            currentPage.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: currentPage < lastPage
                              ? () => loadData(page: currentPage + 1)
                              : null,
                        ),
                      ],
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

  Widget _buildTableView(List<dynamic> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 700),
        child: Table(
          border: TableBorder.all(color: const Color(0xFFE0E0E0), width: 1),
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
            ...List.generate(data.length, (i) {
              final item = data[i] as Map<String, dynamic>;
              final no = ((currentPage - 1) * 10) + i + 1;
              final tanggal = item['tanggal'] ?? '';
              final keluargaName = item['keluarga'] != null
                  ? (item['keluarga']['nama_keluarga'] ?? '-')
                  : '-';
              final jenis = item['jenis_mutasi'] ?? '-';
              return _dataRowTable(
                no,
                tanggal,
                keluargaName,
                jenis,
                onEdit: () => _openEdit(item),
                onDelete: () => _confirmDelete(item),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileCardView(List<dynamic> data) {
    return Column(
      children: data.map((raw) {
        final item = raw as Map<String, dynamic>;
        final jenis = item['jenis_mutasi'] ?? '-';
        final tanggal = item['tanggal'] ?? '-';
        final keluarga = item['keluarga'] != null
            ? (item['keluarga']['nama_keluarga'] ?? '-')
            : '-';
        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  keluarga,
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
                    Text(tanggal),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      jenis,
                      style: TextStyle(
                        color: jenis == "Pindah Masuk"
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
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.blue,
                        size: 20,
                      ),
                      tooltip: 'Lihat Detail',
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.amber,
                        size: 20,
                      ),
                      tooltip: 'Edit',
                      onPressed: () => _openEdit(item),
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
        );
      }).toList(),
    );
  }
}

// helper widgets reused (same as previously)
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

TableRow _dataRowTable(
  int no,
  String tanggal,
  String keluarga,
  String jenisMutasi, {
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
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
              icon: const Icon(Icons.edit, color: Colors.amber, size: 18),
              tooltip: 'Edit',
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
              tooltip: 'Hapus',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    ],
  );
}
