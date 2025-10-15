import 'package:flutter/material.dart';

class AddKegiatanPage extends StatelessWidget {
  const AddKegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kegiatan"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24, top: 16),
        child: _templateGrid(
          context: context,
          title: "Kegiatan Baru Nich",
          items: [
            _featureCard("Nama kegiatan", Icons.tag_faces_outlined),
            _featureCard("Kategori kegiatan", Icons.category_outlined),
            _featureCard("Tanggal kegiatan", Icons.date_range_outlined),
            _featureCard("Lokasi kegiatan", Icons.location_on_outlined),
            _featureCard("Penanggung jawab", Icons.person_outline),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Kegiatan berhasil disimpan!"),
              backgroundColor: Colors.green,
            ),
          );
        },
        icon: const Icon(Icons.check_circle_outline),
        label: const Text("Simpan"),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}

// --- Template Grid ---
Widget _templateGrid({
  required BuildContext context,
  required String title,
  required List<Widget> items,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final crossAxisCount = screenWidth > 1000
      ? 3
      : screenWidth > 600
      ? 2
      : 1;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: (constraints.maxWidth / crossAxisCount) / 160,
              ),
              itemBuilder: (context, index) => items[index],
            );
          },
        ),
      ],
    ),
  );
}

// --- Feature Card ---
Widget _featureCard(String title, IconData icon) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    width: double.infinity,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Masukkan $title...",
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
