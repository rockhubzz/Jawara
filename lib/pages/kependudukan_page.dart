import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class KependudukanPage extends StatelessWidget {
  const KependudukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Data Kependudukan"),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GRID CARD KECIL (INFO TOTAL) ---
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 700 ? 2 : 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5, // 💡 kartu kecil & melebar
              children: [
                _infoCard(
                  title: "Total Keluarga",
                  icon: Icons.house_rounded,
                  color: const Color(0xFFDCE8FA),
                  value: "4",
                ),
                _infoCard(
                  title: "Total Penduduk",
                  icon: Icons.people_alt_rounded,
                  color: const Color(0xFFDFF6DD),
                  value: "6",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- GRID CARD BESAR (CHART) ---
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 1000
                  ? 3
                  : MediaQuery.of(context).size.width > 700
                      ? 2
                      : 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                _chartCard(
                  title: "Status Penduduk",
                  icon: Icons.verified_user_rounded,
                  color: const Color(0xFFFFF5D9),
                  sections: [
                    PieChartSectionData(
                      value: 100,
                      color: Colors.green,
                      title: "Aktif",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _chartCard(
                  title: "Jenis Kelamin",
                  icon: Icons.wc_rounded,
                  color: const Color(0xFFF3E5F5),
                  sections: [
                    PieChartSectionData(
                      value: 60,
                      color: Colors.blue,
                      title: "L",
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 40,
                      color: Colors.pinkAccent,
                      title: "P",
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                _chartCard(
                  title: "Pekerjaan Penduduk",
                  icon: Icons.work_rounded,
                  color: const Color(0xFFFFF0E6),
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      color: Colors.brown,
                      title: "Petani",
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 25,
                      color: Colors.teal,
                      title: "Pedagang",
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.deepPurple,
                      title: "Guru",
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 15,
                      color: Colors.orange,
                      title: "Lainnya",
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                _chartCard(
                  title: "Peran dalam Keluarga",
                  icon: Icons.family_restroom_rounded,
                  color: const Color(0xFFD9F1FF),
                  sections: [
                    PieChartSectionData(value: 50, color: Colors.blue, title: "KK", titleStyle: const TextStyle(color: Colors.white)),
                    PieChartSectionData(value: 30, color: Colors.redAccent, title: "Istri", titleStyle: const TextStyle(color: Colors.white)),
                    PieChartSectionData(value: 20, color: Colors.green, title: "Anak", titleStyle: const TextStyle(color: Colors.white)),
                  ],
                ),
                _chartCard(
                  title: "Agama",
                  icon: Icons.church_rounded,
                  color: const Color(0xFFFFE7E7),
                  sections: [
                    PieChartSectionData(value: 60, color: Colors.orange, title: "Islam", titleStyle: const TextStyle(color: Colors.white)),
                    PieChartSectionData(value: 40, color: Colors.blue, title: "Lainnya", titleStyle: const TextStyle(color: Colors.white)),
                  ],
                ),
                _chartCard(
                  title: "Pendidikan",
                  icon: Icons.school_rounded,
                  color: const Color(0xFFE0F7F3),
                  sections: [
                    PieChartSectionData(value: 40, color: Colors.grey, title: "SD", titleStyle: const TextStyle(color: Colors.white)),
                    PieChartSectionData(value: 30, color: Colors.blueGrey, title: "SMP", titleStyle: const TextStyle(color: Colors.white)),
                    PieChartSectionData(value: 30, color: Colors.indigo, title: "SMA", titleStyle: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- CARD UNTUK ANGKA ---
  Widget _infoCard({
    required String title,
    required IconData icon,
    required Color color,
    required String value,
  }) {
    return Card(
      color: color,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CARD UNTUK CHART ---
  Widget _chartCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<PieChartSectionData> sections,
  }) {
    return Card(
      color: color,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                  borderData: FlBorderData(show: false),
                  sections: sections,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
