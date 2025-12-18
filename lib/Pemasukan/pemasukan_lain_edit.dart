import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/pemasukan_lain_service.dart';

class EditPemasukanLain extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditPemasukanLain({super.key, required this.data});

  @override
  State<EditPemasukanLain> createState() => _EditPemasukanLainState();
}

class _EditPemasukanLainState extends State<EditPemasukanLain> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController tanggalController;
  late TextEditingController nominalController;

  String? _kategori;
  File? _buktiFile;
  String? _existingBukti;

  final List<String> _kategoriList = ['Donasi', 'Sponsor', 'Event', 'Lainnya'];

  bool isSubmitting = false;

  static const kombu = Color(0xFF374426);
  static const bgSoft = Color(0xFFF0F4EE);

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.data['nama']);
    tanggalController = TextEditingController(text: widget.data['tanggal']);
    nominalController = TextEditingController(
      text: widget.data['nominal'].toString(),
    );
    _kategori = widget.data['jenis'];
    _existingBukti = widget.data['bukti'];
  }

  InputDecoration _inputDecoration(String label, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: kombu),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kombu),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kombu, width: 1.5),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(tanggalController.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      tanggalController.text = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _buktiFile = File(image.path));
  }

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final payload = {
      "nama": namaController.text,
      "jenis": _kategori!,
      "tanggal": tanggalController.text,
      "nominal": nominalController.text,
    };

    try {
      final res = await PemasukanService.update(
        widget.data['id'],
        payload,
        filePath: _buktiFile?.path,
      );

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil memperbarui data")),
        );
        context.go('/pemasukan/lain_daftar');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? "Gagal memperbarui data")),
        );
      }
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  void showDeletePopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              PemasukanService.delete(widget.data['id']);
              context.go('/pemasukan/lain_daftar');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Iya"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSoft,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Edit Pemasukan Lain",
          style: TextStyle(color: kombu),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kombu),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: namaController,
                      decoration: _inputDecoration("Nama"),
                      validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _kategori,
                      decoration: _inputDecoration("Kategori"),
                      items: _kategoriList
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _kategori = v);
                      },
                      validator: (v) =>
                          v == null ? "Kategori wajib dipilih" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: tanggalController,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: _inputDecoration(
                        "Tanggal",
                        suffix: const Icon(Icons.calendar_today, color: kombu),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Tanggal wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: nominalController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Nominal"),
                      validator: (v) =>
                          v!.isEmpty ? "Nominal wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Bukti (Opsional)",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: kombu,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kombu),
                          color: bgSoft,
                        ),
                        child: _buktiFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _buktiFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : _existingBukti != null &&
                                  _existingBukti!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  "${PemasukanService.baseUrl}/storage/$_existingBukti",
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  "Upload Bukti (jpg/png)",
                                  style: TextStyle(color: kombu),
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: isSubmitting ? null : saveData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kombu,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Simpan Perubahan"),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: showDeletePopup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: const Text("Hapus Data"),
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
