import 'package:flutter/material.dart';
import 'package:jawara/services/rumah_service.dart';

class RumahFormPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const RumahFormPage({super.key, this.data});

  @override
  State<RumahFormPage> createState() => _RumahFormPageState();
}

class _RumahFormPageState extends State<RumahFormPage> {
  final formKey = GlobalKey<FormState>();

  final kodeCtrl = TextEditingController();
  final alamatCtrl = TextEditingController();
  final statusCtrl = TextEditingController();

  String? selectedStatus;

  static const Color kombu = Color(0xFF374426);
  static const Color bgSoft = Color(0xFFF1F5EE);

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      kodeCtrl.text = widget.data!['kode'];
      alamatCtrl.text = widget.data!['alamat'];
      selectedStatus = widget.data!['status'];
      statusCtrl.text = widget.data!['status'];
    }
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;

    final payload = {
      "kode": kodeCtrl.text,
      "alamat": alamatCtrl.text,
      "status": statusCtrl.text,
    };

    final ok = await RumahService.update(widget.data!['id'], payload);

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
          content: const Text("Data rumah berhasil diperbarui."),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kombu),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Gagal",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Gagal menyimpan data rumah."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSoft,

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kombu),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Rumah",
          style: TextStyle(color: kombu, fontWeight: FontWeight.w600),
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
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Form Edit Rumah",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kombu,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// KODE RUMAH
                    TextFormField(
                      controller: kodeCtrl,
                      decoration: _inputDecoration("No Rumah"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Wajib diisi" : null,
                    ),

                    const SizedBox(height: 12),

                    /// ALAMAT
                    TextFormField(
                      controller: alamatCtrl,
                      decoration: _inputDecoration("Alamat"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Wajib diisi" : null,
                    ),

                    const SizedBox(height: 12),

                    /// STATUS
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: _inputDecoration("Status Rumah"),
                      items: const [
                        DropdownMenuItem(
                          value: 'Tersedia',
                          child: Text('Tersedia'),
                        ),
                        DropdownMenuItem(
                          value: 'Ditempati',
                          child: Text('Ditempati'),
                        ),
                        DropdownMenuItem(
                          value: 'Nonaktif',
                          child: Text('Nonaktif'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                          statusCtrl.text = value ?? '';
                        });
                      },
                      validator: (value) =>
                          value == null ? "Status wajib dipilih" : null,
                    ),

                    const SizedBox(height: 24),

                    /// BUTTON
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
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
                        onPressed: save,
                        child: const Text(
                          "Update",
                          style: TextStyle(fontSize: 16),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
