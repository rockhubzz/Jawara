import 'package:flutter/material.dart';
import 'package:jawara/services/rumah_service.dart';
import 'package:jawara/widgets/appDrawer.dart';

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
  final TextEditingController statusCtrl = TextEditingController();
  String? selectedStatus;

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      kodeCtrl.text = widget.data!['kode'];
      alamatCtrl.text = widget.data!['alamat'];
      statusCtrl.text = widget.data!['status'];
    }
  }

  void save() async {
    if (!formKey.currentState!.validate()) return;

    final payload = {
      "kode": kodeCtrl.text,
      "alamat": alamatCtrl.text,
      "status": statusCtrl.text,
    };

    bool ok;
    if (widget.data == null) {
      ok = await RumahService.create(payload);
    } else {
      ok = await RumahService.update(widget.data!['id'], payload);
    }

    if (ok) {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(widget.data == null ? "Tambah Rumah" : "Edit Rumah"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: kodeCtrl,
                decoration: const InputDecoration(labelText: "Kode Rumah"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: alamatCtrl,
                decoration: const InputDecoration(labelText: "Alamat"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: "Status Rumah",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Tersedia', child: Text('Tersedia')),
                  DropdownMenuItem(
                    value: 'Ditempati',
                    child: Text('Ditempati'),
                  ),
                  DropdownMenuItem(value: 'Nonaktif', child: Text('Nonaktif')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                    statusCtrl.text = value ?? '';
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Status wajib dipilih'
                    : null,
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
