import 'package:flutter/material.dart';
import 'rumah_form_page.dart';
import 'package:jawara/services/rumah_service.dart';

class RumahDetailPage extends StatelessWidget {
  final Map<String, dynamic> rumah;

  const RumahDetailPage({super.key, required this.rumah});

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(rumah['kode'])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("No. Rumah", rumah['kode']),
            _row("Alamat", rumah['alamat']),
            _row("Status", rumah['status'] ?? "-"),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  child: const Text("Edit"),
                  onPressed: () async {
                    final res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RumahFormPage(data: rumah),
                      ),
                    );
                    if (res == true) Navigator.pop(context, true);
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Hapus Rumah?"),
                        content: const Text(
                          "Data akan dihapus secara permanen.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Hapus"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await RumahService.delete(rumah['id']);
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text("Hapus"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
