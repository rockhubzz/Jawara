import 'package:flutter/material.dart';
import 'package:jawara/services/rumah_service.dart';

class RumahFormPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const RumahFormPage({super.key, this.data});

  @override
  State<RumahFormPage> createState() => _RumahFormPageState();
}

class _RumahFormPageState extends State<RumahFormPage> {
  final _formKey = GlobalKey<FormState>();

  bool isLoadingSubmit = false;

  final kodeCtrl = TextEditingController();
  final alamatCtrl = TextEditingController();
  String? status;

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      kodeCtrl.text = widget.data!['kode'];
      alamatCtrl.text = widget.data!['alamat'];
      status = widget.data!['status'];
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoadingSubmit = true);

    final payload = {
      "kode": kodeCtrl.text,
      "alamat": alamatCtrl.text,
      "status": status,
    };

    bool ok;
    if (widget.data == null) {
      ok = await RumahService.create(payload);
    } else {
      ok = await RumahService.update(widget.data!['id'], payload);
    }

    setState(() => isLoadingSubmit = false);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.data == null
                ? "Berhasil menambahkan rumah"
                : "Berhasil memperbarui rumah",
          ),
          backgroundColor: Colors.green,
        ),
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context, true);
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal menyimpan data")));
    }
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (v) => v == null || v.isEmpty ? "$label wajib diisi" : null,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: status,
      decoration: InputDecoration(
        labelText: "Status Rumah",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: const [
        DropdownMenuItem(value: 'Tersedia', child: Text('Tersedia')),
        DropdownMenuItem(value: 'Ditempati', child: Text('Ditempati')),
        DropdownMenuItem(value: 'Nonaktif', child: Text('Nonaktif')),
      ],
      onChanged: (v) => setState(() => status = v),
      validator: (v) => v == null ? "Status wajib dipilih" : null,
    );
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
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.data == null ? "Tambah Rumah" : "Edit Rumah",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
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
                          "Isi data rumah di bawah ini",
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 16),

                        _buildTextField("Kode Rumah", kodeCtrl),
                        const SizedBox(height: 16),

                        _buildTextField("Alamat", alamatCtrl),
                        const SizedBox(height: 16),

                        _buildDropdown(),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: isLoadingSubmit ? null : save,
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
                                  : Text(
                                      widget.data == null ? "Simpan" : "Update",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF2E7D32),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                "Batal",
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
}
