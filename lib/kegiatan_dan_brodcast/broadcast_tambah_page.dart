// lib/pages/broadcast_form_page.dart
import 'package:flutter/material.dart';
import '../services/broadcast_service.dart';
import 'package:go_router/go_router.dart';

class BroadcastFormPage extends StatefulWidget {
  final int? id; // null = tambah, not null = edit

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
    if (widget.id != null) {
      _loadDetail(widget.id!);
    }
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
    // Jika dateC sudah terisi dari initState, gunakan itu
    DateTime initial = DateTime.now();

    if (dateC.text.isNotEmpty) {
      try {
        initial = DateTime.parse(dateC.text);
      } catch (_) {
        // Abaikan jika parsing gagal, tetap gunakan DateTime.now()
      }
    }

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Gagal')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Broadcast' : 'Tambah Broadcast'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: senderC,
                decoration: const InputDecoration(labelText: 'Pengirim'),
              ),
              TextFormField(
                controller: titleC,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (v) => v == null || v.isEmpty ? 'Wajib' : null,
              ),
              TextFormField(
                controller: bodyC,
                decoration: const InputDecoration(labelText: 'Isi'),
                maxLines: 4,
              ),
              TextFormField(
                controller: dateC,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(labelText: 'Tanggal'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading ? null : save,
                child: Text(loading ? 'Menyimpan...' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
