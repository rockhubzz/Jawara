import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/data_warga_rumah/daftar_warga_page.dart';
import 'package:jawara/services/keluarga_service.dart';
import 'package:jawara/services/warga_service.dart';

class TambahWargaPage extends StatefulWidget {
  final int? wargaId;

  const TambahWargaPage({super.key, this.wargaId});

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoadingReset = false;
  bool isLoadingSubmit = false;

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

    if (widget.wargaId != null) {
      await loadExistingWarga(widget.wargaId!);
    }

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

    final Map<String, dynamic> body = {
      "nama": nama.text,
      "nik": nik.text,
      "keluarga_id": keluargaId.toString(),
      "jenis_kelamin": jenisKelamin,
      "status_domisili": statusDomisili,
      "status_hidup": statusHidup,
    };

    bool ok = false;

    if (widget.wargaId == null) {
      // ADD
      ok = await WargaService.create(body);
    } else {
      // UPDATE
      ok = await WargaService.update(widget.wargaId!, body);
    }

    if (!mounted) return;

    if (ok) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WargaListPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal menyimpan")));
    }
  }

  Widget dropdown<T>(
    String label,
    T? value,
    List<T> items,
    void Function(T?) onChanged,
  ) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(labelText: label),
      value: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
          .toList(),
      onChanged: onChanged,
    );
  }

  void _resetForm() async {
    setState(() => isLoadingReset = true);

    await Future.delayed(const Duration(seconds: 1));

    _formKey.currentState?.reset();
    nama.clear();
    nik.clear();
    setState(() {
      jenisKelamin = null;
      statusDomisili = null;
      statusHidup = null;
    });

    setState(() => isLoadingReset = false);
  }

  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'tambah';
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF2E7D32), // warna border fokus
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2E7D32)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2E7D32)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // ================= APPBAR BARU ==================
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF2E7D32),
            ),
            onPressed: () {
              if (from == 'tambah') {
                context.go('/beranda/tambah');
              } else {
                context.go('/beranda/semua_menu');
              }
            },
          ),
          title: const Text(
            "Tambah Warga",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          centerTitle: false,
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
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24),

                // CARD FORM BERGAYA BARU
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
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
                        "Isi detail di bawah untuk menambahkan data warga",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),

                      // === DROPDOWN KELUARGA ===
                      const Text(
                        "Keluarga",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          hintText: "-- Pilih Keluarga --",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                        validator: (v) => v == null ? "Pilih Keluarga" : null,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        "Nama",
                        nama,
                        hint: "Masukkan nama lengkap",
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        "NIK",
                        nik,
                        hint: "Masukkan NIK",
                        keyboard: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "NIK tidak boleh kosong";
                          }
                          if (v.length < 16) {
                            return "NIK harus 16 digit";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildDropdown("Jenis Kelamin", jenisKelamin, [
                        "Laki-laki",
                        "Perempuan",
                      ], (v) => jenisKelamin = v),

                      _buildDropdown("Status Domisili", statusDomisili, [
                        "Aktif",
                        "Tidak Aktif",
                      ], (v) => statusDomisili = v),

                      _buildDropdown("Status Hidup", statusHidup, [
                        "Hidup",
                        "Wafat",
                      ], (v) => statusHidup = v),
                      const SizedBox(height: 24),

                      // ================= BUTTON =================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // === SUBMIT BUTTON ===
                          ElevatedButton(
                            onPressed: save,
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
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),

                          const SizedBox(width: 12),

                          // === RESET BUTTON ===
                          OutlinedButton(
                            onPressed: isLoadingReset ? null : _resetForm,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF2E7D32)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: isLoadingReset
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  )
                                : const Text(
                                    "Reset",
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
    );
  }

  // ==================== Helper ====================

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator:
              validator ??
              (v) =>
                  v == null || v.isEmpty ? "$label tidak boleh kosong" : null,
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              hintText: "-- Pilih $label --",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => onChanged(v)),
            validator: (v) => v == null ? "Pilih $label" : null,
          ),
        ],
      ),
    );
  }

  Widget _rowTwo(Widget left, Widget right) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }
}
