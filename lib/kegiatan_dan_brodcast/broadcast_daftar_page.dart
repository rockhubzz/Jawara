import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';
import 'package:go_router/go_router.dart';
import '../services/broadcast_service.dart'; // adjust import

class BroadcastDaftarPage extends StatefulWidget {
  const BroadcastDaftarPage({super.key});

  @override
  State<BroadcastDaftarPage> createState() => _BroadcastDaftarPageState();
}

class _BroadcastDaftarPageState extends State<BroadcastDaftarPage> {
  List<Map<String, dynamic>> _data = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res =
          await BroadcastService.getAll(); // returns { success: true, data: [...] }
      final List data = res['data'] as List;
      _data = data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirmDelete(Map<String, dynamic> item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus "${item['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (ok == true) {
      // call service
      final success = await BroadcastService.delete(item['id'] as int);
      if (!mounted) return;
      if (success) {
        setState(() => _data.removeWhere((d) => d['id'] == item['id']));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kegiatan berhasil dihapus"),
            backgroundColor: Colors.green,
          ),
        );
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

  void _openEdit(Map item) {
    final id = item['id'].toString();
    context.push('/broadcast/form/$id');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    final dataToShow = _data.map((item) {
      return {
        "no": item['id'] ?? 0,
        "pengirim": item['sender'] ?? '—',
        "judul": item['title'] ?? '—',
        "tanggal": item['date'] ?? '',
        "raw": item,
      };
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Daftar Broadcast",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/beranda/semua_menu'),
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
                      "Daftar Broadcast",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _loadData,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text("Refresh"),
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

                if (_loading)
                  const Center(child: CircularProgressIndicator())
                else if (_error != null)
                  Center(child: Text("Gagal memuat: $_error"))
                else if (!isMobile)
                  _buildTableView(dataToShow)
                else
                  _buildMobileCardView(dataToShow),
              ],
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
          border: TableBorder.all(color: const Color(0xFFE0E0E0), width: 1),
          columnWidths: const {
            0: FlexColumnWidth(0.6),
            1: FlexColumnWidth(1.4),
            2: FlexColumnWidth(2.5),
            3: FlexColumnWidth(1.4),
            4: FlexColumnWidth(1.2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Color(0xFFF3F0FF)),
              children: [
                _HeaderCell("NO"),
                _HeaderCell("PENGIRIM"),
                _HeaderCell("JUDUL"),
                _HeaderCell("TANGGAL"),
                _HeaderCell("AKSI"),
              ],
            ),
            ...data.map(
              (item) => _dataRowTable(
                item['no'] as int,
                item['pengirim'] as String,
                item['judul'] as String,
                item['tanggal'] as String,
                raw: item['raw'] as Map<String, dynamic>,
                onEdit: _openEdit,
                onDelete: _confirmDelete,
              ),
            ),
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
                      "${item["judul"]}",
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
                        Text("${item["pengirim"]}"),
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
                          onPressed: () => _openEdit(item['raw']),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                          tooltip: 'Hapus',
                          onPressed: () => _confirmDelete(item['raw']),
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

// Reusable Table Cell Widgets (same as your previous)
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

// Data row builder with callbacks
TableRow _dataRowTable(
  int no,
  String pengirim,
  String judul,
  String tanggal, {
  required Map<String, dynamic> raw,
  required Function(Map<String, dynamic>) onEdit,
  required Function(Map<String, dynamic>) onDelete,
}) {
  return TableRow(
    children: [
      _DataCell(Text(no.toString())),
      _DataCell(Text(pengirim)),
      _DataCell(Text(judul)),
      _DataCell(Text(tanggal)),
      _DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.amber, size: 18),
              tooltip: 'Edit',
              onPressed: () => onEdit(raw),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
              tooltip: 'Hapus',
              onPressed: () => onDelete(raw),
            ),
          ],
        ),
      ),
    ],
  );
}
