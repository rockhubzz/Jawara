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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data == null ? "Tambah Keluarga" : "Edit Keluarga"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: "Nama Keluarga"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: kepalaCtrl,
                decoration: const InputDecoration(labelText: "Kepala Keluarga"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: alamatCtrl,
                decoration: const InputDecoration(labelText: "Alamat"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: kepemilikanCtrl,
                decoration: const InputDecoration(labelText: "Kepemilikan"),
              ),
              const SizedBox(height: 20),

              const Text("Status"),
              DropdownButton<String>(
                value: status,
                items: ["Aktif", "Tidak Aktif"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => status = v!),
              ),

              const SizedBox(height: 20),

              ElevatedButton(onPressed: save, child: const Text("Simpan")),
            ],
          ),
        ),
      ),
    );
  }
}
