import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../widgets/appDrawer.dart';
import '../services/pemasukan_lain_service.dart';

class PemasukanLainTambah extends StatefulWidget {
  const PemasukanLainTambah({Key? key}) : super(key: key);

  @override
  State<PemasukanLainTambah> createState() => _PemasukanLainTambahState();
}

class _PemasukanLainTambahState extends State<PemasukanLainTambah> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _nominalController = TextEditingController();
  final _tanggalController = TextEditingController();
  String? _kategori;
  File? _buktiFile;

  bool isSubmitting = false;
  bool isLoadingSubmit = false;
  bool isLoadingReset = false;

  final List<String> _kategoriList = ['Donasi', 'Sponsor', 'Event', 'Lainnya'];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: "Pilih Tanggal Pemasukan",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D32)),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF2E7D32)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _tanggalController.text = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => _buktiFile = File(image.path));
    }
  }

  void _resetForm() async {
    setState(() => isLoadingReset = true);

    await Future.delayed(const Duration(seconds: 1));

    _formKey.currentState?.reset();
    _namaController.clear();
    _nominalController.clear();
    _tanggalController.clear();

    setState(() {
      _kategori = null;
      _buktiFile = null;
      isLoadingReset = false;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final payload = {
      "nama": _namaController.text,
      "jenis": _kategori,
      "tanggal": _tanggalController.text,
      "nominal": _nominalController.text,
      "bukti": null, // karena service tidak menerima file
    };

    final ok = await PemasukanService.create(payload);

    setState(() => isSubmitting = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pemasukan berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/pemasukan/lain_daftar'); // kembali ke list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan pemasukan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/beranda'),
        ),
        title: const Text(
          "Tambah Pemasukan lain",
          style: TextStyle(color: Colors.black),
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D32)),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2E7D32)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2E7D32)),
          ),
          hintStyle: TextStyle(
            color: Color(0xFF7E8A97), // <--- warna abu modern, sama semua hint
            fontSize: 14,
          ),
          labelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true, // <<--- Biar gradient sampai atas
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF2E7D32),
            ),
            onPressed: () => context.go('/beranda/semua_menu'),
          ),
          title: const Text(
            "Tambah Pemasukan Lain",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
              child: Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Buat Pemasukan Non Iuran Baru',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _namaController,
                            decoration: const InputDecoration(
                              labelText: 'Nama Pemasukan',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value!.isEmpty
                                ? 'Nama pemasukan wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _tanggalController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Tanggal Pemasukan',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: _pickDate,
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Tanggal wajib diisi' : null,
                          ),
                          const SizedBox(height: 20),

                          DropdownButtonFormField<String>(
                            value: _kategori,
                            items: _kategoriList
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() => _kategori = value);
                            },
                            decoration: const InputDecoration(
                              labelText: 'Kategori Pemasukan',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null
                                ? 'Pilih kategori pemasukan'
                                : null,
                          ),
                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _nominalController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Nominal',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Nominal wajib diisi' : null,
                          ),
                          const SizedBox(height: 20),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bukti Pemasukan',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child: _buktiFile != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.file(
                                            _buktiFile!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Center(
                                          child: Text(
                                            'Upload bukti pemasukan (.png/.jpg) — *tidak dikirim ke backend*',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // SUBMIT
                          ElevatedButton(
                            onPressed: isLoadingSubmit ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 26,
                                vertical: 12,
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: isSubmitting ? null : _submitForm,
                                child: isSubmitting
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Submit'),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton(
                                onPressed: _resetForm,
                                child: const Text('Reset'),
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tanggal Pemasukan",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _tanggalController,
          readOnly: true,
          onTap: _pickDate,
          decoration: const InputDecoration(
            hintText: "Pilih tanggal",
            suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF2E7D32)),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "Tanggal wajib dipilih" : null,
        ),
      ],
    );
  }

  // ---- Component Builder ----
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType keyboard = TextInputType.text,
    String? validatorMsg,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          decoration: InputDecoration(hintText: hint ?? "Masukkan $label"),
          validator: (v) => validatorMsg != null && (v == null || v.isEmpty)
              ? validatorMsg
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: const InputDecoration(hintText: "Pilih salah satu"),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          validator: (v) => v == null ? "$label wajib dipilih" : null,
        ),
      ],
    );
  }
}
