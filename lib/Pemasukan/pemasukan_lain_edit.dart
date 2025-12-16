import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
  late TextEditingController tanggalController;
  late TextEditingController nominalController;
  String? _kategori;
  File? _buktiFile;
  String? _existingBukti;

  final List<String> _kategoriList = ['Donasi', 'Sponsor', 'Event', 'Lainnya'];

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(text: widget.data['nama']);
    tanggalController = TextEditingController(text: widget.data['tanggal']);
    nominalController = TextEditingController(
      text: widget.data['nominal'].toString(),
    );
    _kategori = widget.data['jenis'];
    _existingBukti = widget.data['bukti'];
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(tanggalController.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: "Pilih Tanggal Pemasukan",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D32)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      tanggalController.text = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => _buktiFile = File(image.path));
    }
  }

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final payload = {
      "nama": namaController.text,
      "jenis": _kategori!,
      "tanggal": tanggalController.text,
      "nominal": nominalController.text,
    };

    final id = widget.data['id'];

    try {
      final response = await PemasukanService.update(
        id,
        payload,
        filePath: _buktiFile?.path,
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil memperbarui data")),
        );
        context.go('/pemasukan/lain_daftar');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Gagal memperbarui data")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan saat memperbarui")),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  Future<void> deleteData() async {
    final id = widget.data['id'];

    final success = await PemasukanService.delete(id);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
      context.go('/pemasukan/lain_daftar');
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: "Nama"),
                  validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _kategori,
                  decoration: const InputDecoration(labelText: "Kategori"),
                  items: _kategoriList
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _kategori = v),
                  validator: (v) => v == null ? "Kategori wajib dipilih" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: tanggalController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: const InputDecoration(
                    labelText: "Tanggal",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (v) => v!.isEmpty ? "Tanggal wajib diisi" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nominalController,
                  decoration: const InputDecoration(labelText: "Nominal"),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? "Nominal wajib diisi" : null,
                ),
                const SizedBox(height: 16),
                // Upload bukti
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bukti (Opsional)",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                      color: Colors.green.shade50,
                    ),
                    child: _buktiFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _buktiFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : _existingBukti != null && _existingBukti!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  "${PemasukanService.baseUrl}/storage/$_existingBukti",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: Text(
                                      "Gagal memuat gambar",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text(
                                  "Upload Bukti Baru (jpg/png)",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                  ),
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  onPressed: isSubmitting ? null : saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Simpan Perubahan"),
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
      ),
    );
  }
}
