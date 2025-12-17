import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/kegiatan_service.dart';

class KegiatanTambahPage extends StatefulWidget {
  final int? id;

  const KegiatanTambahPage({super.key, this.id});

  @override
  State<KegiatanTambahPage> createState() => _KegiatanTambahPageState();
}

class _KegiatanTambahPageState extends State<KegiatanTambahPage> {
  final _formKey = GlobalKey<FormState>();
  final namaC = TextEditingController();
  final kategoriC = TextEditingController();
  final tanggalC = TextEditingController();
  final pjC = TextEditingController();
  final biayaC = TextEditingController();
  final lokasiC = TextEditingController();

  bool loading = false;
  late final bool isEdit = widget.id != null;

  final Color primaryGreen = const Color(0xFF2E7D32);

  final List<String> kategoriList = [
    'Sosial',
    'Acara',
    'Olahraga',
    'Pendidikan',
    'Keamanan',
    'Keuangan',
    'Lainnya',
  ];

  String? selectedKategori;

  @override
  void initState() {
    super.initState();
    if (isEdit) _loadDetail(widget.id!);
  }

  Future<void> _loadDetail(int id) async {
    setState(() => loading = true);
    final data = await KegiatanService.getById(id);
    setState(() {
      namaC.text = data['nama'] ?? '';
      kategoriC.text = data['kategori'] ?? '';
      selectedKategori = data['kategori'];
      tanggalC.text = data['tanggal'] ?? '';
      lokasiC.text = data['lokasi'] ?? '';
      pjC.text = data['penanggung_jawab'] ?? '';
      biayaC.text = data['biaya'] ?? '';
      loading = false;
    });
  }

  Future<void> _pickDate() async {
    DateTime initial = tanggalC.text.isNotEmpty
        ? DateTime.tryParse(tanggalC.text) ?? DateTime.now()
        : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      tanggalC.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final payload = {
      "nama": namaC.text,
      "kategori": kategoriC.text,
      "tanggal": tanggalC.text,
      "lokasi": lokasiC.text,
      "penanggung_jawab": pjC.text,
      "biaya": biayaC.text,
    };

    Map<String, dynamic> res;
    if (isEdit) {
      res = await KegiatanService.update(widget.id!, payload);
    } else {
      res = await KegiatanService.tambahKegiatan(payload);
    }

    setState(() => loading = false);

    if (res['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Kegiatan berhasil diperbarui'
                  : 'Kegiatan berhasil disimpan',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/kegiatan/daftar');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Gagal menyimpan data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final from =
        GoRouterState.of(context).uri.queryParameters['from'] ?? 'tambah';

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: primaryGreen,
          onPressed: () {
            if (from == 'tambah') {
              context.go('/beranda/tambah');
            } else {
              context.go('/beranda/semua_menu');
            }
          },
        ),
        title: Text(
          isEdit ? "Edit Kegiatan" : "Tambah Kegiatan",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 235, 188),
              Color.fromARGB(255, 181, 255, 183),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: loading && isEdit
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: _buildForm(context),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InputField(
              controller: namaC,
              label: "Nama Kegiatan",
              hint: "Masukkan nama kegiatan...",
              icon: Icons.event_note_outlined,
            ),
            const SizedBox(height: 14),

            // Dropdown kategori
            DropdownButtonFormField<String>(
              value: selectedKategori,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.category_outlined,
                    color: Color(0xFF2E7D32)),
                labelText: "Kategori",
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF2E7D32), width: 2.2),
                ),
              ),
              hint: const Text("Pilih kategori kegiatan"),
              items: kategoriList.map((kategori) {
                return DropdownMenuItem(
                  value: kategori,
                  child: Text(kategori),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedKategori = value;
                  kategoriC.text = value ?? '';
                });
              },
              validator: (value) =>
                  value == null || value.isEmpty ? 'Wajib dipilih' : null,
            ),

            const SizedBox(height: 14),
            _InputField(
              controller: tanggalC,
              label: "Tanggal",
              hint: "Pilih tanggal",
              icon: Icons.date_range_outlined,
              readOnly: true,
              onTap: _pickDate,
            ),
            const SizedBox(height: 14),
            _InputField(
              controller: lokasiC,
              label: "Lokasi",
              hint: "Masukkan lokasi kegiatan",
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 14),
            _InputField(
              controller: biayaC,
              label: "Biaya",
              hint: "Masukkan biaya kegiatan",
              icon: Icons.attach_money_outlined,
            ),
            const SizedBox(height: 14),
            _InputField(
              controller: pjC,
              label: "Penanggung Jawab",
              hint: "Masukkan penanggung jawab",
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: loading ? null : save,
                  child: Text(
                    loading
                        ? (isEdit ? "Memperbarui..." : "Menyimpan...")
                        : (isEdit ? "Update" : "Simpan"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool readOnly;
  final VoidCallback? onTap;

  const _InputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2.2),
        ),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
    );
  }
}
