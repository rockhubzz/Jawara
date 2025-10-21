import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class KegiatanTambahPage extends StatelessWidget {
  const KegiatanTambahPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
      drawer: const AppDrawer(email: 'admin1@mail.com'),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Container(
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
                    const SizedBox(height: 20),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double width = constraints.maxWidth;
                        final bool isMobile = width < 700;

                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: isMobile
                                  ? double.infinity
                                  : (width / 2) - 16,
                              child: const _InputField(
                                label: "Nama Kegiatan",
                                icon: Icons.event_note_outlined,
                                hint: "Masukkan nama kegiatan...",
                              ),
                            ),
                            SizedBox(
                              width: isMobile
                                  ? double.infinity
                                  : (width / 2) - 16,
                              child: const _InputField(
                                label: "Kategori Kegiatan",
                                icon: Icons.category_outlined,
                                hint: "Masukkan kategori...",
                              ),
                            ),
                            SizedBox(
                              width: isMobile
                                  ? double.infinity
                                  : (width / 2) - 16,
                              child: const _InputField(
                                label: "Tanggal Kegiatan",
                                icon: Icons.date_range_outlined,
                                hint: "Pilih tanggal kegiatan...",
                              ),
                            ),
                            SizedBox(
                              width: isMobile
                                  ? double.infinity
                                  : (width / 2) - 16,
                              child: const _InputField(
                                label: "Lokasi Kegiatan",
                                icon: Icons.location_on_outlined,
                                hint: "Masukkan lokasi kegiatan...",
                              ),
                            ),
                            SizedBox(
                              width: isMobile
                                  ? double.infinity
                                  : (width / 2) - 16,
                              child: const _InputField(
                                label: "Penanggung Jawab",
                                icon: Icons.person_outline,
                                hint: "Masukkan nama penanggung jawab...",
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.centerRight,
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
                  ],
                ),
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
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        filled: true,
        fillColor: const Color(0xFFF9F9FF),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
