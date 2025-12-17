import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../services/channel_transfer_service.dart';
import 'dart:io';

class TambahChannelPage extends StatefulWidget {
  const TambahChannelPage({super.key});

  @override
  State<TambahChannelPage> createState() => _TambahChannelPageState();
}

class _TambahChannelPageState extends State<TambahChannelPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _anController = TextEditingController();
  final _nomorController = TextEditingController();
  final _notesController = TextEditingController();

  String? selectedType;
  File? selectedImage;

  bool isLoadingReset = false;

  bool loading = false;

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
      'tipe': selectedType ?? '',
      'an': _anController.text,
      'nomor': _nomorController.text,
      'notes': _notesController.text,
    };

    final resp = await ChannelTransferService.create(
      body,
      filePath: selectedImage?.path,
    );

    setState(() => loading = false);
    if (!mounted) return;

    if (resp['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Channel berhasil ditambahkan'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      context.go('/channel_transfer/daftar');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resp['message'] ?? 'Gagal menyimpan')),
      );
    }
  }

  @override
  // RESET FORM
  void _resetForm() async {
    setState(() => isLoadingReset = true);

    await Future.delayed(const Duration(milliseconds: 600));

    _formKey.currentState?.reset();
    _namaController.clear();
    _anController.clear();
    _nomorController.clear();
    _notesController.clear();
    selectedType = null;
    selectedImage = null;

    setState(() => isLoadingReset = false);
  }

  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'tambah';

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D32)),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF2E7D32), // | cursor
          selectionColor: Color(0x552E7D32), // blok teks
          selectionHandleColor: Color(0xFF2E7D32),
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF2E7D32),
            ),
            onPressed: () {
              if (from == 'tambah') {
                context.go('/beranda/tambah');
              } else {
                context.go('/beranda/semua_menu');
              }
            },
          ),
          title: const Text(
            "Tambah Channel",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),

        body: Container(
          width: double.infinity,
          height: double.infinity,
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

          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 90, 24, 24),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(24),

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
                          "Isi data channel transfer dengan benar",
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 24),

                        _label("Nama Channel"),
                        _input(
                          _namaController,
                          hint: "Contoh: BCA, Dana, ShopeePay",
                        ),

                        const SizedBox(height: 20),

                        _label("Tipe"),
                        DropdownButtonFormField<String>(
                          value: selectedType,
                          decoration: _decoration(
                            hint: "-- Pilih Tipe Channel --",
                          ),
                          validator: (v) => v == null ? "Pilih tipe" : null,
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
                          onChanged: (v) => setState(() => selectedType = v),
                        ),

                        const SizedBox(height: 20),

                        _label("Nomor Rekening / Akun"),
                        _input(
                          _nomorController,
                          hint: "Masukkan nomor rekening / akun",
                          keyboard: TextInputType.number,
                        ),

                        const SizedBox(height: 20),

                        _label("Nama Pemilik (A/N)"),
                        _input(_anController, hint: "Nama sesuai rekening"),

                        const SizedBox(height: 20),

                        _label("Thumbnail"),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            alignment: Alignment.center,
                            child: selectedImage == null
                                ? const Text("Klik untuk memilih gambar")
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: _decoration(
                            hint: "Catatan tambahan (opsional)",
                          ),
                        ),

                        const SizedBox(height: 28),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: loading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Simpan",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),

                            const SizedBox(width: 12),

                            OutlinedButton(
                              onPressed: isLoadingReset ? null : _resetForm,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF2E7D32),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: isLoadingReset
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    )
                                  : const Text(
                                      "Reset",
                                      style: TextStyle(
                                        color: Color(0xFF2E7D32),
                                        fontWeight: FontWeight.bold,
                                      ),
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

  // ---------------- UI HELPERS ----------------

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _input(
    TextEditingController c, {
    String? hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: c,
      keyboardType: keyboard,
      validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
      decoration: _decoration(hint: hint),
    );
  }

  InputDecoration _decoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black45),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2E7D32)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
