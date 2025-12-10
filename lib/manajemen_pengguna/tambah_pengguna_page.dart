// import 'package:flutter/material.dart';
// import '../widgets/appDrawer.dart';
// import '../services/user_service.dart';

// class TambahAkunPenggunaPage extends StatefulWidget {
//   const TambahAkunPenggunaPage({super.key});

//   @override
//   State<TambahAkunPenggunaPage> createState() => _TambahAkunPenggunaPageState();
// }

// class _TambahAkunPenggunaPageState extends State<TambahAkunPenggunaPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController namaController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController hpController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController konfirmasiPasswordController =
//       TextEditingController();

//   String? selectedRole;
//   bool isLoading = false;

//   // ==============================
//   //            SUBMIT
//   // ==============================
//   void _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (passwordController.text != konfirmasiPasswordController.text) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Password tidak sama")));
//       return;
//     }

//     setState(() => isLoading = true);

//     final result = await UserService.createUser(
//       name: namaController.text.trim(),
//       email: emailController.text.trim(),
//       hp: hpController.text.trim(),
//       password: passwordController.text.trim(),
//       role: selectedRole!,
//     );

//     setState(() => isLoading = false);

//     if (result["success"] == true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Akun berhasil ditambahkan"),
//           backgroundColor: Colors.green,
//         ),
//       );
//       Navigator.pop(context, true);
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(result["message"].toString())));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Tambah Akun Pengguna',
//           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black87),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 500),
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Tambah Akun Pengguna',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // === Nama ===
//                   const Text('Nama Lengkap'),
//                   const SizedBox(height: 6),
//                   TextFormField(
//                     controller: namaController,
//                     decoration: _inputDecoration('Masukkan nama lengkap'),
//                     validator: (v) =>
//                         v!.isEmpty ? "Nama tidak boleh kosong" : null,
//                   ),
//                   const SizedBox(height: 14),

//                   // === Email ===
//                   const Text('Email'),
//                   const SizedBox(height: 6),
//                   TextFormField(
//                     controller: emailController,
//                     decoration: _inputDecoration('Masukkan email aktif'),
//                     validator: (v) =>
//                         v!.isEmpty ? "Email tidak boleh kosong" : null,
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   const SizedBox(height: 14),

//                   // === Nomor HP ===
//                   const Text('Nomor HP'),
//                   const SizedBox(height: 6),
//                   TextFormField(
//                     controller: hpController,
//                     decoration: _inputDecoration('Masukkan nomor HP'),
//                     validator: (v) =>
//                         v!.isEmpty ? "Nomor HP tidak boleh kosong" : null,
//                     keyboardType: TextInputType.phone,
//                   ),
//                   const SizedBox(height: 14),

//                   // === Password ===
//                   const Text('Password'),
//                   const SizedBox(height: 6),
//                   TextFormField(
//                     controller: passwordController,
//                     obscureText: true,
//                     decoration: _inputDecoration('Masukkan password'),
//                     validator: (v) =>
//                         v!.isEmpty ? "Password tidak boleh kosong" : null,
//                   ),
//                   const SizedBox(height: 14),

//                   // === Konfirmasi Password ===
//                   const Text('Konfirmasi Password'),
//                   const SizedBox(height: 6),
//                   TextFormField(
//                     controller: konfirmasiPasswordController,
//                     obscureText: true,
//                     decoration: _inputDecoration('Masukkan ulang password'),
//                     validator: (v) =>
//                         v!.isEmpty ? "Konfirmasi password wajib diisi" : null,
//                   ),
//                   const SizedBox(height: 14),

//                   // === Role ===
//                   const Text('Role'),
//                   const SizedBox(height: 6),
//                   DropdownButtonFormField<String>(
//                     value: selectedRole,
//                     decoration: _inputDecoration('-- Pilih Role --'),
//                     items: const [
//                       DropdownMenuItem(value: 'admin', child: Text('Admin')),
//                       DropdownMenuItem(value: 'rw', child: Text('Ketua RW')),
//                       DropdownMenuItem(value: 'rt', child: Text('Ketua RT')),
//                       DropdownMenuItem(
//                         value: 'sekretaris',
//                         child: Text('Sekretaris'),
//                       ),
//                       DropdownMenuItem(
//                         value: 'bendahara',
//                         child: Text('Bendahara'),
//                       ),
//                       DropdownMenuItem(value: 'warga', child: Text('Warga')),
//                     ],
//                     validator: (v) => v == null ? "Role harus dipilih" : null,
//                     onChanged: (value) => setState(() => selectedRole = value),
//                   ),
//                   const SizedBox(height: 24),

//                   // === Buttons ===
//                   Row(
//                     children: [
//                       ElevatedButton(
//                         onPressed: isLoading ? null : _submit,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF6366F1),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 24,
//                             vertical: 12,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: isLoading
//                             ? const SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : const Text(
//                                 'Simpan',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                       ),
//                       const SizedBox(width: 12),
//                       OutlinedButton(
//                         onPressed: () {
//                           _formKey.currentState!.reset();
//                           namaController.clear();
//                           emailController.clear();
//                           hpController.clear();
//                           passwordController.clear();
//                           konfirmasiPasswordController.clear();
//                           setState(() => selectedRole = null);
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Color(0xFFE2E8F0)),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 24,
//                             vertical: 12,
//                           ),
//                         ),
//                         child: const Text('Reset'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ==============================
//   //      INPUT DECORATION
//   // ==============================
//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       filled: true,
//       fillColor: const Color(0xFFF9FAFB),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.6),
//       ),
//     );
//   }
// }

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

  void _resetForm() {
    setState(() => isLoadingReset = true);

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
            onPressed: () => context.go('/beranda/semua_menu'),
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
