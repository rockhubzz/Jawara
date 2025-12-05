import 'package:flutter/material.dart';
import 'package:jawara/widgets/appDrawer.dart';
import 'package:jawara/services/kategori_iuran_service.dart';
import 'package:jawara/services/tagihan_service.dart';
import 'package:jawara/services/keluarga_service.dart';
import 'package:go_router/go_router.dart';

class TagihIuranPage extends StatefulWidget {
  const TagihIuranPage({super.key});

  @override
  State<TagihIuranPage> createState() => _TagihIuranPageState();
}

class _TagihIuranPageState extends State<TagihIuranPage> {
  final _formKey = GlobalKey<FormState>();
  final _tanggalController = TextEditingController();

  String? selectedIuran;
  String selectedKeluarga = "ALL"; // default
  List<Map<String, dynamic>> jenisIuranList = [];
  List<Map<String, dynamic>> keluargaList = [];

  bool isLoadingIuran = true;
  bool isLoadingKeluarga = true;

  @override
  void initState() {
    super.initState();
    loadJenisIuran();
    loadKeluarga();
  }

  // ===============================================
  // LOAD DATA IURAN
  // ===============================================
  Future<void> loadJenisIuran() async {
    try {
      final list = await KategoriIuranService.getAll();
      setState(() {
        jenisIuranList = list;
        isLoadingIuran = false;
      });
    } catch (e) {
      setState(() => isLoadingIuran = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memuat jenis iuran: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ===============================================
  // LOAD DATA KELUARGA
  // ===============================================
  Future<void> loadKeluarga() async {
    try {
      final list =
          await KeluargaService.getKeluarga(); // result: [{id, kepala_keluarga, ...}]
      setState(() {
        keluargaList = list;
        isLoadingKeluarga = false;
      });
    } catch (e) {
      setState(() => isLoadingKeluarga = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memuat keluarga: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ===============================================
  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      selectedIuran = null;
      selectedKeluarga = "ALL";
      _tanggalController.clear();
    });
  }

  // ===============================================
  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final selected = jenisIuranList.firstWhere(
      (item) => item['nama'] == selectedIuran,
    );

    final payload = {
      "kategori_iuran_id": selected['id'].toString(),
      "tanggal_tagihan": _tanggalController.text.split('/').reversed.join('-'),
      "status": "belum_bayar",
    };

    bool res = false;

    // 🔥 1. Jika pilih SEMUA KELUARGA
    if (selectedKeluarga == "ALL") {
      res = await TagihanService.createAll(payload);
    } else {
      // 🔥 2. Jika pilih 1 keluarga saja
      payload["keluarga_id"] = selectedKeluarga;
      res = await TagihanService.createByKeluarga(payload);
    }

    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tagihan berhasil dibuat!"),
          backgroundColor: Colors.green,
        ),
      );
      _resetForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal membuat tagihan"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ===============================================
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      _tanggalController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  // ===============================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),

        title: const Text("Tagih Iuran", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tagih Iuran",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),

                  // ============================================
                  // DROPDOWN KELUARGA
                  // ============================================
                  const Text(
                    "Keluarga",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  isLoadingKeluarga
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<String>(
                          value: selectedKeluarga,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: "ALL",
                              child: Text("Semua Keluarga"),
                            ),
                            ...keluargaList.map((kel) {
                              return DropdownMenuItem(
                                value: kel['id'].toString(),
                                child: Text(kel['kepala_keluarga']),
                              );
                            }).toList(),
                          ],
                          onChanged: (v) =>
                              setState(() => selectedKeluarga = v!),
                        ),

                  const SizedBox(height: 24),

                  // ============================================
                  // DROPDOWN IURAN
                  // ============================================
                  const Text(
                    "Jenis Iuran",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  isLoadingIuran
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: "-- Pilih Iuran --",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          value: selectedIuran,
                          items: jenisIuranList.map((iuran) {
                            return DropdownMenuItem<String>(
                              value: iuran['nama'],
                              child: Text(iuran['nama']),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => selectedIuran = value),
                          validator: (value) => value == null
                              ? "Pilih jenis iuran terlebih dahulu"
                              : null,
                        ),

                  const SizedBox(height: 24),

                  // ============================================
                  // TANGGAL TAGIHAN
                  // ============================================
                  const Text(
                    "Tanggal Tagihan",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _tanggalController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "--/--/----",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _pickDate,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Pilih tanggal" : null,
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                        ),
                        child: const Text(
                          "Tagih Iuran",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: _resetForm,
                        child: const Text("Reset"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
