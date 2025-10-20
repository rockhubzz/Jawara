import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/appDrawer.dart';

class HomePage extends StatefulWidget {
  final String email;
  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      drawer: AppDrawer(email: widget.email),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _dashboardLayout(context),
      ),
    );
  }
}

// --- Dashboard ---
Widget _dashboardLayout(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      bool isWide = constraints.maxWidth > 800;
      return GridView.count(
        crossAxisCount: isWide ? 2 : 1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: isWide ? 1.8 : 1.4,
        children: [
          _infoCard(
            context: context,
            title: "Total Kegiatan",
            emoji: "🎉",
            color: Colors.blue[100]!,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "1",
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Jumlah seluruh event yang sudah ada",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          _infoCard(
            context: context,
            title: "Kegiatan per Kategori",
            emoji: "📁",
            color: Colors.green[100]!,
            content: Column(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _buildPieChartSections(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: [
                    _legend("Komunitas & Sosial", Colors.blue),
                    _legend("Kebersihan & Keamanan", Colors.green),
                    _legend("Keagamaan", Colors.orange),
                    _legend("Pendidikan", Colors.purple),
                    _legend("Kesehatan & Olahraga", Colors.pink),
                    _legend("Lainnya", Colors.lightBlue),
                  ],
                ),
              ],
            ),
          ),
          _infoCard(
            context: context,
            title: "Kegiatan berdasarkan Waktu",
            emoji: "⏰",
            color: Colors.yellow[100]!,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Sudah Lewat: 1", style: TextStyle(fontSize: 16)),
                Text("Hari Ini: 0", style: TextStyle(fontSize: 16)),
                Text("Akan Datang: 0", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          _infoCard(
            context: context,
            title: "Penanggung Jawab Terbanyak",
            emoji: "🧑‍💼",
            color: Colors.purple[100]!,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Pak Agus", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: 1,
                  color: Colors.purple,
                  backgroundColor: Colors.purple[200],
                ),
              ],
            ),
          ),
          _infoCard(
            context: context,
            title: "Kegiatan per Bulan (Tahun Ini)",
            emoji: "📅",
            color: Colors.pink[50]!,
            content: SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'Mei',
                            'Jun',
                            'Jul',
                            'Agu',
                            'Sep',
                            'Okt',
                          ];
                          if (value.toInt() >= 0 &&
                              value.toInt() < months.length) {
                            return Text(months[value.toInt()]);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(10, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: (i == 9) ? 1 : 0.4 + (i * 0.05),
                          color: Colors.pinkAccent,
                          width: 16,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// --- Info Card ---
Widget _infoCard({
  required BuildContext context,
  required String title,
  required String emoji,
  required Color color,
  required Widget content,
}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row header: emoji + title + optional small action button (safe to place inside Row)
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // small button untuk keuangan (digunakan sebagai contoh, bisa dihapus)
              // navigator dipanggil setelah drawer ditutup agar tidak error
              // TextButton.icon(
              //   onPressed: () {
              //     // tutup drawer dulu (jika ada), lalu navigasi
              //     // Navigator.pop(context);
              //     WidgetsBinding.instance.addPostFrameCallback((_) {
              //       context.go('/keuangan');
              //     });
              //   },
              //   icon: const Icon(Icons.account_balance_wallet, size: 18),
              //   label: const Text('Keuangan'),
              //   style: TextButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 12,
              //       vertical: 8,
              //     ),
              //   ),
              // ),
            ],
          ),

          const SizedBox(height: 16),
          Expanded(child: content),
        ],
      ),
    ),
  );
}

List<PieChartSectionData> _buildPieChartSections() {
  return [
    PieChartSectionData(
      color: Colors.blue,
      value: 100,
      title: "100%",
      radius: 50,
    ),
  ];
}

Widget _legend(String label, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 12, height: 12, color: color),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}
