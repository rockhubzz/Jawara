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

  static const Color kombu = Color(0xFF374426);
  static const Color bgSoft = Color(0xFFDFDDD1);

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

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 80, color: kombu),
            const SizedBox(height: 16),
            const Text(
              "Tagihan berhasil dibuat",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kombu,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kombu,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

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
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _tanggalController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'semua';

    return Scaffold(
      backgroundColor: bgSoft,

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kombu),
          onPressed: () {
            context.go(
              from == 'pemasukan_menu'
                  ? '/beranda/pemasukan_menu'
                  : '/beranda/semua_menu',
            );
          },
        ),
        title: const Text(
          "Tagih Iuran",
          style: TextStyle(fontWeight: FontWeight.bold, color: kombu),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Form Tagih Iuran",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kombu,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _label("Keluarga"),
                  isLoadingKeluarga
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField(
                          value: selectedKeluarga,
                          decoration: _inputStyle(),
                          items: [
                            const DropdownMenuItem(
                              value: "ALL",
                              child: Text("Semua Keluarga"),
                            ),
                            ...keluargaList.map(
                              (k) => DropdownMenuItem(
                                value: k['id'].toString(),
                                child: Text(k['kepala_keluarga']),
                              ),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => selectedKeluarga = v!),
                        ),

                  const SizedBox(height: 20),
                  _label("Jenis Iuran"),
                  isLoadingIuran
                      ? const Center(child: CircularProgressIndicator())
                      // : DropdownButtonFormField(
                      //     decoration: _inputStyle(),
                      //     value: selectedIuran,
                      //     items: jenisIuranList
                      //         .map(
                      //           (i) => DropdownMenuItem(
                      //             value: i['nama'],
                      //             child: Text(i['nama']),
                      //           ),
                      //         )
                      //         .toList(),
                      //     onChanged: (v) => setState(() => selectedIuran = v),
                      //     validator: (v) =>
                      //         v == null ? "Pilih jenis iuran" : null,
                      //   ),
                      : DropdownButtonFormField<String>(
                          value: selectedIuran,
                          decoration: _inputStyle(),
                          items: jenisIuranList
                              .map(
                                (i) => DropdownMenuItem<String>(
                                  value: i['nama'],
                                  child: Text(i['nama']),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => selectedIuran = v);
                            }
                          },
                          validator: (v) =>
                              v == null ? "Pilih jenis iuran" : null,
                        ),

                  const SizedBox(height: 20),
                  _label("Tanggal Tagihan"),
                  TextFormField(
                    controller: _tanggalController,
                    readOnly: true,
                    decoration: _inputStyle().copyWith(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today, color: kombu),
                        onPressed: _pickDate,
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Pilih tanggal" : null,
                  ),

                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kombu,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Buat Tagihan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: _resetForm,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kombu),
                    ),
                    child: const Text("Reset", style: TextStyle(color: kombu)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, color: kombu),
    ),
  );

  InputDecoration _inputStyle() => InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: kombu),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: kombu),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: kombu, width: 2),
    ),
  );
}
