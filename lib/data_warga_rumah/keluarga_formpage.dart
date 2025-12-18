import 'package:flutter/material.dart';
import 'package:jawara/services/keluarga_service.dart';
import 'package:jawara/services/rumah_service.dart';

class KeluargaFormPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const KeluargaFormPage({super.key, this.data});

  @override
  State<KeluargaFormPage> createState() => _KeluargaFormPageState();
}

class _KeluargaFormPageState extends State<KeluargaFormPage> {
  final _formKey = GlobalKey<FormState>();

  final namaCtrl = TextEditingController();
  final kepalaCtrl = TextEditingController();
  final kepemilikanCtrl = TextEditingController();

  String? status;
  int? selectedRumahId;

  bool isLoadingSubmit = false;
  bool isLoadingRumah = true;

  List<Map<String, dynamic>> rumahList = [];

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      namaCtrl.text = widget.data!['nama_keluarga'] ?? '';
      kepalaCtrl.text = widget.data!['kepala_keluarga'] ?? '';
      kepemilikanCtrl.text = widget.data!['kepemilikan'] ?? '';
      status = widget.data!['status'];
      selectedRumahId = widget.data!['rumah_id'];
    }

    loadRumah();
  }

  Future<void> loadRumah() async {
    try {
      final data = await RumahService.getAll();

      final filtered = data.where((r) => r['status'] == 'Tersedia').toList();

      if (selectedRumahId != null) {
        final current = data.firstWhere(
          (r) => r['id'] == selectedRumahId,
          orElse: () => {},
        );
        if (current.isNotEmpty &&
            !filtered.any((r) => r['id'] == selectedRumahId)) {
          filtered.add(current);
        }
      }

      setState(() {
        rumahList = filtered;
        isLoadingRumah = false;
      });
    } catch (_) {
      setState(() => isLoadingRumah = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoadingSubmit = true);

    final payload = {
      "nama_keluarga": namaCtrl.text,
      "kepala_keluarga": kepalaCtrl.text,
      "kepemilikan": kepemilikanCtrl.text,
      "status": status,
      "rumah_id": selectedRumahId,
    };

    bool ok;
    if (widget.data == null) {
      ok = await KeluargaService.createKeluarga(payload);
    } else {
      ok = await KeluargaService.updateKeluarga(widget.data!['id'], payload);
    }

    setState(() => isLoadingSubmit = false);

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal menyimpan data")));
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType keyboard = TextInputType.text,
    bool required = false,
  }) {
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
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            decoration: InputDecoration(
              hintText: hint ?? label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: required
                ? (v) => v == null || v.isEmpty
                      ? "$label tidak boleh kosong"
                      : null
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Status",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: status,
            decoration: InputDecoration(
              hintText: "-- Pilih Status --",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: const [
              DropdownMenuItem(value: "Aktif", child: Text("Aktif")),
              DropdownMenuItem(
                value: "Tidak Aktif",
                child: Text("Tidak Aktif"),
              ),
            ],
            onChanged: (v) => setState(() => status = v),
            validator: (v) => v == null ? "Pilih status" : null,
          ),
        ],
      ),
    );
  }

  Widget _buildRumahDropdown() {
    if (isLoadingRumah) {
      // Tampilkan dropdown disabled sementara loading
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rumah",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int?>(
              items: [],
              onChanged: null,
              hint: const Text("Memuat..."),
            ),
          ],
        ),
      );
    }

    // Setelah data siap
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rumah",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int?>(
            value: selectedRumahId,
            decoration: InputDecoration(
              hintText: "-- Pilih Rumah --",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text("Tidak ada rumah"),
              ),
              ...rumahList.map(
                (r) => DropdownMenuItem<int?>(
                  value: r['id'],
                  child: Text("${r['kode']} - ${r['alamat']}"),
                ),
              ),
            ],
            onChanged: (v) => setState(() => selectedRumahId = v),
          ),
        ],
      ),
    );
  }

  // ==================== UI ====================
  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: primaryGreen,
          error: Colors.red,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryGreen),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryGreen),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: primaryGreen),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.data == null ? "Tambah Keluarga" : "Edit Keluarga",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 235, 188),
                Color.fromARGB(255, 181, 255, 183),
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24),
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
                      Text(
                        widget.data == null
                            ? "Isi data keluarga baru"
                            : "Ubah data keluarga",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildTextField(
                        "Nama Keluarga",
                        namaCtrl,
                        required: true,
                      ),
                      _buildTextField(
                        "Kepala Keluarga",
                        kepalaCtrl,
                        required: true,
                      ),
                      _buildTextField("Kepemilikan", kepemilikanCtrl),
                      _buildRumahDropdown(),
                      _buildStatusDropdown(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: isLoadingSubmit ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
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
                                : Text(
                                    widget.data == null ? "Submit" : "Update",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: primaryGreen),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text("Batal"),
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
}
