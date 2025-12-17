import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/channel_transfer_service.dart';

class EditMetodePembayaranPage extends StatefulWidget {
  final int id;

  const EditMetodePembayaranPage({super.key, required this.id});

  @override
  State<EditMetodePembayaranPage> createState() =>
      _EditMetodePembayaranPageState();
}

class _EditMetodePembayaranPageState extends State<EditMetodePembayaranPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _anController = TextEditingController();
  final _nomorController = TextEditingController();
  final _notesController = TextEditingController();

  String? selectedType;
  File? selectedImage;
  String? existingImage;

  bool loading = false;
  bool loadingData = true;

  final Color primaryGreen = const Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final data = await ChannelTransferService.getById(widget.id);

    if (data != null) {
      setState(() {
        _namaController.text = data['nama'] ?? '';
        _anController.text = data['an'] ?? '';
        _nomorController.text = data['nomor'] ?? '';
        _notesController.text = data['notes'] ?? '';
        selectedType = data['tipe'];
        existingImage = data['thumbnail'];
        loadingData = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => selectedImage = File(file.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final body = {
      'nama': _namaController.text,
      'tipe': selectedType!,
      'an': _anController.text,
      'nomor': _nomorController.text,
      'notes': _notesController.text,
    };

    final resp = await ChannelTransferService.update(
      widget.id,
      body,
      filePath: selectedImage?.path,
    );

    setState(() => loading = false);

    if (!mounted) return;

    if (resp['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil diperbarui"),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/channel_transfer/daftar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D32)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryGreen),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryGreen, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF2E7D32),
            ),
            // onPressed: () => Navigator.pop(context),
            onPressed: () {
              context.go('/channel_transfer/daftar');
            },
          ),
          title: const Text(
            "Edit Channel",
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
                Color.fromARGB(255, 255, 235, 188),
                Color.fromARGB(255, 181, 255, 183),
              ],
            ),
          ),

          child: loadingData
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Ubah data channel transfer",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 16),

                              _input("Nama Channel", _namaController),
                              const SizedBox(height: 16),

                              DropdownButtonFormField<String>(
                                value: selectedType,
                                decoration: const InputDecoration(
                                  labelText: "Tipe",
                                ),
                                validator: (v) =>
                                    v == null ? "Pilih tipe" : null,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'bank',
                                    child: Text('Bank'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'ewallet',
                                    child: Text('E-Wallet'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'qris',
                                    child: Text('QRIS'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'other',
                                    child: Text('Other'),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => selectedType = v),
                              ),
                              const SizedBox(height: 16),

                              _input("Nomor Rekening / Akun", _nomorController),
                              const SizedBox(height: 16),

                              _input("Nama Pemilik (A/N)", _anController),
                              const SizedBox(height: 16),

                              _thumbnailPicker(),
                              const SizedBox(height: 16),

                              TextFormField(
                                controller: _notesController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: "Notes",
                                ),
                              ),
                              const SizedBox(height: 28),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: loading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryGreen,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: loading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text("Update"),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton(
                                    // onPressed: () => Navigator.pop(context),
                                    onPressed: () {
                                      context.go('/channel_transfer/daftar');
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: primaryGreen),
                                    ),
                                    child: Text(
                                      "Batal",
                                      style: TextStyle(color: primaryGreen),
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
      ),
    );
  }

  Widget _input(String label, TextEditingController c) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(labelText: label),
      validator: (v) => v == null || v.isEmpty ? "$label wajib diisi" : null,
    );
  }

  Widget _thumbnailPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Thumbnail", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryGreen),
            ),
            alignment: Alignment.center,
            child: selectedImage != null
                ? Image.file(selectedImage!, fit: BoxFit.cover)
                : existingImage != null
                ? Image.network(
                    ChannelTransferService.imageUrl(existingImage!),
                    fit: BoxFit.cover,
                  )
                : Text(
                    "Klik untuk pilih gambar",
                    style: TextStyle(color: primaryGreen),
                  ),
          ),
        ),
      ],
    );
  }
}
