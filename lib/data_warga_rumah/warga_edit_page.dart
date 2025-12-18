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

  final nama = TextEditingController();
  final nik = TextEditingController();

  String? jenisKelamin;
  String? statusDomisili;
  String? statusHidup;
  int? keluargaId;

  bool loading = true;
  bool isLoadingSubmit = false;

  List<Map<String, dynamic>> keluargaList = [];

  static const Color kombuGreen = Color(0xFF374426);
  static const Color bgSoft = Color(0xFFF4F7F2);

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    keluargaList = await KeluargaService.getKeluarga();
    final data = await WargaService.getById(widget.wargaId);

    nama.text = data["nama"];
    nik.text = data["nik"];
    jenisKelamin = data["jenis_kelamin"];
    statusDomisili = data["status_domisili"];
    statusHidup = data["status_hidup"];
    keluargaId = data["keluarga_id"];

    setState(() => loading = false);
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
      _showDialog("Berhasil", "Data warga berhasil diupdate");
    }
  }

  void _cancelEdit() {
    _showDialog("Dibatalkan", "Data warga batal diupdate");
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/data_warga_rumah/detail/${widget.wargaId}');
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kombuGreen),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kombuGreen, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: bgSoft,

      /// APP BAR
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.6,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kombuGreen),
          onPressed: _cancelEdit,
        ),
        title: const Text(
          "Edit Warga",
          style: TextStyle(fontWeight: FontWeight.bold, color: kombuGreen),
        ),
      ),

      /// BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Ubah data warga di bawah ini",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<int>(
                      value: keluargaId,
                      decoration: _inputDecoration("Keluarga"),
                      items: keluargaList
                          .map(
                            (e) => DropdownMenuItem<int>(
                              value: e['id'],
                              child: Text(e['nama_keluarga']),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => keluargaId = v),
                      validator: (v) => v == null ? "Pilih keluarga" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: nama,
                      decoration: _inputDecoration("Nama"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Nama wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: nik,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("NIK"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "NIK wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: jenisKelamin,
                      decoration: _inputDecoration("Jenis Kelamin"),
                      items: const [
                        DropdownMenuItem(
                          value: "Laki-laki",
                          child: Text("Laki-laki"),
                        ),
                        DropdownMenuItem(
                          value: "Perempuan",
                          child: Text("Perempuan"),
                        ),
                      ],
                      onChanged: (v) => setState(() => jenisKelamin = v),
                      validator: (v) =>
                          v == null ? "Pilih jenis kelamin" : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: statusDomisili,
                      decoration: _inputDecoration("Status Domisili"),
                      items: const [
                        DropdownMenuItem(value: "Aktif", child: Text("Aktif")),
                        DropdownMenuItem(
                          value: "Tidak Aktif",
                          child: Text("Tidak Aktif"),
                        ),
                      ],
                      onChanged: (v) => setState(() => statusDomisili = v),
                      validator: (v) =>
                          v == null ? "Pilih status domisili" : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: statusHidup,
                      decoration: _inputDecoration("Status Hidup"),
                      items: const [
                        DropdownMenuItem(value: "Hidup", child: Text("Hidup")),
                        DropdownMenuItem(value: "Wafat", child: Text("Wafat")),
                      ],
                      onChanged: (v) => setState(() => statusHidup = v),
                      validator: (v) => v == null ? "Pilih status hidup" : null,
                    ),
                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: isLoadingSubmit ? null : save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kombuGreen,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoadingSubmit
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: _cancelEdit,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: kombuGreen),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Batal",
                            style: TextStyle(color: kombuGreen),
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
    );
  }
}
