import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/keluarga_service.dart';
import '../../services/warga_service.dart';

class WargaEditPage extends StatefulWidget {
  final int wargaId;

  const WargaEditPage({super.key, required this.wargaId});

  @override
  State<WargaEditPage> createState() => _WargaEditPageState();
}

class _WargaEditPageState extends State<WargaEditPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoadingSubmit = false;
  bool isLoadingReset = false;

  final nama = TextEditingController();
  final nik = TextEditingController();
  String? jenisKelamin;
  String? statusDomisili;
  String? statusHidup;
  int? keluargaId;

  List<Map<String, dynamic>> keluargaList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await loadKeluarga();
    await loadExistingWarga(widget.wargaId);

    loading = false;
    setState(() {});
  }

  Future<void> loadKeluarga() async {
    keluargaList = await KeluargaService.getKeluarga();
  }

  Future<void> loadExistingWarga(int id) async {
    final data = await WargaService.getById(id);

    nama.text = data["nama"];
    nik.text = data["nik"];
    jenisKelamin = data["jenis_kelamin"];
    statusDomisili = data["status_domisili"];
    statusHidup = data["status_hidup"];
    keluargaId = data["keluarga_id"];
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoadingSubmit = true);

    final body = {
      "nama": nama.text,
      "nik": nik.text,
      "keluarga_id": keluargaId.toString(),
      "jenis_kelamin": jenisKelamin,
      "status_domisili": statusDomisili,
      "status_hidup": statusHidup,
    };

    final ok = await WargaService.update(widget.wargaId, body);

    setState(() => isLoadingSubmit = false);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil diperbarui"),
          backgroundColor: Colors.green,
        ),
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        context.go('/data_warga_rumah/daftarWarga');
      });
    }

    // if (ok) {
    //   context.go('/data_warga_rumah/daftarWarga');
    // } else {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text("Gagal menyimpan")));
    // }
  }

  void _resetForm() async {
    setState(() => isLoadingReset = true);
    await Future.delayed(const Duration(milliseconds: 300));
    _formKey.currentState?.reset();
    nama.clear();
    nik.clear();
    setState(() {
      jenisKelamin = null;
      statusDomisili = null;
      statusHidup = null;
      keluargaId = null;
    });
    setState(() => isLoadingReset = false);
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (v) =>
          v == null || v.isEmpty ? "$label tidak boleh kosong" : null,
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => setState(() => onChanged(v)),
      validator: (v) => v == null ? "Pilih $label" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D32)),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2E7D32)),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF2E7D32),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Edit Warga",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        spreadRadius: 2,
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
                          "Ubah data warga di bawah ini",
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: "Keluarga",
                          ),
                          value: keluargaId,
                          items: keluargaList
                              .map(
                                (e) => DropdownMenuItem<int>(
                                  value: e['id'] as int,
                                  child: Text(e['nama_keluarga']),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => keluargaId = v),
                          validator: (v) => v == null ? "Pilih keluarga" : null,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField("Nama", nama),
                        const SizedBox(height: 16),

                        _buildTextField(
                          "NIK",
                          nik,
                          keyboard: TextInputType.number,
                        ),
                        const SizedBox(height: 16),

                        _buildDropdown("Jenis Kelamin", jenisKelamin, [
                          "Laki-laki",
                          "Perempuan",
                        ], (v) => jenisKelamin = v),
                        const SizedBox(height: 16),

                        _buildDropdown(
                          "Status Domisili",
                          statusDomisili,
                          ["Aktif", "Tidak Aktif"],
                          (v) => statusDomisili = v,
                        ),
                        const SizedBox(height: 16),

                        _buildDropdown("Status Hidup", statusHidup, [
                          "Hidup",
                          "Wafat",
                        ], (v) => statusHidup = v),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: isLoadingSubmit ? null : save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
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
                                      "Update",
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
                                side: const BorderSide(
                                  color: Color(0xFF2E7D32),
                                ),
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
                                  color: Color(0xFF2E7D32),
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
