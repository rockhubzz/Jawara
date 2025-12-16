import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/services/keluarga_service.dart';
import '../../services/mutasi_service.dart';

class BuatMutasiKeluargaPage extends StatefulWidget {
  final int? id;
  const BuatMutasiKeluargaPage({super.key, this.id});

  @override
  State<BuatMutasiKeluargaPage> createState() => _BuatMutasiKeluargaPageState();
}

class _BuatMutasiKeluargaPageState extends State<BuatMutasiKeluargaPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedJenis;
  int? selectedKeluargaId;
  DateTime? selectedDate;
  final alasanCtrl = TextEditingController();

  final jenisList = [
    'Pindah Keluar',
    'Pindah Domisili',
    'Perubahan Status',
    'Lainnya',
  ];

  bool loading = false;
  bool initialLoading = false;

  List<Map<String, dynamic>> keluargaList = [];

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _loadForEdit(widget.id!);
    }
    _loadKeluargaSimple();
  }

  Future<void> _loadKeluargaSimple() async {
    keluargaList = await KeluargaService.getKeluarga();
    setState(() {});
  }

  Future<void> _loadForEdit(int id) async {
    setState(() => initialLoading = true);
    try {
      final res = await MutasiService.getById(id);
      if (res['success'] == true) {
        final d = res['data'] as Map<String, dynamic>;
        setState(() {
          selectedJenis = d['jenis_mutasi'];
          selectedKeluargaId = d['keluarga_id'];
          alasanCtrl.text = d['alasan'] ?? '';
          if (d['tanggal'] != null) selectedDate = DateTime.parse(d['tanggal']);
        });
      }
    } finally {
      setState(() => initialLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih tanggal mutasi')));
      return;
    }

    setState(() => loading = true);

    final body = {
      'keluarga_id': selectedKeluargaId,
      'jenis_mutasi': selectedJenis,
      'tanggal': "${selectedDate!.toIso8601String().split('T').first}",
      'alasan': alasanCtrl.text,
    };

    try {
      if (widget.id == null) {
        final res = await MutasiService.create(body);
        if (res['success'] == true) {
            await KeluargaService.deleteKeluarga(selectedKeluargaId!);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mutasi berhasil ditambahkan'),
              backgroundColor: Color(0xFF2E7D32),
            ),
          );
          context.go('/mutasi_keluarga/daftar'); // go back to daftar
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? 'Gagal menambah')),
          );
        }
      } else {
        final res = await MutasiService.update(widget.id!, body);
        if (res['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mutasi berhasil diupdate'),
              backgroundColor: Color(0xFF2E7D32),
            ),
          );
          context.go('/mutasi_keluarga/daftar');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? 'Gagal update')),
          );
        }
      }
    } finally {
      setState(() => loading = false);
    }
  }

  void _reset() {
    setState(() {
      selectedJenis = null;
      selectedKeluargaId = null;
      selectedDate = null;
      alasanCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'tambah';
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (from == 'tambah') {
              context.go('/beranda/tambah');
            } else {
              context.go('/beranda/semua_menu');
            }
          },
        ),
        title: Text(
          widget.id == null ? 'Buat Mutasi Keluarga' : 'Edit Mutasi',
          style: const TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),

      body: initialLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.white, Color(0xFFF3FFF4)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: _buildForm(),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildForm() {
    const green = Color(0xFF2E7D32);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("Jenis Mutasi"),
          DropdownButtonFormField<String>(
            value: selectedJenis,
            decoration: _inputDecoration(),
            items: jenisList
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => selectedJenis = v),
            validator: (v) => v == null ? 'Pilih jenis mutasi' : null,
          ),
          const SizedBox(height: 16),

          _title("Keluarga"),
          DropdownButtonFormField<int>(
            value: selectedKeluargaId,
            decoration: _inputDecoration(),
            items: keluargaList
                .map(
                  (k) => DropdownMenuItem(
                    value: k['id'] as int,
                    child: Text(k['nama_keluarga'] ?? '-'),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => selectedKeluargaId = v),
            validator: (v) => v == null ? 'Pilih keluarga' : null,
          ),
          const SizedBox(height: 16),

          _title("Alasan Mutasi"),
          TextFormField(
            controller: alasanCtrl,
            maxLines: 3,
            decoration: _inputDecoration(hint: "Masukkan alasan"),
          ),
          const SizedBox(height: 16),

          _title("Tanggal Mutasi"),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: _inputDecoration(),
                    child: Text(
                      selectedDate == null
                          ? '--/--/----'
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => setState(() => selectedDate = null),
                icon: const Icon(Icons.clear, color: Colors.redAccent),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: _reset,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: green),
                  foregroundColor: green,
                ),
                child: const Text('Reset'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.id == null ? 'Simpan' : 'Update'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF9FFF9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF2E7D32)),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
