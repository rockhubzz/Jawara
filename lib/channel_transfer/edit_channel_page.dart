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
  final Color softBg = const Color(0xFFE8F5E9);

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
      setState(() {
        selectedImage = File(file.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final body = {
      'nama': _namaController.text,
      'tipe': selectedType ?? '',
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
        const SnackBar(content: Text('Channel berhasil diperbarui')),
      );
      context.go('/channel_transfer/daftar');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resp['message'] ?? 'Gagal memperbarui')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBg,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen),
          onPressed: () => context.go('/channel_transfer/daftar'),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Edit Channel',
          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
        ),
      ),
      body: loadingData
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Nama Channel'),
                    _inputField(_namaController),

                    const SizedBox(height: 16),

                    _label('Tipe'),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      validator: (v) => v == null ? 'Pilih tipe' : null,
                      items: const [
                        DropdownMenuItem(value: 'bank', child: Text('Bank')),
                        DropdownMenuItem(
                          value: 'ewallet',
                          child: Text('E-Wallet'),
                        ),
                        DropdownMenuItem(value: 'qris', child: Text('QRIS')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (v) => setState(() => selectedType = v),
                      decoration: _inputDecoration(),
                    ),

                    const SizedBox(height: 16),

                    _label('Nomor Rekening / Akun'),
                    _inputField(_nomorController),

                    const SizedBox(height: 16),

                    _label('Nama Pemilik (A/N)'),
                    _inputField(_anController),

                    const SizedBox(height: 16),

                    _label('Thumbnail (jpg/png)'),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: primaryGreen.withOpacity(0.4),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Builder(
                          builder: (_) {
                            if (selectedImage != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            } else if (existingImage != null &&
                                existingImage!.isNotEmpty) {
                              final imageUrl = ChannelTransferService.imageUrl(
                                existingImage!,
                              );
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            }
                            return Text(
                              "Pilih Gambar",
                              style: TextStyle(
                                color: primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _label('Notes'),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: _inputDecoration(),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: loading ? null : _submit,
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Update',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ===================== COMPONENTS =====================

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600, color: primaryGreen),
      ),
    );
  }

  Widget _inputField(TextEditingController c) {
    return TextFormField(
      controller: c,
      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
      decoration: _inputDecoration(),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryGreen.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryGreen.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryGreen, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
