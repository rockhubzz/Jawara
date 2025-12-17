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

  final jenisCtrl = TextEditingController();
  final tanggalCtrl = TextEditingController();
  final alasanCtrl = TextEditingController();

  int? selectedKeluargaId;

  bool loading = false;
  bool initialLoading = false;
  late final bool isEdit = widget.id != null;

  final Color primaryGreen = const Color(0xFF2E7D32);

  List<Map<String, dynamic>> keluargaList = [];

  final jenisList = [
    'Pindah Keluar',
    'Pindah Domisili',
    'Perubahan Status',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _loadKeluarga();
    if (isEdit) _loadDetail(widget.id!);
  }

  Future<void> _loadKeluarga() async {
    final data = await KeluargaService.getKeluarga();
    if (!mounted) return;
    setState(() => keluargaList = data);
  }

  Future<void> _loadDetail(int id) async {
    setState(() => initialLoading = true);
    try {
      final res = await MutasiService.getById(id);
      if (res['success'] == true) {
        final d = res['data'];
        jenisCtrl.text = d['jenis_mutasi'] ?? '';
        selectedKeluargaId = d['keluarga_id'];
        tanggalCtrl.text = d['tanggal'] ?? '';
        alasanCtrl.text = d['alasan'] ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    } finally {
      if (mounted) setState(() => initialLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      tanggalCtrl.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedKeluargaId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih keluarga')));
      return;
    }

    setState(() => loading = true);

    final payload = {
      "keluarga_id": selectedKeluargaId,
      "jenis_mutasi": jenisCtrl.text,
      "tanggal": tanggalCtrl.text,
      "alasan": alasanCtrl.text,
    };

    try {
      final res = isEdit
          ? await MutasiService.update(widget.id!, payload)
          : await MutasiService.create(payload);

      if (res['success'] == true) {
        if (!isEdit) {
          await KeluargaService.deleteKeluarga(selectedKeluargaId!);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Mutasi berhasil diperbarui'
                  : 'Mutasi berhasil ditambahkan',
            ),
            backgroundColor: primaryGreen,
          ),
        );

        context.go('/mutasi_keluarga/daftar');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Gagal')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _reset() {
    jenisCtrl.clear();
    tanggalCtrl.clear();
    alasanCtrl.clear();
    setState(() => selectedKeluargaId = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Mutasi' : 'Buat Mutasi Keluarga'),
        backgroundColor: Colors.white,
        foregroundColor: primaryGreen,
        elevation: 0.5,
      ),
      body: initialLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: jenisCtrl.text.isEmpty ? null : jenisCtrl.text,
                      items: jenisList
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => jenisCtrl.text = v ?? ''),
                      decoration: const InputDecoration(
                        labelText: 'Jenis Mutasi',
                      ),
                      validator: (v) => v == null ? 'Wajib dipilih' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: selectedKeluargaId,
                      items: keluargaList.map((k) {
                        final int id = int.parse(k['id'].toString());
                        final String nama =
                            k['nama_keluarga']?.toString() ?? '-';

                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text(nama),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => selectedKeluargaId = v),
                      decoration: const InputDecoration(labelText: 'Keluarga'),
                      validator: (v) => v == null ? 'Wajib dipilih' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: tanggalCtrl,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: const InputDecoration(labelText: 'Tanggal'),
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: alasanCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Alasan'),
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: loading ? null : save,
                      child: Text(loading ? 'Menyimpan...' : 'Simpan'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}