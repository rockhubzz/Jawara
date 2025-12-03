import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/pemasukan_lain_service.dart';

class EditPemasukanLain extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditPemasukanLain({super.key, required this.data});

  @override
  State<EditPemasukanLain> createState() => _EditPemasukanLainState();
}

class _EditPemasukanLainState extends State<EditPemasukanLain> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController jenisController;
  late TextEditingController tanggalController;
  late TextEditingController nominalController;

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(text: widget.data['nama']);
    jenisController = TextEditingController(text: widget.data['jenis']);
    tanggalController = TextEditingController(text: widget.data['tanggal']);
    nominalController = TextEditingController(
      text: widget.data['nominal'].toString(),
    );
  }

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "nama": namaController.text,
      "jenis": jenisController.text,
      "tanggal": tanggalController.text,
      "nominal": int.parse(nominalController.text),
    };

    final id = widget.data['id'];

    final success = await PemasukanService.update(id, payload);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil memperbarui data")),
      );
      context.go('/pemasukan/lain_daftar'); // kembali ke list
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal memperbarui data")));
    }
  }

  Future<void> deleteData() async {
    final id = widget.data['id'];

    final success = await PemasukanService.delete(id);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
      context.go('/pemasukan-lain'); // kembali ke list
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal menghapus data")));
    }
  }

  void showDeletePopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              deleteData();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Pemasukan Lain"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama"),
                validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
              ),
              TextFormField(
                controller: jenisController,
                decoration: const InputDecoration(labelText: "Jenis"),
                validator: (v) => v!.isEmpty ? "Jenis wajib diisi" : null,
              ),
              TextFormField(
                controller: tanggalController,
                decoration: const InputDecoration(labelText: "Tanggal"),
              ),
              TextFormField(
                controller: nominalController,
                decoration: const InputDecoration(labelText: "Nominal"),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text("Simpan Perubahan"),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: showDeletePopup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text("Hapus Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
