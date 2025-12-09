import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/kegiatan_service.dart';

class KegiatanTambahPage extends StatefulWidget {
  final int? id; // null = tambah, int = edit

  const KegiatanTambahPage({super.key, this.id});

  @override
  State<KegiatanTambahPage> createState() => _KegiatanTambahPageState();
}

class _KegiatanTambahPageState extends State<KegiatanTambahPage> {
  final _formKey = GlobalKey<FormState>();
  final namaC = TextEditingController();
  final kategoriC = TextEditingController();
  final tanggalC = TextEditingController();
  final lokasiC = TextEditingController();
  final pjC = TextEditingController();
  bool loading = false;

  late final bool isEdit = widget.id != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) _loadDetail(widget.id!);
  }

  Future<void> _loadDetail(int id) async {
    setState(() => loading = true);
    final data = await KegiatanService.getById(id);
    setState(() {
      namaC.text = data['nama'] ?? '';
      kategoriC.text = data['kategori'] ?? '';
      tanggalC.text = data['tanggal'] ?? '';
      lokasiC.text = data['lokasi'] ?? '';
      pjC.text = data['penanggung_jawab'] ?? '';
      loading = false;
    });
  }

  Future<void> _pickDate() async {
    DateTime initial = tanggalC.text.isNotEmpty
        ? DateTime.tryParse(tanggalC.text) ?? DateTime.now()
        : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      tanggalC.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final payload = {
      "nama": namaC.text,
      "kategori": kategoriC.text,
      "tanggal": tanggalC.text,
      "lokasi": lokasiC.text,
      "penanggung_jawab": pjC.text,
    };

    Map<String, dynamic> res;
    if (isEdit) {
      res = await KegiatanService.update(widget.id!, payload);
    } else {
      res = await KegiatanService.tambahKegiatan(payload);
    }

    setState(() => loading = false);

    if (res['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Kegiatan berhasil diperbarui'
                  : 'Kegiatan berhasil disimpan',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/kegiatan/daftar');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Gagal menyimpan data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 235, 188), // krem
              Color.fromARGB(255, 181, 255, 183), // hijau
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => context.go('/kegiatan/daftar'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEdit ? "Edit Kegiatan" : "Tambah Kegiatan",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Card utama
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 255, 204),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: loading && isEdit
                      ? const Center(child: CircularProgressIndicator())
                      : Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InputField(
                                controller: namaC,
                                label: "Nama Kegiatan",
                                hint: "Masukkan nama kegiatan...",
                                icon: Icons.event_note_outlined,
                              ),
                              const SizedBox(height: 14),
                              _InputField(
                                controller: kategoriC,
                                label: "Kategori",
                                hint: "Masukkan kategori kegiatan...",
                                icon: Icons.category_outlined,
                              ),
                              const SizedBox(height: 14),
                              _InputField(
                                controller: tanggalC,
                                label: "Tanggal",
                                hint: "Pilih tanggal",
                                icon: Icons.date_range_outlined,
                                readOnly: true,
                                onTap: _pickDate,
                              ),
                              const SizedBox(height: 14),
                              _InputField(
                                controller: lokasiC,
                                label: "Lokasi",
                                hint: "Masukkan lokasi kegiatan",
                                icon: Icons.location_on_outlined,
                              ),
                              const SizedBox(height: 14),
                              _InputField(
                                controller: pjC,
                                label: "Penanggung Jawab",
                                hint: "Masukkan penanggung jawab",
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 22),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFBC6C25),
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: loading ? null : save,
                                    child: Text(
                                      loading
                                          ? (isEdit ? "Memperbarui..." : "Menyimpan...")
                                          : (isEdit ? "Update" : "Simpan"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable Input Field
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool readOnly;
  final VoidCallback? onTap;

  const _InputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      cursorColor: const Color(0xFFBC6C25),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFBC6C25)),
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBC6C25), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBC6C25), width: 2.2),
        ),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
    );
  }
}
