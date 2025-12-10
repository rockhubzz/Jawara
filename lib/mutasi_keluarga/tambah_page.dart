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
    'Pindah Masuk',
    'Pindah Domisili',
    'Perubahan Status',
    'Kematian',
    'Lainnya',
  ];

  bool loading = false;
  bool initialLoading = false;

  // Optional: fetch keluarga list from API later — for demo we keep it simple
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
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mutasi berhasil ditambahkan'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/mutasi'); // go back to daftar
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
              backgroundColor: Colors.green,
            ),
          );
          context.go('/mutasi');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? 'Gagal update')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
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

        title: Text(widget.id == null ? 'Buat Mutasi Keluarga' : 'Edit Mutasi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: initialLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jenis Mutasi',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: selectedJenis,
                            hint: const Text('-- Pilih Jenis Mutasi --'),
                            items: jenisList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => selectedJenis = v),
                            validator: (v) =>
                                v == null ? 'Pilih jenis mutasi' : null,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Keluarga',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            value: selectedKeluargaId,
                            hint: const Text('-- Pilih Keluarga --'),
                            items: keluargaList
                                .map(
                                  (k) => DropdownMenuItem(
                                    value: k['id'] as int,
                                    child: Text(k['nama_keluarga'] ?? '-'),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => selectedKeluargaId = v),
                            validator: (v) =>
                                v == null ? 'Pilih keluarga' : null,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Alasan Mutasi',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: alasanCtrl,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Masukkan alasan',
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tanggal Mutasi',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _pickDate,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
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
                                onPressed: () =>
                                    setState(() => selectedDate = null),
                                icon: const Icon(Icons.clear),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: _reset,
                                child: const Text('Reset'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: loading ? null : _save,
                                child: loading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        widget.id == null ? 'Simpan' : 'Update',
                                      ),
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
}
