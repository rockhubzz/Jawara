// pages/kegiatan_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/kegiatan_service.dart';

class KegiatanPage extends StatefulWidget {
  final String email;
  const KegiatanPage({super.key, required this.email});

  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  bool _isLoading = true;
  bool _isLoadingBulan = true;

  int total = 0;
  int sebelumHariIni = 0;
  int hariIni = 0;
  int setelahHariIni = 0;

  List<dynamic> kategoriList = [];
  List<dynamic> kegiatanPerBulan = [];

  @override
  void initState() {
    super.initState();
    _loadGlance();
    _loadCountKategori();
    _loadKegiatanPerBulan();
  }

  Future<void> _loadGlance() async {
    try {
      final result = await KegiatanService.getGlance();
      if (result['success'] == true) {
        final data = result['data'];
        setState(() {
          total = int.parse(data['total'].toString());
          sebelumHariIni = int.parse(data['sebelum_hari_ini'].toString());
          hariIni = int.parse(data['hari_ini'].toString());
          setelahHariIni = int.parse(data['setelah_hari_ini'].toString());
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCountKategori() async {
    try {
      kategoriList = await KegiatanService.countByKategori();
      setState(() {});
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _loadKegiatanPerBulan() async {
    try {
      kegiatanPerBulan = await KegiatanService.countKegiatanPerBulan();
      setState(() => _isLoadingBulan = false);
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => _isLoadingBulan = false);
    }
  }

  List<PieChartSectionData> _buildPieFromKategori() {
    if (kategoriList.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey.shade400,
          value: 100,
          title: '0%',
          radius: 55,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ];
    }

    final totalValue = kategoriList.fold<double>(
        0, (sum, item) => sum + double.parse(item['total'].toString()));

    final colors = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
      Colors.tealAccent,
      Colors.redAccent,
      Colors.indigoAccent,
    ];

    return List.generate(kategoriList.length, (i) {
      final value = double.parse(kategoriList[i]['total'].toString());
      final percent = ((value / totalValue) * 100).toStringAsFixed(0);

      return PieChartSectionData(
        color: colors[i % colors.length].withOpacity(0.85),
        value: value,
        title: '$percent%',
        radius: 55,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });
  }

  List<Widget> _buildKategoriLegends() {
    if (kategoriList.isEmpty) {
      return [_legend("Tidak ada data", Colors.grey)];
    }

    final colors = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
      Colors.tealAccent,
      Colors.redAccent,
      Colors.indigoAccent,
    ];

    return List.generate(kategoriList.length, (i) {
      return _legend(
        kategoriList[i]['kategori'].toString(),
        colors[i % colors.length],
      );
    });
  }

  double _getMaxY() {
    if (kegiatanPerBulan.isEmpty) return 5;
    final max = kegiatanPerBulan
        .map((e) => double.parse(e['total'].toString()))
        .reduce((a, b) => a > b ? a : b);
    return (max * 1.2).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2E7D32)),
          onPressed: () => context.go('/beranda'),
        ),
        title: const Text(
          "Data Kegiatan",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF2E7D32), fontSize: 20),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 235, 188),
            Color.fromARGB(255, 181, 255, 183),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _dashboardSmallCard(
                  "Total Kegiatan",
                  _isLoading ? "..." : total.toString(),
                  Icons.event,
                  onTap: () => context.go('/kegiatan/daftar'),
                ),
                _dashboardSmallCard(
                  "Sudah Lewat",
                  _isLoading ? "..." : sebelumHariIni.toString(),
                  Icons.history,
                  onTap: () => context.go('/kegiatan/daftar?when=overdue'),
                ),
                _dashboardSmallCard(
                  "Hari Ini",
                  _isLoading ? "..." : hariIni.toString(),
                  Icons.today,
                  onTap: () => context.go('/kegiatan/daftar?when=today'),
                ),
                _dashboardSmallCard(
                  "Akan Datang",
                  _isLoading ? "..." : setelahHariIni.toString(),
                  Icons.upcoming,
                  onTap: () => context.go('/kegiatan/daftar?when=upcoming'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _dashboardBigCard(
              title: "Kegiatan per Kategori",
              icon: Icons.pie_chart,
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _buildPieFromKategori(),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: _buildKategoriLegends(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _dashboardBigCard(
              title: "Kegiatan per Bulan (Tahun Ini)",
              icon: Icons.bar_chart,
              child: SizedBox(
                height: 260,
                child: _isLoadingBulan
                    ? const Center(child: CircularProgressIndicator())
                    : BarChart(
                        BarChartData(
                          maxY: _getMaxY(),
                          alignment: BarChartAlignment.spaceAround,
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 1,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            ),
                          ),
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 1,
                                getTitlesWidget: (value, meta) => Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
                                  int idx = value.toInt();
                                  if (idx >= 0 && idx < months.length) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(months[idx], style: const TextStyle(fontSize: 12)),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                          barGroups: List.generate(12, (i) {
                            final bulanData = kegiatanPerBulan.firstWhere(
                              (e) => e['bulan'] == i + 1,
                              orElse: () => {'total': 0},
                            );
                            final total = double.tryParse(bulanData['total'].toString()) ?? 0;
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: total,
                                  color: const Color(0xFF2E7D32),
                                  width: 18,
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
        ),
      ),
    );
  }
}

// ================= COMPONENTS =================
Widget _dashboardSmallCard(String title, String value, IconData icon, {VoidCallback? onTap}) {
  return SizedBox(
    width: 170,
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: const Color(0xFF2E7D32)),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    ),
  );
}

Widget _dashboardBigCard({required String title, required IconData icon, required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF2E7D32)),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}

Widget _legend(String text, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(fontSize: 12)),
    ],
  );
}
