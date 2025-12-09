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
  bool isLoadingSubmit = false;

  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController hpController;
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.user["name"]);
    emailController = TextEditingController(text: widget.user["email"]);
    hpController = TextEditingController(text: widget.user["hp"]);
    selectedRole = widget.user["role"];
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoadingSubmit = true);

    final result = await UserService.updateUser(
      id: widget.user["id"],
      name: namaController.text.trim(),
      email: emailController.text.trim(),
      hp: hpController.text.trim(),
      role: selectedRole!,
    );

    setState(() => isLoadingSubmit = false);

    if (!mounted) return;

    if (result["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Akun berhasil diperbarui"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"].toString())),
      );
    }
  }

  void _resetForm() {
    namaController.text = widget.user["name"];
    emailController.text = widget.user["email"];
    hpController.text = widget.user["hp"];
    setState(() => selectedRole = widget.user["role"]);
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (v) => v == null || v.isEmpty ? "$label tidak boleh kosong" : null,
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) => setState(() => onChanged(v)),
      validator: (v) => v == null ? "Pilih $label" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D32)),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF2E7D32), width: 2)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF2E7D32))),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2E7D32)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Edit Akun Pengguna',
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
              colors: [Color.fromARGB(255, 255, 235, 188), Color.fromARGB(255, 181, 255, 183)],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, spreadRadius: 2, offset: Offset(0, 4))],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ubah data pengguna di bawah ini",
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 16),

                        _buildTextField("Nama Lengkap", namaController),
                        const SizedBox(height: 16),

                        _buildTextField("Email", emailController, keyboard: TextInputType.emailAddress),
                        const SizedBox(height: 16),

                        _buildTextField("Nomor HP", hpController, keyboard: TextInputType.phone),
                        const SizedBox(height: 16),

                        _buildDropdown("Role", selectedRole, ["admin", "rw", "rt", "sekretaris", "bendahara", "warga"], (v) => selectedRole = v),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: isLoadingSubmit ? null : save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: isLoadingSubmit
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text("Update", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: _resetForm,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF2E7D32)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: const Text("Reset", style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
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
}
