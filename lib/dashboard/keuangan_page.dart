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
        pemasukanSpots.add(
          FlSpot(
            i.toDouble(),
            double.parse(item['total_pemasukan'].toString()),
          ),
        );
        pengeluaranSpots.add(
          FlSpot(
            i.toDouble(),
            double.parse(item['total_pengeluaran'].toString()),
          ),
        );
        bulanLabels.add(item['bulan'].substring(5));
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF374426)),
          onPressed: () => context.go('/beranda'),
        ),
        title: const Text(
          "Data Keuangan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF374426),
            fontSize: 20,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      // ✅ BACKGROUND PUTIH KEHIJAUAN
      color: const Color(0xFFF4F7F2),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
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

            const SizedBox(height: 24),

            _dashboardBigCard(
              title: "Grafik Pemasukan & Pengeluaran",
              icon: Icons.show_chart,
              child: SizedBox(
                height: 240,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          getTitlesWidget: (value, _) {
                            final rounded = (value / 1000000).round() * 1000000;
                            return Text(
                              rounded.toString().replaceAllMapped(
                                RegExp(r'\B(?=(\d{3})+(?!\d))'),
                                (m) => '.',
                              ),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            if (value.toInt() < bulanLabels.length) {
                              return Text(
                                bulanLabels[value.toInt()],
                                style: const TextStyle(fontSize: 10),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: const Color(0xFF374426),
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        spots: pemasukanSpots,
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF374426).withOpacity(0.15),
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
                          color: Colors.red[700]!.withOpacity(0.15),
                        ),
                      ),
                    ],
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

Widget _dashboardSmallCard(
  BuildContext context,
  String title,
  String value,
  IconData icon, {
  String? route,
}) {
  return SizedBox(
    width: 180,
    child: InkWell(
      onTap: route == null ? null : () => context.go(route),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // ✅ PUTIH BERSIH
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Color(0xFF374426)),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF374426),
              ),
            ),
            const SizedBox(height: 4),
            Text(title),
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
      color: Colors.white, // ✅ PUTIH BERSIH
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xFF374426)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF374426),
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
