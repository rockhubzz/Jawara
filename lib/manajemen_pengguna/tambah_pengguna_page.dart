import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'package:go_router/go_router.dart';

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
  bool isLoadingSubmit = false;
  bool isLoadingReset = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != konfirmasiPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Password tidak sama")));
      return;
    }

    setState(() => isLoadingSubmit = true);

    final result = await UserService.createUser(
      name: namaController.text.trim(),
      email: emailController.text.trim(),
      hp: hpController.text.trim(),
      password: passwordController.text.trim(),
      role: selectedRole!,
    );

    setState(() => isLoadingSubmit = false);

    if (result["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Akun berhasil ditambahkan"),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/user/daftar');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"].toString())));
    }
  }

  Future<void> _resetForm() async {
    setState(() => isLoadingReset = true);

    await Future.delayed(const Duration(milliseconds: 500));

    _formKey.currentState?.reset();
    namaController.clear();
    emailController.clear();
    hpController.clear();
    passwordController.clear();
    konfirmasiPasswordController.clear();

    setState(() => selectedRole = null);
    setState(() => isLoadingReset = false);
  }

  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'tambah';
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D32)),
        inputDecorationTheme: InputDecorationTheme(
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
            onPressed: () {
              if (from == 'tambah') {
                context.go('/beranda/tambah');
              } else {
                context.go('/beranda/semua_menu');
              }
            },
          ),
          title: const Text(
            "Tambah Akun Pengguna",
            style: TextStyle(
              fontSize: 20,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
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
                        "Isi detail di bawah untuk menambahkan akun pengguna",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),

                      _buildTextField("Nama Lengkap", namaController),
                      const SizedBox(height: 16),

                      _buildTextField(
                        "Email",
                        emailController,
                        keyboard: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        "Nomor HP",
                        hpController,
                        keyboard: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        "Password",
                        passwordController,
                        obscure: true,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        "Konfirmasi Password",
                        konfirmasiPasswordController,
                        obscure: true,
                      ),
                      const SizedBox(height: 16),

                      _buildDropdown("Role", selectedRole, [
                        "admin",
                        "rw",
                        "rt",
                        "sekretaris",
                        "bendahara",
                        "warga",
                      ], (v) => selectedRole = v),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: isLoadingSubmit ? null : _submit,
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
                            child: isLoadingSubmit
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
                              side: const BorderSide(color: Color(0xFF2E7D32)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
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
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: "Masukkan $label",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "$label tidak boleh kosong" : null,
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: "-- Pilih $label --",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => onChanged(v)),
          validator: (v) => v == null ? "Pilih $label" : null,
        ),
      ],
    );
  }
}
