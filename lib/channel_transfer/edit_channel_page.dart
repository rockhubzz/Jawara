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

  final Color kombuGreen = const Color(0xFF374426);
  final Color softBg = const Color(0xFFF4F7F2);

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
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Icon(
          Icons.check_circle,
          color: Color(0xFF374426),
          size: 48,
        ),
        content: const Text(
          "Data telah di update",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kombuGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              context.go('/channel_transfer/daftar');
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(primary: kombuGreen),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kombuGreen),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kombuGreen, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: softBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.6,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: kombuGreen),
            onPressed: () => context.go('/channel_transfer/daftar'),
          ),
          title: Text(
            "Edit Channel",
            style: TextStyle(fontWeight: FontWeight.bold, color: kombuGreen),
          ),
        ),
        body: loadingData
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                "Ubah data channel transfer",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 24),

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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedButton(
                                    onPressed: () =>
                                        context.go('/channel_transfer/daftar'),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: kombuGreen),
                                    ),
                                    child: Text(
                                      "Batal",
                                      style: TextStyle(color: kombuGreen),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: loading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kombuGreen,
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
              border: Border.all(color: kombuGreen),
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
                    style: TextStyle(color: kombuGreen),
                  ),
          ),
        ),
      ],
    );
  }
}
