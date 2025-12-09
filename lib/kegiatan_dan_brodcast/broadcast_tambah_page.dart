import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/broadcast_service.dart';

class BroadcastFormPage extends StatefulWidget {
  final int? id;

  const BroadcastFormPage({super.key, this.id});

  @override
  State<BroadcastFormPage> createState() => _BroadcastFormPageState();
}

class _BroadcastFormPageState extends State<BroadcastFormPage> {
  final _formKey = GlobalKey<FormState>();
  final titleC = TextEditingController();
  final bodyC = TextEditingController();
  final senderC = TextEditingController();
  final dateC = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) _loadDetail(widget.id!);
  }

  Future<void> _loadDetail(int id) async {
    final data = await BroadcastService.getById(id);
    setState(() {
      titleC.text = data['data']?['title'] ?? '';
      bodyC.text = data['data']?['body'] ?? '';
      senderC.text = data['data']?['sender'] ?? '';
      dateC.text = data['data']?['date'] ?? '';
    });
  }

  Future<void> _pickDate() async {
    DateTime initial = dateC.text.isNotEmpty
        ? DateTime.tryParse(dateC.text) ?? DateTime.now()
        : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      dateC.text = picked.toIso8601String().split('T').first;
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    final payload = {
      "title": titleC.text,
      "body": bodyC.text,
      "sender": senderC.text,
      "date": dateC.text,
    };

    Map<String, dynamic> res;
    if (widget.id == null) {
      res = await BroadcastService.create(payload);
    } else {
      res = await BroadcastService.update(widget.id!, payload);
    }

    setState(() => loading = false);

    if (res['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/kegiatan/daftar_broad');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Gagal')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.id != null;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity, // pastikan menutupi seluruh layar
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 235, 188), // krem
              Color.fromARGB(255, 181, 255, 183), // hijau
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => context.go('/kegiatan/daftar_broad'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEdit ? "Edit Broadcast" : "Tambah Broadcast",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Card utama
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 255, 204),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InputField(
                          controller: titleC,
                          label: "Judul Broadcast",
                          hint: "Masukkan judul broadcast...",
                          icon: Icons.campaign_outlined,
                        ),
                        const SizedBox(height: 14),
                        _TextAreaField(
                          controller: bodyC,
                          label: "Isi Broadcast",
                          hint: "Tulis isi broadcast di sini...",
                          icon: Icons.edit_note_outlined,
                        ),
                        const SizedBox(height: 14),
                        _InputField(
                          controller: senderC,
                          label: "Pengirim",
                          hint: "Masukkan pengirim",
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 14),
                        _InputField(
                          controller: dateC,
                          label: "Tanggal",
                          hint: "Pilih tanggal",
                          icon: Icons.date_range_outlined,
                          readOnly: true,
                          onTap: _pickDate,
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:const Color(0xFFBC6C25), 
                                foregroundColor: Colors.white,
                              ),
                              onPressed: loading ? null : save,
                              child: Text(
                                loading
                                    ? 'Menyimpan...'
                                    : isEdit
                                        ? 'Update'
                                        : 'Simpan',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable Input Field
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
      cursorColor: const Color(0xFFBC6C25),
      decoration: _inputDecoration(label, hint, icon),
      validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
    );
  }
}

class _TextAreaField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _TextAreaField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      cursorColor: const Color(0xFFBC6C25),
      decoration: _inputDecoration(label, hint, icon),
      validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
    );
  }
}

InputDecoration _inputDecoration(String label, String hint, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: Color(0xFFBC6C25)),
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xFFBC6C25)),
    floatingLabelStyle: const TextStyle(color: Color(0xFFBC6C25)),
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFBC6C25), width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFBC6C25), width: 2.2),
    ),
  );
}

