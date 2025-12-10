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
  String selectedKeluarga = "ALL";
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

  Future<void> loadJenisIuran() async {
    try {
      final list = await KategoriIuranService.getAll();
      setState(() {
        jenisIuranList = list;
        isLoadingIuran = false;
      });
    } catch (e) {
      setState(() => isLoadingIuran = false);
    }
  }

  Future<void> loadKeluarga() async {
    try {
      final list = await KeluargaService.getKeluarga();
      setState(() {
        keluargaList = list;
        isLoadingKeluarga = false;
      });
    } catch (e) {
      setState(() => isLoadingKeluarga = false);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      selectedIuran = null;
      selectedKeluarga = "ALL";
      _tanggalController.clear();
    });
  }

  // 🔥 POPUP SUCCESS
  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 80,
                color: Color(0xFF2E7D32),
              ),
              const SizedBox(height: 16),
              const Text(
                "Tagihan Berhasil Dibuat!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  minimumSize: const Size(120, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 SUBMIT FORM + POPUP
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

    if (selectedKeluarga == "ALL") {
      res = await TagihanService.createAll(payload);
    } else {
      payload["keluarga_id"] = selectedKeluarga;
      res = await TagihanService.createByKeluarga(payload);
    }

    if (res == true) {
      _showSuccessPopup();
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

  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'semua';
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 235, 188),
              Color.fromARGB(255, 181, 255, 183),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF2E7D32),
                ),
                onPressed: () {
                  if (from == 'pemasukan_menu') {
                    context.go('/beranda/pemasukan_menu');
                  } else {
                    context.go('/beranda/semua_menu');
                  }
                },
              ),
              title: const Text(
                "Tagih Iuran",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Form Tagih Iuran",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // DROPDOWN KELUARGA
                          const Text(
                            "Keluarga",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 8),

                          isLoadingKeluarga
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF2E7D32),
                                  ),
                                )
                              : DropdownButtonFormField<String>(
                                  value: selectedKeluarga,
                                  decoration: _inputStyle(),
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

                          // DROPDOWN IURAN
                          const Text(
                            "Jenis Iuran",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 8),

                          isLoadingIuran
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF2E7D32),
                                  ),
                                )
                              : DropdownButtonFormField<String>(
                                  decoration: _inputStyle(),
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
                                      ? "Pilih jenis iuran"
                                      : null,
                                ),

                          const SizedBox(height: 24),

                          // TANGGAL TAGIHAN
                          const Text(
                            "Tanggal Tagihan",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _tanggalController,
                            readOnly: true,
                            decoration: _inputStyle().copyWith(
                              hintText: "yy-mm-dd",
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFF2E7D32),
                                ),
                                onPressed: _pickDate,
                              ),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Pilih tanggal"
                                : null,
                          ),

                          const SizedBox(height: 28),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2E7D32),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Buat Tagihan",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton(
                                onPressed: _resetForm,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                child: const Text(
                                  "Reset",
                                  style: TextStyle(color: Color(0xFF2E7D32)),
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
          ],
        ),
      ),
    );
  }

  // STYLE INPUT FIELD
  InputDecoration _inputStyle() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2E7D32)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2E7D32)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 2, color: Color(0xFF2E7D32)),
      ),
    );
  }
}
