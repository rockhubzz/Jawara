import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/services/keluarga_service.dart';
import '../../services/mutasi_service.dart';
import 'daftar_page.dart'; // pastikan import ini benar

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
    keluargaList = await KeluargaService.getKeluarga();
    if(!mounted) return;
    setState(() {});
  }

  Future<void> _loadDetail(int id) async {
    setState(() => initialLoading = true);
    try {
      final res = await MutasiService.getById(id);
      if (res['success'] == true) {
        final d = res['data'] as Map<String, dynamic>;
        setState(() {
          jenisCtrl.text = d['jenis_mutasi'] ?? '';
          selectedKeluargaId = d['keluarga_id'];
          tanggalCtrl.text = d['tanggal'] ?? '';
          alasanCtrl.text = d['alasan'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    } finally {
      setState(() => initialLoading = false);
    }
  }

  Future<void> _pickDate() async {
    DateTime initial = tanggalCtrl.text.isNotEmpty
        ? DateTime.tryParse(tanggalCtrl.text) ?? DateTime.now()
        : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pilih keluarga')));
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
    }
  }

  void _reset() {
    setState(() {
      jenisCtrl.clear();
      selectedKeluargaId = null;
      tanggalCtrl.clear();
      alasanCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: primaryGreen,
          onPressed: () => context.go('/mutasi_keluarga/daftar'),
        ),
        title: Text(
          isEdit ? 'Edit Mutasi' : 'Buat Mutasi Keluarga',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 235, 188),
              Color.fromARGB(255, 181, 255, 183),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: initialLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: _buildForm(),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Jenis Mutasi Dropdown
            DropdownButtonFormField<String>(
              value: jenisCtrl.text.isEmpty ? null : jenisCtrl.text,
              decoration: InputDecoration(
                labelText: 'Jenis Mutasi',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryGreen, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryGreen, width: 2.2),
                ),
              ),
              hint: const Text('-- Pilih Jenis Mutasi --'),
              items: jenisList
                  .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                  .toList(),
              onChanged: (v) => setState(() => jenisCtrl.text = v ?? ''),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Pilih jenis mutasi' : null,
            ),
            const SizedBox(height: 14),
            // Keluarga Dropdown   
            DropdownButtonFormField<int>(
              value: selectedKeluargaId,
              decoration: InputDecoration(
                labelText: 'Keluarga',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryGreen, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryGreen, width: 2.2),
                ),
              ),
              hint: const Text('-- Pilih Keluarga --'),
              items: keluargaList
                  .map((k) => DropdownMenuItem(
                        value: k['id'] as int,
                        child: Text(k['nama_keluarga'] ?? '-'),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => selectedKeluargaId = v),
              validator: (v) => v == null ? 'Pilih keluarga' : null,
            ),
            const SizedBox(height: 14),
            _InputField(
              controller: tanggalCtrl,
              label: 'Tanggal Mutasi',
              hint: 'Pilih tanggal',
              readOnly: true,
              onTap: _pickDate,
              icon: Icons.date_range_outlined,
            ),
            const SizedBox(height: 14),
            _InputField(
              controller: alasanCtrl,
              label: 'Alasan',
              hint: 'Masukkan alasan mutasi',
              maxLines: 3,
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _reset,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryGreen,
                    side: BorderSide(color: primaryGreen, width: 2),
                  ),
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: loading ? null : save,
                   style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white, 
                    ),
                    child: Text(
                      loading
                          ? (isEdit ? 'Memperbarui...' : 'Menyimpan...')
                          : (isEdit ? 'Update' : 'Simpan'),
                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;

  const _InputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.icon = Icons.edit,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryGreen),
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2.2),
        ),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
    );
  }
}
