import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({super.key});

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _teleponController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  bool isLoadingSubmit = false;
  bool isLoadingReset = false;

  String? _keluarga;
  String? _jenisKelamin;
  String? _agama;
  String? _golonganDarah;
  String? _peranKeluarga;
  String? _pendidikan;
  String? _pekerjaan;
  String? _status;

  void _resetForm() async {
    setState(() => isLoadingReset = true);

    await Future.delayed(const Duration(seconds: 1));

    _formKey.currentState?.reset();
    _namaController.clear();
    _nikController.clear();
    _teleponController.clear();
    _tempatLahirController.clear();
    _tanggalLahirController.clear();
    setState(() {
      _keluarga = null;
      _jenisKelamin = null;
      _agama = null;
      _golonganDarah = null;
      _peranKeluarga = null;
      _pendidikan = null;
      _pekerjaan = null;
      _status = null;
    });

    setState(() => isLoadingReset = false);
  }

  void _submitForm() async {
    setState(() => isLoadingSubmit = true);

    await Future.delayed(const Duration(seconds: 2)); // simulasi loading

    setState(() => isLoadingSubmit = false);

    // lanjut validasi atau kirim ke backend nanti
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: "Pilih Tanggal Lahir",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32), // Header background + warna utama
              onPrimary: Colors.white, // Warna teks di header
              onSurface: Colors.black, // Warna teks tanggal
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF2E7D32), // Tombol OK & Batal
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _tanggalLahirController.text =
            "${picked.day.toString().padLeft(2, '0')}-"
            "${picked.month.toString().padLeft(2, '0')}-"
            "${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => context.go('/beranda/semua_menu'),
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
                      _buildDropdown("Pilih Keluarga", _keluarga, [
                        "Keluarga A",
                        "Keluarga B",
                        "Keluarga C",
                      ], (v) => _keluarga = v),

                      _buildTextField(
                        "Nama",
                        _namaController,
                        hint: "Masukkan nama lengkap",
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        "NIK",
                        _nikController,
                        hint: "Masukkan NIK",
                        keyboard: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        "Nomor Telepon",
                        _teleponController,
                        hint: "08xxxx",
                        keyboard: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        "Tempat Lahir",
                        _tempatLahirController,
                        hint: "Masukkan tempat lahir",
                      ),
                      const SizedBox(height: 16),

                      // === TANGGAL LAHIR ===
                      const Text(
                        "Tanggal Lahir",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _tanggalLahirController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "--/--/----",
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF2E7D32), // Ikon hijau
                            ),
                            onPressed: _pickDate,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF2E7D32),
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? "Pilih tanggal lahir"
                            : null,
                      ),

                      const SizedBox(height: 16),

                      _buildDropdown("Jenis Kelamin", _jenisKelamin, [
                        "Laki-laki",
                        "Perempuan",
                      ], (v) => _jenisKelamin = v),

                      _buildDropdown("Agama", _agama, [
                        "Islam",
                        "Kristen",
                        "Katolik",
                        "Hindu",
                        "Budha",
                      ], (v) => _agama = v),

                      _buildDropdown("Golongan Darah", _golonganDarah, [
                        "A",
                        "B",
                        "AB",
                        "O",
                      ], (v) => _golonganDarah = v),

                      _buildDropdown("Peran Keluarga", _peranKeluarga, [
                        "Ayah",
                        "Ibu",
                        "Anak",
                      ], (v) => _peranKeluarga = v),

                      _buildDropdown("Pendidikan Terakhir", _pendidikan, [
                        "SD",
                        "SMP",
                        "SMA",
                        "Diploma",
                        "Sarjana",
                      ], (v) => _pendidikan = v),

                      _buildDropdown("Pekerjaan", _pekerjaan, [
                        "Pelajar",
                        "Karyawan",
                        "Wiraswasta",
                        "Lainnya",
                      ], (v) => _pekerjaan = v),

                      _buildDropdown("Status", _status, [
                        "Menikah",
                        "Belum Menikah",
                      ], (v) => _status = v),

                      const SizedBox(height: 24),

                      // ================= BUTTON =================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // === SUBMIT BUTTON ===
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
          validator: (v) =>
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
