import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/services/pemasukan_lain_service.dart';

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

  bool isLoadingSubmit = false;
  bool isLoadingReset = false;
  bool isSubmitting = false;

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
      "bukti": null,
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

      context.go('/pemasukan/lain_daftar');
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
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'semua';
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
          hintStyle: TextStyle(color: Color(0xFF7E8A97), fontSize: 14),
          labelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF2E7D32),
            ),
            
            onPressed: () {
              if (from == 'pemasukan_menu') {
                context.go('/beranda/pemasukan_menu');
              } else if (from == 'tambah') {
                context.go('/beranda/tambah');
              } else {
                context.go('/beranda/semua_menu');
              }
            },
          ),
          title: const Text(
            "Tambah Pemasukan Lain",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),
        
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 255, 244, 214),
                Color.fromARGB(255, 199, 255, 201),
              ],
            ),
          ),

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Isi detail di bawah untuk menambahkan pemasukan",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),
                      // NAMA
                      _buildTextField(
                        label: "Nama Pemasukan",
                        controller: _namaController,
                        validatorMsg: "Nama wajib diisi",
                      ),
                      const SizedBox(height: 16),

                      _buildDateField(),
                      const SizedBox(height: 16),

                      // KATEGORI
                      _buildDropdown(
                        label: "Kategori",
                        value: _kategori,
                        items: _kategoriList,
                        onChanged: (v) => setState(() => _kategori = v),
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        label: "Nominal",
                        controller: _nominalController,
                        keyboard: TextInputType.number,
                        validatorMsg: "Nominal wajib diisi",
                      ),
                      const SizedBox(height: 16),

                      // Upload bukti
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Bukti (Opsional)",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFF2E7D32)),
                            color: Colors.green.shade50,
                          ),
                          child: _buktiFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _buktiFile!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    "Upload Bukti (jpg/png)",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2E7D32),
                              padding: EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 12,
                              ),
                            ),
                            onPressed: isSubmitting ? null : _submitForm,
                            child: isSubmitting
                                ? CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                          const SizedBox(width: 12),

                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Color(0xFF2E7D32)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 12,
                              ),
                            ),
                            onPressed: isLoadingReset ? null : _resetForm,
                            child: isLoadingReset
                                ? CircularProgressIndicator(
                                    color: Color(0xFF2E7D32),
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    "Reset",
                                    style: TextStyle(color: Color(0xFF2E7D32)),
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
          validator: (v) {
            if (validatorMsg != null && (v == null || v.isEmpty)) {
              return validatorMsg;
            }
            return null;
          },
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
