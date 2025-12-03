import 'package:flutter/material.dart';
import '../../services/keluarga_service.dart';
import '../../services/warga_service.dart';

class WargaAddPage extends StatefulWidget {
  final int? wargaId; // null = create, not null = edit

  const WargaAddPage({super.key, this.wargaId});

  @override
  State<WargaAddPage> createState() => _WargaAddPageState();
}

class _WargaAddPageState extends State<WargaAddPage> {
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
    final body = {
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
      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          widget.wargaId == null
              ? "Tambah Warga"
              : "Edit Warga #${widget.wargaId}",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nama,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: nik,
              decoration: const InputDecoration(labelText: "NIK"),
            ),

            dropdown("Jenis Kelamin", jenisKelamin, [
              "Laki-laki",
              "Perempuan",
            ], (v) => setState(() => jenisKelamin = v)),

            dropdown(
              "Status Domisili",
              statusDomisili,
              ["Aktif", "Tidak Aktif"],
              (v) => setState(() => statusDomisili = v),
            ),

            dropdown("Status Hidup", statusHidup, [
              "Hidup",
              "Wafat",
            ], (v) => setState(() => statusHidup = v)),

            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Keluarga"),
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
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: save,
              child: Text(widget.wargaId == null ? "Simpan" : "Update"),
            ),
          ],
        ),
      ),
    );
  }
}
