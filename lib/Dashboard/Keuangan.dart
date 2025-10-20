import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../widgets/appDrawer.dart';

class Keuangan extends StatelessWidget {
  const Keuangan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          "Data Keuangan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= INFO CARD =================
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 700 ? 3 : 1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 2.3,
              children: [
                _infoCard(
                  title: "Total Pemasukan",
                  icon: Icons.account_balance_wallet_outlined,
                  color: const Color(0xFFDCE8FA),
                  value: "50 jt",
                  textColor: Colors.blue[800]!,
                ),
                _infoCard(
                  title: "Total Pengeluaran",
                  icon: Icons.money_off_outlined,
                  color: const Color(0xFFDFF6DD),
                  value: "2.1 rb",
                  textColor: Colors.green[700]!,
                ),
                _infoCard(
                  title: "Jumlah Transaksi",
                  icon: Icons.receipt_long_outlined,
                  color: const Color(0xFFFFF4CC),
                  value: "5",
                  textColor: Colors.brown[700]!,
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ================= BAR CHART (atas) =================
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 700 ? 2 : 1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.4,
              children: [
                _chartCardBar(
                  title: "Pemasukan per Bulan",
                  color: const Color(0xFFF5EFFF),
                  barColor: Colors.lightBlueAccent,
                  data: [FlSpot(0, 10), FlSpot(1, 45)],
                  bottomLabels: const ["Agu", "Okt"],
                  leftTitle: "jt",
                ),
                _chartCardBar(
                  title: "Pengeluaran per Bulan",
                  color: const Color(0xFFFFEBEE),
                  barColor: Colors.redAccent,
                  data: [FlSpot(1, 2.2)],
                  bottomLabels: const ["Okt"],
                  leftTitle: "rb",
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ================= PIE CHART (bawah) =================
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 700 ? 2 : 1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.4,
              children: [
                _chartCard(
                  title: "Pemasukan Berdasarkan Kategori",
                  icon: Icons.trending_up_rounded,
                  color: const Color(0xFFDCE8FA),
                  sections: [
                    PieChartSectionData(
                      value: 99,
                      color: Colors.blueAccent,
                      title: "100%",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 1,
                      color: Colors.orangeAccent,
                      title: "0%",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  legends: const [
                    {
                      "label": "Dana Bantuan Pemerintah",
                      "color": Colors.blueAccent,
                    },
                    {
                      "label": "Pendapatan Lainnya",
                      "color": Colors.orangeAccent,
                    },
                  ],
                ),
                _chartCard(
                  title: "Pengeluaran Berdasarkan Kategori",
                  icon: Icons.trending_down_rounded,
                  color: const Color(0xFFDFF6DD),
                  sections: [
                    PieChartSectionData(
                      value: 99,
                      color: Colors.pinkAccent,
                      title: "100%",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 1,
                      color: Colors.amberAccent,
                      title: "0%",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  legends: const [
                    {
                      "label": "Pemeliharaan Fasilitas",
                      "color": Colors.pinkAccent,
                    },
                    {"label": "Operasional RT/RW", "color": Colors.amberAccent},
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== INFO CARD =====================
Widget _infoCard({
  required String title,
  required IconData icon,
  required Color color,
  required String value,
  required Color textColor,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: textColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ===================== PIE CHART CARD (dengan Wrap legend) =====================
Widget _chartCard({
  required String title,
  required IconData icon,
  required Color color,
  required List<PieChartSectionData> sections,
  List<Map<String, dynamic>> legends = const [],
}) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 35,
              sectionsSpace: 2,
            ),
          ),
        ),
        if (legends.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: legends
                .map(
                  (legend) => _legend(
                    legend["label"] as String,
                    legend["color"] as Color,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    ),
  );
}

Widget _legend(String text, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 12, height: 12, color: color),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(fontSize: 12)),
    ],
  );
}

// ===================== BAR CHART CARD =====================
Widget _chartCardBar({
  required String title,
  required Color color,
  required Color barColor,
  required List<FlSpot> data,
  required List<String> bottomLabels,
  required String leftTitle,
}) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.show_chart, size: 16, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: title.contains("Pengeluaran")
                    ? Colors.red[800]
                    : Colors.blue[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      "${value.toStringAsFixed(0)} $leftTitle",
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      return Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          index < bottomLabels.length
                              ? bottomLabels[index]
                              : "",
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: data
                  .asMap()
                  .entries
                  .map(
                    (e) => BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.y,
                          color: barColor,
                          width: 35,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    ),
  );
}
