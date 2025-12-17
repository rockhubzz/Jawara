import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../services/keuangan_service.dart';

class KeuanganPage extends StatefulWidget {
  const KeuanganPage({super.key});

  @override
  State<KeuanganPage> createState() => _KeuanganPageState();
}

class _KeuanganPageState extends State<KeuanganPage> {
  bool loading = true;

  int pemasukanLain = 0;
  int iuran = 0;
  int pengeluaran = 0;
  int saldo = 0;

  List<FlSpot> pemasukanSpots = [];
  List<FlSpot> pengeluaranSpots = [];
  List<String> bulanLabels = [];

  @override
  void initState() {
    super.initState();
    _loadGlance();
  }

  Future<void> _loadGlance() async {
    try {
      final glance = await KeuanganService.getGlance();
      final rekap = await KeuanganService.getRekapBulanan();

      pemasukanLain = int.parse(glance['pemasukan_lain'].toString());
      iuran = int.parse(glance['iuran'].toString());
      pengeluaran = int.parse(glance['pengeluaran'].toString());
      saldo = int.parse(glance['saldo'].toString());

      final List list = rekap['data'];

      pemasukanSpots.clear();
      pengeluaranSpots.clear();
      bulanLabels.clear();

      for (int i = 0; i < list.length; i++) {
        final item = list[i];

        final pemasukan = double.parse(item['total_pemasukan'].toString());
        final pengeluaranVal = double.parse(
          item['total_pengeluaran'].toString(),
        );

        bulanLabels.add(item['bulan'].substring(5));
        pemasukanSpots.add(FlSpot(i.toDouble(), pemasukan));
        pengeluaranSpots.add(FlSpot(i.toDouble(), pengeluaranVal));
      }

      setState(() => loading = false);
    } catch (e) {
      debugPrint("ERROR: $e");
      setState(() => loading = false);
    }
  }

  String formatRupiah(int value) {
    return "Rp ${value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}";
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
          "Data Keuangan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
            fontSize: 20,
          ),
        ),
      ),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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
            // =================== SMALL CARDS ===================
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ), // jarak kiri-kanan
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _dashboardSmallCard(
                    context,
                    "Total Pemasukan",
                    loading ? "..." : formatRupiah(pemasukanLain + iuran),
                    Icons.account_balance_wallet_outlined,
                    route: '/laporan_keuangan/semua_pemasukan',
                  ),
                  _dashboardSmallCard(
                    context,
                    "Total Pengeluaran",
                    loading ? "..." : formatRupiah(pengeluaran),
                    Icons.money_off_outlined,
                    route: '/laporan_keuangan/semua_pengeluaran',
                  ),
                  _dashboardSmallCard(
                    context,
                    "Saldo Akhir",
                    loading ? "..." : formatRupiah(saldo),
                    Icons.savings_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =================== CHART ===================
            _dashboardBigCard(
              title: "Grafik Pemasukan & Pengeluaran",
              icon: Icons.show_chart,
              child: SizedBox(
                height: 240,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),

                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          getTitlesWidget: (value, _) {
                            // Bulatkan ke jutaan terdekat untuk tampilan y-axis
                            int roundedValue =
                                (value / 1000000).round() * 1000000;

                            return Text(
                              roundedValue.toString().replaceAllMapped(
                                RegExp(r'\B(?=(\d{3})+(?!\d))'),
                                (match) => '.',
                              ),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            if (value.toInt() < bulanLabels.length) {
                              return Text(
                                bulanLabels[value.toInt()], // Jan, Feb, Mar
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),

                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: const Color(0xFF2E7D32),
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        spots: pemasukanSpots,
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF2E7D32).withOpacity(0.2),
                        ),
                      ),
                      LineChartBarData(
                        isCurved: true,
                        color: Colors.red[700],
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        spots: pengeluaranSpots,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.red[700]!.withOpacity(0.2),
                        ),
                      ),
                    ],
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

// ======================================================
// ===============  COMPONENTS ===
// ======================================================

Widget _dashboardSmallCard(
  BuildContext context,
  String title,
  String value,
  IconData icon, {
  String? route,
}) {
  return SizedBox(
    width: 200,
    child: InkWell(
      onTap: route == null ? null : () => context.go(route),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: const Color(0xFF2E7D32)),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
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
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.3),
          blurRadius: 12,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF2E7D32)),
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
