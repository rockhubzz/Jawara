import 'package:flutter/material.dart';
import 'package:jawara/services/keluarga_service.dart';

class KeluargaFormPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const KeluargaFormPage({super.key, this.data});

  @override
  State<KeluargaFormPage> createState() => _KeluargaFormPageState();
}

class _KeluargaFormPageState extends State<KeluargaFormPage> {
  final formKey = GlobalKey<FormState>();

  final namaCtrl = TextEditingController();
  final kepalaCtrl = TextEditingController();
  final alamatCtrl = TextEditingController();
  final kepemilikanCtrl = TextEditingController();
  String status = "Aktif";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      namaCtrl.text = widget.data!['nama_keluarga'];
      kepalaCtrl.text = widget.data!['kepala_keluarga'];
      alamatCtrl.text = widget.data!['alamat'];
      kepemilikanCtrl.text = widget.data!['kepemilikan'];
      status = widget.data!['status'];
    }
  }

  void save() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final payload = {
      "nama_keluarga": namaCtrl.text,
      "kepala_keluarga": kepalaCtrl.text,
      "alamat": alamatCtrl.text,
      "kepemilikan": kepemilikanCtrl.text,
      "status": status,
    };

    bool success;
    if (widget.data == null) {
      success = await KeluargaService.createKeluarga(payload);
    } else {
      success = await KeluargaService.updateKeluarga(
        widget.data!['id'],
        payload,
      );
    }

    setState(() => isLoading = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal menyimpan data")));
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(primary: primaryGreen),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryGreen, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryGreen),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: primaryGreen),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.data == null ? "Tambah Keluarga" : "Edit Keluarga",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryGreen,
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Isi data keluarga di bawah ini",
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: namaCtrl,
                          decoration: const InputDecoration(
                            labelText: "Nama Keluarga",
                          ),
                          validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: kepalaCtrl,
                          decoration: const InputDecoration(
                            labelText: "Kepala Keluarga",
                          ),
                          validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: alamatCtrl,
                          decoration: const InputDecoration(
                            labelText: "Alamat",
                          ),
                          validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: kepemilikanCtrl,
                          decoration: const InputDecoration(
                            labelText: "Kepemilikan",
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text("Status"),
                        DropdownButton<String>(
                          value: status,
                          items: ["Aktif", "Tidak Aktif"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => status = v!),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: isLoading ? null : save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                      "Simpan",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: primaryGreen),
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
                                  color: primaryGreen,
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
