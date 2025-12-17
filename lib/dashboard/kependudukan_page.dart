import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../services/kependudukan_service.dart';

class KependudukanPage extends StatefulWidget {
  const KependudukanPage({super.key});

  @override
  State<KependudukanPage> createState() => _KependudukanPageState();
}

class _KependudukanPageState extends State<KependudukanPage> {
  bool loading = true;

  int totalKeluarga = 0;
  int totalWarga = 0;

  List domisili = [];
  List jenisKelamin = [];

  @override
  void initState() {
    super.initState();
    _loadGlance();
  }

  Future<void> _loadGlance() async {
    try {
      final result = await KependudukanService.getGlance();
      final data = result['data'];

      setState(() {
        totalKeluarga = data['total_keluarga'];
        totalWarga = data['total_warga'];
        domisili = data['domisili'];
        jenisKelamin = data['jenis_kelamin'];
        loading = false;
      });
    } catch (e) {
      debugPrint("ERROR: $e");
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  List<Widget> _buildJKLegend() {
    if (jenisKelamin.isEmpty) {
      return [_legend("Tidak ada data", Colors.grey)];
    }

    return jenisKelamin.map((e) {
      final jk = e['jenis_kelamin']?.toString() ?? "Unknown";
      final isLaki = jk.toLowerCase().startsWith('l');

      Color color = isLaki ? Colors.blue : Colors.pinkAccent;

      return _legend(jk, color);
    }).toList();
  }

  List<Widget> _buildDomisiliLegend() {
    if (domisili.isEmpty) {
      return [_legend("Tidak ada data", Colors.grey)];
    }

    return domisili.map((e) {
      final status = e['status_domisili']?.toString() ?? "Unknown";
      final isAktif = status.toLowerCase() == "aktif";

      Color color = isAktif ? Colors.green : Colors.red;

      return _legend(status, color);
    }).toList();
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
          "Data Kependudukan",
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _dashboardSmallCard(
                    context,
                    "Total Keluarga",
                    loading ? "..." : totalKeluarga.toString(),
                    Icons.house_rounded,
                    route: '/data_warga_rumah/keluarga',
                  ),
                  _dashboardSmallCard(
                    context,
                    "Total Warga",
                    loading ? "..." : totalWarga.toString(),
                    Icons.people_alt_rounded,
                    route: '/data_warga_rumah/daftarWarga',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // =================== CHART CARDS ===================
            _dashboardBigCard(
              title: "Status Domisili",
              icon: Icons.verified_user_rounded,
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 35,
                        sectionsSpace: 2,
                        sections: domisili.isEmpty
                            ? [
                                PieChartSectionData(
                                  value: 100,
                                  color: Colors.grey,
                                  title: "Loading",
                                ),
                              ]
                            : domisili.map<PieChartSectionData>((e) {
                                final value = double.parse(
                                  e['total'].toString(),
                                );
                                return PieChartSectionData(
                                  value: value,
                                  title: "${value.toInt()}%",
                                  color: e['status_domisili'] == 'Aktif'
                                      ? Colors.green
                                      : Colors.red,
                                  titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: _buildDomisiliLegend(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _dashboardBigCard(
              title: "Jenis Kelamin",
              icon: Icons.wc_rounded,
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 35,
                        sectionsSpace: 2,
                        sections: jenisKelamin.isEmpty
                            ? [
                                PieChartSectionData(
                                  value: 100,
                                  color: Colors.grey,
                                  title: "Loading",
                                ),
                              ]
                            : jenisKelamin.map<PieChartSectionData>((e) {
                                final value = double.parse(
                                  e['total'].toString(),
                                );
                                return PieChartSectionData(
                                  value: value,
                                  title: "${value.toInt()}%",
                                  color: e['jenis_kelamin'] == 'Laki-laki'
                                      ? Colors.blue
                                      : Colors.pinkAccent,
                                  titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(spacing: 10, runSpacing: 8, children: _buildJKLegend()),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// =================== COMPONENTS ===================

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

Widget _legend(String label, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 13)),
    ],
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
    margin: const EdgeInsets.symmetric(vertical: 8),
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
