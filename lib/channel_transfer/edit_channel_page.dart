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

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  // ===== LOAD DATA DARI API =====
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

  // ===== PICK IMAGE =====
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        selectedImage = File(file.path);
      });
    }
  }

  // ===== SUBMIT UPDATE =====
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
      context.go('/channel_transfer/daftar'); // balik & trigger refresh list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resp['message'] ?? 'Gagal memperbarui')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/channel_transfer/daftar'),
        ),

        backgroundColor: Colors.white,
        title: const Text('Edit Channel'),
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
                    TextFormField(
                      controller: _namaController,
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),

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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _label('Nomor Rekening / Akun'),
                    TextFormField(
                      controller: _nomorController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _label('Nama Pemilik (A/N)'),
                    TextFormField(
                      controller: _anController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _label('Thumbnail (jpg/png)'),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 110,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        alignment: Alignment.center,
                        child: Builder(
                          builder: (_) {
                            if (selectedImage != null) {
                              return Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              );
                            } else if (existingImage != null &&
                                existingImage!.isNotEmpty) {
                              final imageUrl = ChannelTransferService.imageUrl(
                                existingImage!,
                              );
                              return Image.network(imageUrl, fit: BoxFit.cover);
                            }
                            return const Text("Pilih Gambar");
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _label('Notes'),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: loading ? null : _submit,
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Update'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
