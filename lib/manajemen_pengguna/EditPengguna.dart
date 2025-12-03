import 'package:flutter/material.dart';
import '../services/user_service.dart';

class EditUserPage extends StatefulWidget {
  final Map user;
  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController hpController;
  String? selectedRole;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.user["name"]);
    emailController = TextEditingController(text: widget.user["email"]);
    hpController = TextEditingController(text: widget.user["hp"]);
    selectedRole = widget.user["role"];
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await UserService.updateUser(
      id: widget.user["id"],
      name: namaController.text.trim(),
      email: emailController.text.trim(),
      hp: hpController.text.trim(),
      role: selectedRole!,
    );

    setState(() => isLoading = false);

    if (result["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Akun berhasil diperbarui"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"].toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Akun Pengguna',
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
                  const Text(
                    'Edit Akun Pengguna',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // NAMA
                  const Text('Nama Lengkap'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: namaController,
                    decoration: _inputDecoration('Masukkan nama lengkap'),
                    validator: (v) =>
                        v!.isEmpty ? "Nama tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 14),

                  // EMAIL
                  const Text('Email'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration('Masukkan email aktif'),
                    validator: (v) =>
                        v!.isEmpty ? "Email tidak boleh kosong" : null,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),

                  // HP
                  const Text('Nomor HP'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: hpController,
                    decoration: _inputDecoration('Masukkan nomor HP'),
                    validator: (v) =>
                        v!.isEmpty ? "Nomor HP tidak boleh kosong" : null,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 14),

                  // ROLE
                  const Text('Role'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: selectedRole,
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
                    validator: (v) => v == null ? "Role harus dipilih" : null,
                    onChanged: (value) => setState(() => selectedRole = value),
                  ),
                  const SizedBox(height: 24),

                  // BUTTONS
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: isLoading ? null : _submit,
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
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Simpan',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      const SizedBox(width: 12),

                      OutlinedButton(
                        onPressed: () {
                          namaController.text = widget.user["name"];
                          emailController.text = widget.user["email"];
                          hpController.text = widget.user["hp"];
                          setState(() => selectedRole = widget.user["role"]);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
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
