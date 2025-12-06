import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/data_warga_rumah/tambahWarga_page.dart';
import 'package:jawara/services/rumah_service.dart';

class TambahRumahPage extends StatefulWidget {
  final Map<String, dynamic>? data; // <-- null = create, ada value = edit

  const TambahRumahPage({super.key, this.data});

  @override
  State<TambahRumahPage> createState() => _TambahRumahPageState();
}

class _TambahRumahPageState extends State<TambahRumahPage> {
  final _formKey = GlobalKey<FormState>();

  final _kodeController = TextEditingController();
  final _alamatController = TextEditingController();
  final _keteranganController = TextEditingController();
  String? statusKepemilikan;

  bool isLoadingSubmit = false;
  bool isLoadingReset = false;

  @override
  void initState() {
    super.initState();

    // Jika edit, isi data lama
    if (widget.data != null) {
      _kodeController.text = widget.data!['kode'] ?? '';
      _alamatController.text = widget.data!['alamat'] ?? '';
      _keteranganController.text = widget.data!['keterangan'] ?? '';
    }
  }

  // RESET FORM
  void _resetForm() async {
    setState(() => isLoadingReset = true);

    await Future.delayed(const Duration(milliseconds: 800));

    _formKey.currentState?.reset();
    _kodeController.clear();
    _alamatController.clear();
    _keteranganController.clear();

    setState(() => isLoadingReset = false);
  }

  // SUBMIT DATA KE BACKEND
  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoadingSubmit = true);

    final payload = {
      "kode": _kodeController.text,
      "alamat": _alamatController.text,
      "status": statusKepemilikan,
      "keterangan": _keteranganController.text,
    };

    bool ok = false;

    if (widget.data == null) {
      ok = await RumahService.create(payload);
    } else {
      ok = await RumahService.update(widget.data!['id'], payload);
    }

    setState(() => isLoadingSubmit = false);

    if (!mounted) return;

    if (ok) {
      context.go('/data_warga_rumah/daftarRumah');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan data"),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
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
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2E7D32)),
          ),
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF2E7D32),
            ),
            onPressed: () => context.go('/beranda/semua_menu'),
          ),
          title: Text(
            widget.data == null ? "Tambah Rumah" : "Edit Rumah",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),

        body: Container(
          width: double.infinity,
          height: double.infinity,
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 120, 24, 24),

              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
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
                          "Isi data rumah dengan benar",
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 24),

                        // KODE RUMAH
                        const Text(
                          "Kode Rumah",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _kodeController,
                          decoration: InputDecoration(
                            hintText: "Contoh: RMH-001",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? "Kode wajib diisi"
                              : null,
                        ),

                        const SizedBox(height: 24),

                        // ALAMAT
                        const Text(
                          "Alamat Rumah",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _alamatController,
                          decoration: InputDecoration(
                            hintText: "Contoh: Jl. Merpati No. 5",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? "Alamat wajib diisi"
                              : null,
                        ),

                        const SizedBox(height: 24),

                        _buildDropdown("Status", statusKepemilikan, [
                          "Tersedia",
                          "Ditempati",
                          "Nonaktif",
                        ], (v) => statusKepemilikan = v),

                        // Keterangan
                        const Text(
                          "Keterangan",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _keteranganController,
                          decoration: InputDecoration(
                            hintText: "Catatan tambahan",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: isLoadingSubmit ? null : _submitForm,
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

                            OutlinedButton(
                              onPressed: isLoadingReset ? null : _resetForm,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF2E7D32),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }
}
