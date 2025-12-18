import 'package:flutter/material.dart';
import 'package:jawara/data_warga_rumah/daftar_rumah_page.dart';
import 'package:jawara/services/rumah_service.dart';

class TambahRumahPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const TambahRumahPage({super.key, this.data});

  @override
  State<TambahRumahPage> createState() => _TambahRumahPageState();
}

class _TambahRumahPageState extends State<TambahRumahPage> {
  final _formKey = GlobalKey<FormState>();

  final _kodeController = TextEditingController();
  final _alamatController = TextEditingController();
  final _keteranganController = TextEditingController();

  String? statusKepemilikan;
  bool isLoadingSubmit = false;

  static const Color kombu = Color(0xFF374426);
  static const Color bgSoft = Color(0xFFF1F5EE);

  // SUBMIT
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoadingSubmit = true);

    final payload = {
      "kode": _kodeController.text,
      "alamat": _alamatController.text,
      "status": statusKepemilikan,
      "keterangan": _keteranganController.text,
    };

    final ok = await RumahService.create(payload);

    setState(() => isLoadingSubmit = false);
    if (!mounted) return;

    if (ok) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Berhasil",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Tambah rumah berhasil."),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kombu),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RumahListPage()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan data"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSoft,

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kombu),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Tambah Rumah",
          style: TextStyle(color: kombu, fontWeight: FontWeight.bold),
        ),
      ),

      /// BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
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
                      "Form Tambah Rumah",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kombu,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _kodeController,
                      decoration: _decoration("Kode Rumah"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _alamatController,
                      decoration: _decoration("Alamat"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      decoration: _decoration("Status Rumah"),
                      value: statusKepemilikan,
                      items: const [
                        DropdownMenuItem(
                          value: "Tersedia",
                          child: Text("Tersedia"),
                        ),
                        DropdownMenuItem(
                          value: "Ditempati",
                          child: Text("Ditempati"),
                        ),
                        DropdownMenuItem(
                          value: "Nonaktif",
                          child: Text("Nonaktif"),
                        ),
                      ],
                      onChanged: (v) => setState(() => statusKepemilikan = v),
                      validator: (v) =>
                          v == null ? "Status wajib dipilih" : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _keteranganController,
                      decoration: _decoration("Keterangan"),
                    ),

                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: isLoadingSubmit ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kombu,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
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
                                "Submit",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
