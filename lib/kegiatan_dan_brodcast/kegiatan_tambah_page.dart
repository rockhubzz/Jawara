import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/services/kegiatan_service.dart';

// Halaman Tambah / Edit
class KegiatanTambahPage extends StatefulWidget {
  final int? id; // <--- Tambahkan parameter id

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
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      isEdit = true;
      _loadDetail();
    }
  }

  Future<void> _loadDetail() async {
    setState(() => loading = true);

    final d = await KegiatanService.getById(widget.id!);

    setState(() => loading = false);

    namaC.text = d['nama'] ?? "";
    kategoriC.text = d['kategori'] ?? "";
    tanggalC.text = d['tanggal'] ?? "";
    lokasiC.text = d['lokasi'] ?? "";
    pjC.text = d['penanggung_jawab'] ?? "";
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final payload = {
      "nama": namaC.text,
      "kategori": kategoriC.text,
      "tanggal": tanggalC.text,
      "lokasi": lokasiC.text,
      "penanggung_jawab": pjC.text,
    };

    late final response;

    if (isEdit) {
      response = await KegiatanService.update(widget.id!, payload);
    } else {
      response = await KegiatanService.tambahKegiatan(payload);
    }

    setState(() => loading = false);

    if (response['success'] != false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? "Kegiatan berhasil diperbarui!"
                : "Kegiatan berhasil disimpan!",
          ),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/kegiatan/daftar');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? "Terjadi kesalahan"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          isEdit ? "Edit Kegiatan" : "Tambah Kegiatan",
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/kegiatan/daftar'),
        ),
      ),

      body: loading && isEdit
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Container(
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
                    Text(
                      isEdit ? "Edit Kegiatan" : "Form Kegiatan Baru",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    const SizedBox(height: 20),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final isMobile = width < 700;

                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: isMobile
                                  ? double.infinity
                                  : (width / 2) - 16,
                              child: _InputField(
                                label: "Nama Kegiatan",
                                hint: "Masukkan nama kegiatan...",
                                icon: Icons.event_note_outlined,
                                controller: namaC,
                              ),
                            ),
                            SizedBox(
                              width: isMobile
                                  ? double.infinity
                                  : (width / 2) - 16,
                              child: _InputField(
                                label: "Kategori",
                                hint: "Masukkan kategori...",
                                icon: Icons.category_outlined,
                                controller: kategoriC,
                              ),
                            ),
                            SizedBox(
                              width: isMobile
                                  ? double.infinity
                                  : (width / 2) - 16,
                              child: _DatePickerField(
                                label: "Tanggal",
                                hint: "Pilih tanggal...",
                                icon: Icons.date_range_outlined,
                                controller: tanggalC,
                              ),
                            ),
                            SizedBox(
                              width: isMobile
                                  ? double.infinity
                                  : (width / 2) - 16,
                              child: _InputField(
                                label: "Lokasi Kegiatan",
                                hint: "Masukkan lokasi kegiatan...",
                                icon: Icons.location_on_outlined,
                                controller: lokasiC,
                              ),
                            ),
                            SizedBox(
                              width: isMobile
                                  ? double.infinity
                                  : (width / 2) - 16,
                              child: _InputField(
                                label: "Penanggung Jawab",
                                hint: "Masukkan nama penanggung jawab...",
                                icon: Icons.person_outline,
                                controller: pjC,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: loading ? null : submit,
                        icon: loading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check_circle_outline),

                        label: Text(
                          loading
                              ? (isEdit ? "Memperbarui..." : "Menyimpan...")
                              : (isEdit ? "Update" : "Simpan"),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 1,
                        ),
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
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;

  const _InputField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (v) => v == null || v.isEmpty ? "Tidak boleh kosong" : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF9F9FF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDADAF0), width: 1.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;

  const _DatePickerField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
  });

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      validator: (v) =>
          v == null || v.isEmpty ? "Tanggal tidak boleh kosong" : null,
      onTap: () => _pickDate(context),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF9F9FF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDADAF0), width: 1.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
        ),
      ),
    );
  }
}
