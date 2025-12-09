import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../widgets/appDrawer.dart';
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
      print(e);
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/beranda'),
        ),
        title: const Text(
          "Data Kependudukan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =================== INFO CARD ===================
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 700 ? 2 : 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.5,
            children: [
              _infoCard(
                title: "Total Keluarga",
                value: loading ? "..." : totalKeluarga.toString(),
                icon: Icons.house_rounded,
                color: const Color(0xFFDCE8FA),
                textColor: Colors.blue[800]!,
              ),
              _infoCard(
                title: "Total Penduduk",
                value: loading ? "..." : totalWarga.toString(),
                icon: Icons.people_alt_rounded,
                color: const Color(0xFFDFF6DD),
                textColor: Colors.green[700]!,
              ),
            ],
          ),

          const SizedBox(height: 25),

          // =================== PIE CHART SECTION ===================
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 1000
                ? 3
                : MediaQuery.of(context).size.width > 700
                ? 2
                : 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.4,
            children: [
              _chartCard(
                title: "Status Penduduk",
                icon: Icons.verified_user_rounded,
                color: const Color(0xFFFFF5D9),
                sections: domisili.isEmpty
                    ? [
                        PieChartSectionData(
                          value: 100,
                          color: Colors.grey,
                          title: "Loading",
                        ),
                      ]
                    : domisili.map<PieChartSectionData>((e) {
                        return PieChartSectionData(
                          value: double.parse(e['total'].toString()),
                          title: e['status_domisili'],
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

              _chartCard(
                title: "Jenis Kelamin",
                icon: Icons.wc_rounded,
                color: const Color(0xFFF3E5F5),
                sections: jenisKelamin.isEmpty
                    ? [
                        PieChartSectionData(
                          value: 100,
                          color: Colors.grey,
                          title: "Loading",
                        ),
                      ]
                    : jenisKelamin.map<PieChartSectionData>((e) {
                        return PieChartSectionData(
                          value: double.parse(e['total'].toString()),
                          title: e['jenis_kelamin'].toString().startsWith('L')
                              ? 'L'
                              : 'P',
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
              // _chartCard(
              //   title: "Pekerjaan Penduduk",
              //   icon: Icons.work_rounded,
              //   color: const Color(0xFFFFF0E6),
              //   sections: [
              //     PieChartSectionData(
              //       value: 40,
              //       color: Colors.brown,
              //       title: "Petani",
              //       titleStyle: const TextStyle(color: Colors.white),
              //     ),
              //     PieChartSectionData(
              //       value: 25,
              //       color: Colors.teal,
              //       title: "Pedagang",
              //       titleStyle: const TextStyle(color: Colors.white),
              //     ),
              //     PieChartSectionData(
              //       value: 20,
              //       color: Colors.deepPurple,
              //       title: "Guru",
              //       titleStyle: const TextStyle(color: Colors.white),
              //     ),
              //     PieChartSectionData(
              //       value: 15,
              //       color: Colors.orange,
              //       title: "Lainnya",
              //       titleStyle: const TextStyle(color: Colors.white),
              //     ),
              //   ],
              // ),

              // _chartCard(
              //   title: "Peran dalam Keluarga",
              //   icon: Icons.family_restroom_rounded,
              //   color: const Color(0xFFD9F1FF),
              //   sections: [
              //     PieChartSectionData(
              //       value: 50,
              //       color: Colors.blue,
              //       title: "KK",
              //       titleStyle: const TextStyle(color: Colors.white),
              //     ),
              //     PieChartSectionData(
              //       value: 30,
              //       color: Colors.redAccent,
              //       title: "Istri",
              //       titleStyle: const TextStyle(color: Colors.white),
              //     ),
              //     PieChartSectionData(
              //       value: 20,
              //       color: Colors.green,
              //       title: "Anak",
              //       titleStyle: const TextStyle(color: Colors.white),
              //     ),
              //   ],
              // ),

              // _chartCard(
              //   title: "Agama",
              //   icon: Icons.church_rounded,
              //   color: const Color(0xFFFFE7E7),
              //   sections: [
              //     PieChartSectionData(
              //       value: 60,
              //       color: Colors.orange,
              //       title: "Islam",
              //       titleStyle: const TextStyle(color: Colors.white),
              //     ),
              //     PieChartSectionData(
              //       value: 40,
              //       color: Colors.blue,
              //       title: "Lainnya",
              //       titleStyle: const TextStyle(color: Colors.white),
              //     ),
              //   ],
              // ),

              // _chartCard(
              //   title: "Pendidikan",
              //   icon: Icons.school_rounded,
              //   color: const Color(0xFFE0F7F3),
              //   sections: [
              //     PieChartSectionData(
              //       value: 40,
              //       color: Colors.grey,
              //       title: "SD",
              //       titleStyle: const TextStyle(color: Colors.white),
              //     ),
              //     PieChartSectionData(
              //       value: 30,
              //       color: Colors.blueGrey,
              //       title: "SMP",
              //       titleStyle: const TextStyle(color: Colors.white),
              //     ),
              //     PieChartSectionData(
              //       value: 30,
              //       color: Colors.indigo,
              //       title: "SMA",
              //       titleStyle: const TextStyle(color: Colors.white),
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }

  // ========================= CARD ANGKA =========================
  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color textColor,
  }) {
    return Card(
      color: color,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: textColor, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================= CARD PIE CHART =========================
  Widget _chartCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<PieChartSectionData> sections,
  }) {
    return Card(
      elevation: 3,
      color: color,
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
                  centerSpaceRadius: 40,
                  sectionsSpace: 3,
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
