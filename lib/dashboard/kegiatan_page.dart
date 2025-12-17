import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/appDrawer.dart';
import '../services/kegiatan_service.dart';

class KegiatanPage extends StatefulWidget {
  final String email;
  const KegiatanPage({super.key, required this.email});

  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  bool _isLoading = true;

  int total = 0;
  int sebelumHariIni = 0;
  int hariIni = 0;
  int setelahHariIni = 0;
  List<dynamic> kategoriList = [];
  bool _isLoadingKategori = true;
  List<dynamic> kegiatanPerBulan = [];
  bool _isLoadingBulan = true;

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
      final List<dynamic> result = await KegiatanService.countByKategori();

      setState(() {
        kategoriList = result;
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadKegiatanPerBulan() async {
    try {
      final List<dynamic> result =
          await KegiatanService.countKegiatanPerBulan();

      setState(() {
        kegiatanPerBulan = result;
        _isLoadingBulan = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  List<PieChartSectionData> _buildPieFromKategori() {
    if (kategoriList.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 100,
          title: '0%',
          radius: 50,
        ),
      ];
    }

    final double total = kategoriList.fold(0, (sum, item) {
      return sum + double.parse(item['total'].toString());
    });

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.red,
      Colors.indigo,
    ];

    return List.generate(kategoriList.length, (i) {
      final item = kategoriList[i];
      final value = double.parse(item['total'].toString());
      final percent = ((value / total) * 100).toStringAsFixed(0);

      return PieChartSectionData(
        color: colors[i % colors.length].withOpacity(0.7),
        value: value,
        title: '$percent%',
        radius: 50,
      );
    });
  }

  List<Widget> _buildKategoriLegends() {
    if (kategoriList.isEmpty) {
      return [_legend("Tidak ada data", Colors.grey)];
    }

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.red,
      Colors.indigo,
    ];

    return List.generate(kategoriList.length, (i) {
      final item = kategoriList[i];

      return _legend(item['kategori'].toString(), colors[i % colors.length]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5, // sedikit shadow biar elegant
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2E7D32)),
          onPressed: () => context.go('/beranda'),
        ),
        title: const Text(
          "Data Kegiatan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32), // warna khas Jawara
            fontSize: 20,
          ),
        ),
        centerTitle: false, // biar rata kiri seperti Jawara App
      ),

      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
            // ====== ROW CARD KECIL ======
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _dashboardSmallCard(
                  "Total Kegiatan",
                  _isLoading ? "..." : total.toString(),
                  Icons.event_available,
                  onTap: () => context.go('/kegiatan/daftar?when=all'),
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

            // ====== PIE CHART ======
            _dashboardBigCard(
              title: "Kegiatan per Kategori",
              icon: Icons.pie_chart,
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: Container(
                      color: Colors.transparent,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: _buildPieFromKategori(),
                          // transparan
                          borderData: FlBorderData(show: false),
                        ),
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

            // ====== BAR CHART ======
            _dashboardBigCard(
              title: "Kegiatan per Bulan (Tahun Ini)",
              icon: Icons.bar_chart,
              child: SizedBox(
                height: 260,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    backgroundColor: Colors.transparent,

                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.transparent,
                        tooltipPadding: EdgeInsets.zero,
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            rod.toY.toString(),
                            const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),

                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const months = [
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
                              'Nov',
                              'Des',
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < months.length) {}
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    barGroups: _isLoadingBulan
                        ? []
                        : kegiatanPerBulan.map((e) {
                            final int bulan = e['bulan'] + 1;
                            final double total = double.parse(
                              e['total'].toString(),
                            );

                            return BarChartGroupData(
                              x: bulan - 1, // because months start at index 0
                              barRods: [
                                BarChartRodData(
                                  toY: total,
                                  color: const Color(
                                    0xFF2E7D32,
                                  ).withOpacity(0.8),
                                  width: 18,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            );
                          }).toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ===================== COMPONENTS ========================

Widget _dashboardSmallCard(
  String title,
  String value,
  IconData icon, {
  VoidCallback? onTap,
}) {
  return SizedBox(
    width: 170,
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // color: Colors.white.withOpacity(0.9),
          color: Colors.white.withOpacity(0.9), // sedikit transparan
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Color(0xFF2E7D32)),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _dashboardBigCard({
  required String title,
  required IconData icon,
  required Widget child,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      // color: Colors.white.withOpacity(0.9),
      color: Colors.white.withOpacity(0.9), // sedikit transparan
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.3),
          blurRadius: 12,
          spreadRadius: 2,
          offset: Offset(0, 4),
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xFF2E7D32)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}

List<PieChartSectionData> _buildPieChartSections() {
  return [
    PieChartSectionData(
      color: Colors.blue.withOpacity(0.7),
      value: 25,
      title: "25%",
      radius: 50,
    ),
    PieChartSectionData(
      color: Colors.green.withOpacity(0.7),
      value: 20,
      title: "20%",
      radius: 50,
    ),
    PieChartSectionData(
      color: Colors.orange.withOpacity(0.7),
      value: 15,
      title: "15%",
      radius: 50,
    ),
    PieChartSectionData(
      color: Colors.purple.withOpacity(0.7),
      value: 10,
      title: "10%",
      radius: 50,
    ),
    PieChartSectionData(
      color: Colors.pink.withOpacity(0.7),
      value: 20,
      title: "20%",
      radius: 50,
    ),
    PieChartSectionData(
      color: Colors.teal.withOpacity(0.7),
      value: 10,
      title: "10%",
      radius: 50,
    ),
  ];
}

Widget _legend(String text, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(fontSize: 12)),
    ],
  );
}
