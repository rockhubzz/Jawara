import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../services/keluarga_service.dart';
import '../services/warga_service.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({super.key});

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();

  final nama = TextEditingController();
  final nik = TextEditingController();

  String? jenisKelamin;
  String? statusDomisili;
  String? statusHidup;
  int? keluargaId;

  bool isLoading = false;
  List<Map<String, dynamic>> keluargaList = [];

  // Image picker for age detection
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool analyzing = false;

  static const Color kombu = Color(0xFF374426);
  static const Color bgSoft = Color(0xFFEFF4EC);

  @override
  void initState() {
    super.initState();
    loadKeluarga();
  }

  Future<void> loadKeluarga() async {
    keluargaList = await KeluargaService.getKeluarga();
    setState(() {});
  }

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() => _pickedImage = picked);
      }
    } catch (e) {
      // ignore errors
    }
  }

  Future<void> _analyzeImage() async {
    if (_pickedImage == null) return;

    setState(() => analyzing = true);

    try {
      final uri = Uri.parse(
        'https://raki46-faceage-detection.hf.space/predict',
      );

      final request = http.MultipartRequest('POST', uri);
      // many endpoints expect the file under 'file' or 'image' - use 'file'
      request.files.add(
        await http.MultipartFile.fromPath('image', _pickedImage!.path),
      );

      final streamed = await request.send();
      final respStr = await streamed.stream.bytesToString();

      final decoded = json.decode(respStr);

      Map<String, dynamic>? result;

      // If response directly contains keys
      if (decoded is Map &&
          decoded.containsKey('confidence') &&
          decoded.containsKey('predicted_age')) {
        result = Map<String, dynamic>.from(decoded);
      } else if (decoded is Map && decoded.containsKey('data')) {
        // Some services wrap results inside 'data' array
        final d = decoded['data'];
        if (d is List && d.isNotEmpty && d[0] is Map) {
          result = Map<String, dynamic>.from(d[0]);
        }
      }

      if (result != null &&
          result.containsKey('confidence') &&
          result.containsKey('predicted_age')) {
        final confRaw = result['confidence'];
        final pred = result['predicted_age'];
        final confNum = (confRaw is num)
            ? confRaw.toDouble()
            : double.tryParse(confRaw.toString()) ?? 0.0;
        final confPct = '${(confNum * 100).toStringAsFixed(1)}%';
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Hasil Deteksi Usia'),
            content: Text('Predicted age: $pred\nConfidence: $confPct'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Tidak ada hasil'),
            content: const Text('Tidak ditemukan hasil deteksi pada gambar.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Gagal melakukan analisis: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => analyzing = false);
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final body = {
      "nama": nama.text,
      "nik": nik.text,
      "keluarga_id": keluargaId.toString(),
      "jenis_kelamin": jenisKelamin,
      "status_domisili": statusDomisili,
      "status_hidup": statusHidup,
    };

    final ok = await WargaService.create(body);
    setState(() => isLoading = false);

    if (!mounted) return;

    if (ok) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Berhasil"),
          content: const Text("Tambah warga berhasil"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/data_warga_rumah/daftarWarga');
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: kombu),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: kombu, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSoft,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kombu),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
        title: const Text(
          "Tambah Warga",
          style: TextStyle(color: kombu, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Isi detail di bawah untuk menambahkan data warga",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 24),

                  DropdownButtonFormField<int>(
                    value: keluargaId,
                    decoration: _decoration("-- Pilih Keluarga --"),
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
                    decoration: _decoration("Nama Lengkap"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Nama wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: nik,
                    keyboardType: TextInputType.number,
                    decoration: _decoration("NIK"),
                    validator: (v) =>
                        v == null || v.length < 16 ? "NIK tidak valid" : null,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: jenisKelamin,
                    decoration: _decoration("Jenis Kelamin"),
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
                    validator: (v) => v == null ? "Pilih jenis kelamin" : null,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: statusDomisili,
                    decoration: _decoration("Status Domisili"),
                    items: const [
                      DropdownMenuItem(value: "Aktif", child: Text("Aktif")),
                      DropdownMenuItem(
                        value: "Tidak Aktif",
                        child: Text("Tidak Aktif"),
                      ),
                    ],
                    onChanged: (v) => setState(() => statusDomisili = v),
                    validator: (v) => v == null ? "Pilih status" : null,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: statusHidup,
                    decoration: _decoration("Status Hidup"),
                    items: const [
                      DropdownMenuItem(value: "Hidup", child: Text("Hidup")),
                      DropdownMenuItem(value: "Wafat", child: Text("Wafat")),
                    ],
                    onChanged: (v) => setState(() => statusHidup = v),
                    validator: (v) => v == null ? "Pilih status" : null,
                  ),
                  const SizedBox(height: 16),

                  // Image upload and analyze
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Foto Warga',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kombu,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: kombu),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: _pickedImage == null
                            ? IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: kombu,
                                ),
                                onPressed: _pickImage,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_pickedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Pilih Foto'),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: (_pickedImage == null || analyzing)
                                ? null
                                : _analyzeImage,
                            icon: analyzing
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.search),
                            label: const Text('Analisis Foto'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kombu,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: isLoading ? null : save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kombu,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 12,
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: kombu),
                        ),
                        child: const Text(
                          "Reset",
                          style: TextStyle(color: kombu),
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
    );
  }
}
