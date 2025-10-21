import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/widgets/appDrawer.dart';

class TagihIuranPage extends StatefulWidget {
  const TagihIuranPage({super.key});

  @override
  State<TagihIuranPage> createState() => _TagihIuranPageState();
}

class _TagihIuranPageState extends State<TagihIuranPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk tanggal
  final _tanggalController = TextEditingController();

  String? selectedIuran;

  final List<String> jenisIuranList = [
    "Iuran Kebersihan",
    "Iuran Keamanan",
    "Iuran Pembangunan",
    "Iuran Sosial",
  ];

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      selectedIuran = null;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tagihan berhasil dikirim ke semua keluarga aktif!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Fungsi pilih tanggal
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _tanggalController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Tagih Iuran", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      // Drawer untuk sidebar
      drawer: AppDrawer(email: 'admin1@mail.com'),

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
                    "Tagih iuran ke Semua Keluarga Aktif",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Jenis Iuran",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: "-- Pilih Iuran --",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    value: selectedIuran,
                    items: jenisIuranList.map((iuran) {
                      return DropdownMenuItem(value: iuran, child: Text(iuran));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedIuran = value;
                      });
                    },
                    validator: (value) => value == null
                        ? 'Pilih jenis iuran terlebih dahulu'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Tanggal Tagihan",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Pilih tanggal tagihan'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Tagih Iuran",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: _resetForm,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
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
}
