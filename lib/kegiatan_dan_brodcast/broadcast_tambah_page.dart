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
  late final bool isEdit = widget.id != null;

  final Color primaryGreen = const Color(0xFF2E7D32);
  final Color bgSoft = const Color(0xFFEFF4EC);

  @override
  void initState() {
    super.initState();
    if (isEdit) _loadDetail(widget.id!);
  }

  Future<void> _loadDetail(int id) async {
    setState(() => loading = true);
    final data = await BroadcastService.getById(id);
    setState(() {
      titleC.text = data['data']?['title'] ?? '';
      bodyC.text = data['data']?['body'] ?? '';
      senderC.text = data['data']?['sender'] ?? '';
      dateC.text = data['data']?['date'] ?? '';
      loading = false;
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
      dateC.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
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
    if (isEdit) {
      res = await BroadcastService.update(widget.id!, payload);
    } else {
      res = await BroadcastService.create(payload);
    }

    setState(() => loading = false);

    if (res['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Broadcast berhasil diperbarui'
                  : 'Broadcast berhasil disimpan',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/kegiatan/daftar_broad');
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
      backgroundColor: bgSoft, // Background hijau soft
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryGreen),
          onPressed: () {
            if (from == 'tambah') {
              context.go('/beranda/tambah');
            } else {
              context.go('/beranda/semua_menu');
            }
          },
        ),
        title: Text(
          isEdit ? "Edit Broadcast" : "Tambah Broadcast",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryGreen,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
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
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Card tetap putih
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
        fillColor: Colors.white, // Input field putih
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

class _TextAreaField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _TextAreaField({
    super.keyt,
    required his.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white, // Input field putih
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
