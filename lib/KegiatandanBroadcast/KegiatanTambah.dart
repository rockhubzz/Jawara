import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class KegiatanTambahPage extends StatelessWidget {
  const KegiatanTambahPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Tambah Kegiatan",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: AppDrawer(email: 'admin1@mail.com'),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Form Kegiatan Baru",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6C63FF),
                    ),
                  ),

                  // ✅ Tambah jarak dari judul ke form
                  const SizedBox(height: 16),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = width > 1000
                          ? 3
                          : width > 700
                              ? 2
                              : 1;

                      return GridView.count(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 0, // tetap rapat antarbaris
                        childAspectRatio: 3.5,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          _InputField(
                            label: "Nama Kegiatan",
                            icon: Icons.event_note_outlined,
                            hint: "Masukkan nama kegiatan...",
                          ),
                          _InputField(
                            label: "Kategori Kegiatan",
                            icon: Icons.category_outlined,
                            hint: "Masukkan kategori...",
                          ),
                          _InputField(
                            label: "Tanggal Kegiatan",
                            icon: Icons.date_range_outlined,
                            hint: "Pilih tanggal kegiatan...",
                          ),
                          _InputField(
                            label: "Lokasi Kegiatan",
                            icon: Icons.location_on_outlined,
                            hint: "Masukkan lokasi kegiatan...",
                          ),
                          _InputField(
                            label: "Penanggung Jawab",
                            icon: Icons.person_outline,
                            hint: "Masukkan nama penanggung jawab...",
                          ),
                        ],
                      );
                    },
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Kegiatan berhasil disimpan!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text(
                          "Simpan",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 26, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 1,
                        ),
                      ),
                    ),
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

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;

  const _InputField({
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFF6C63FF)),
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        filled: true,
        fillColor: const Color(0xFFF9F9FF),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Color(0xFFDADAF0), width: 1.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
        ),
      ),
    );
  }
}
