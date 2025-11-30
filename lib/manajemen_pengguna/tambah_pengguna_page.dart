import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class TambahAkunPenggunaPage extends StatefulWidget {
  const TambahAkunPenggunaPage({super.key});

  @override
  State<TambahAkunPenggunaPage> createState() => _TambahAkunPenggunaPageState();
}

class _TambahAkunPenggunaPageState extends State<TambahAkunPenggunaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController konfirmasiPasswordController =
      TextEditingController();

  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tambah Akun Pengguna',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === Title ===
                  const Text(
                    'Tambah Akun Pengguna',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // === Nama Lengkap ===
                  const Text('Nama Lengkap'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: namaController,
                    decoration: _inputDecoration('Masukkan nama lengkap'),
                  ),
                  const SizedBox(height: 14),

                  // === Email ===
                  const Text('Email'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration('Masukkan email aktif'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),

                  // === Nomor HP ===
                  const Text('Nomor HP'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: hpController,
                    decoration: _inputDecoration(
                      'Masukkan nomor HP (cth: 08xxxxxxxxxx)',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 14),

                  // === Password ===
                  const Text('Password'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: _inputDecoration('Masukkan password'),
                  ),
                  const SizedBox(height: 14),

                  // === Konfirmasi Password ===
                  const Text('Konfirmasi Password'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: konfirmasiPasswordController,
                    obscureText: true,
                    decoration: _inputDecoration('Masukkan ulang password'),
                  ),
                  const SizedBox(height: 14),

                  // === Role ===
                  const Text('Role'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: _inputDecoration('-- Pilih Role --'),
                    items: const [
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      DropdownMenuItem(value: 'rw', child: Text('Ketua RW')),
                      DropdownMenuItem(value: 'rt', child: Text('Ketua RT')),
                      DropdownMenuItem(
                        value: 'sekretaris',
                        child: Text('Sekretaris'),
                      ),
                      DropdownMenuItem(
                        value: 'bendahara',
                        child: Text('Bendahara'),
                      ),
                      DropdownMenuItem(value: 'warga', child: Text('Warga')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // === Buttons ===
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Simpan logic di sini
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                          namaController.clear();
                          emailController.clear();
                          hpController.clear();
                          passwordController.clear();
                          konfirmasiPasswordController.clear();
                          setState(() => selectedRole = null);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black54,
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.6),
      ),
    );
  }
}
