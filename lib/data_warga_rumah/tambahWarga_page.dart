import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/widgets/appDrawer.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({super.key});

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _teleponController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();

  // Dropdown values
  String? _keluarga;
  String? _jenisKelamin;
  String? _agama;
  String? _golonganDarah;
  String? _peranKeluarga;
  String? _pendidikan;
  String? _pekerjaan;
  String? _status;

  void _resetForm() {
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
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data warga berhasil disimpan!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _tanggalLahirController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          "Tambah Warga",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: AppDrawer(email: 'admin1@mail.com'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
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
                    "Isi detail di bawah untuk menambahkan data warga baru",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // PILIH KELUARGA
                  const Text("Pilih Keluarga",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _keluarga,
                    decoration: _inputDecoration("-- Pilih Keluarga --"),
                    items: ["Keluarga A", "Keluarga B", "Keluarga C"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => _keluarga = val),
                    validator: (val) =>
                        val == null ? "Pilih salah satu keluarga" : null,
                  ),
                  const SizedBox(height: 16),

                  // NAMA
                  _buildTextField("Nama", _namaController,
                      hint: "Masukkan nama lengkap"),
                  const SizedBox(height: 16),

                  // NIK
                  _buildTextField("NIK", _nikController,
                      hint: "Masukkan NIK sesuai KTP", keyboard: TextInputType.number),
                  const SizedBox(height: 16),

                  // NOMOR TELEPON
                  _buildTextField("Nomor Telepon", _teleponController,
                      hint: "08xxxxxx", keyboard: TextInputType.phone),
                  const SizedBox(height: 16),

                  // TEMPAT LAHIR
                  _buildTextField("Tempat Lahir", _tempatLahirController,
                      hint: "Masukkan tempat lahir"),
                  const SizedBox(height: 16),

                  // TANGGAL LAHIR
                  const Text("Tanggal Lahir",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _tanggalLahirController,
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // DROPDOWN LANJUTAN
                  _buildDropdown("Jenis Kelamin", _jenisKelamin, [
                    "Laki-laki",
                    "Perempuan"
                  ], (val) => _jenisKelamin = val),
                  _buildDropdown("Agama", _agama, [
                    "Islam",
                    "Kristen",
                    "Katolik",
                    "Hindu",
                    "Budha"
                  ], (val) => _agama = val),
                  _buildDropdown("Golongan Darah", _golonganDarah,
                      ["A", "B", "AB", "O"], (val) => _golonganDarah = val),
                  _buildDropdown("Peran Keluarga", _peranKeluarga,
                      ["Ayah", "Ibu", "Anak"], (val) => _peranKeluarga = val),
                  _buildDropdown("Pendidikan Terakhir", _pendidikan, [
                    "SD",
                    "SMP",
                    "SMA",
                    "Diploma",
                    "Sarjana"
                  ], (val) => _pendidikan = val),
                  _buildDropdown("Pekerjaan", _pekerjaan, [
                    "Pelajar",
                    "Karyawan",
                    "Wiraswasta",
                    "Lainnya"
                  ], (val) => _pekerjaan = val),
                  _buildDropdown("Status", _status,
                      ["Menikah", "Belum Menikah"], (val) => _status = val),

                  const SizedBox(height: 24),

                  // TOMBOL
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Submit",
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: _resetForm,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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

  // Helper untuk input text
  Widget _buildTextField(String label, TextEditingController controller,
      {String? hint, TextInputType keyboard = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Helper untuk dropdown
  Widget _buildDropdown(String label, String? value, List<String> items,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: _inputDecoration("-- Pilih $label --"),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => onChanged(val)),
            validator: (val) => val == null ? "Pilih $label" : null,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}