import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class BuatMutasiKeluargaPage extends StatefulWidget {
  const BuatMutasiKeluargaPage({super.key});

  @override
  State<BuatMutasiKeluargaPage> createState() => _BuatMutasiKeluargaPageState();
}

class _BuatMutasiKeluargaPageState extends State<BuatMutasiKeluargaPage> {
  String? selectedJenisMutasi;
  String? selectedKeluarga;
  DateTime? selectedDate;
  final alasanController = TextEditingController();

  final List<String> jenisMutasiList = [
    'Pindah Domisili',
    'Perubahan Status',
    'Kematian',
    'Lainnya',
  ];

  final List<String> keluargaList = ['Keluarga A', 'Keluarga B', 'Keluarga C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Buat Mutasi Keluarga',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: Container(
          width: 600,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Jenis Mutasi
                const Text(
                  'Jenis Mutasi',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedJenisMutasi,
                  hint: const Text('-- Pilih Jenis Mutasi --'),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: jenisMutasiList
                      .map(
                        (jenis) =>
                            DropdownMenuItem(value: jenis, child: Text(jenis)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedJenisMutasi = value);
                  },
                ),
                const SizedBox(height: 16),

                // Keluarga
                const Text(
                  'Keluarga',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedKeluarga,
                  hint: const Text('-- Pilih Keluarga --'),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: keluargaList
                      .map(
                        (kel) => DropdownMenuItem(value: kel, child: Text(kel)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedKeluarga = value);
                  },
                ),
                const SizedBox(height: 16),

                // Alasan Mutasi
                const Text(
                  'Alasan Mutasi',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: alasanController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Masukkan alasan disini...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tanggal Mutasi
                const Text(
                  'Tanggal Mutasi',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            selectedDate == null
                                ? '--/--/----'
                                : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => setState(() => selectedDate = null),
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF635BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: _resetForm,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  void _saveForm() {
    // Handle save logic here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Data berhasil disimpan!')));
  }

  void _resetForm() {
    setState(() {
      selectedJenisMutasi = null;
      selectedKeluarga = null;
      alasanController.clear();
      selectedDate = null;
    });
  }
}
