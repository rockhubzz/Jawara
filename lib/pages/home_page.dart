import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  final String email;
  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<String> _menuTitles = ['Dashboard', 'Tambah Kegiatan'];
  final List<IconData> _menuIcons = [Icons.dashboard, Icons.directions_walk];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _dashboardLayout(),
      ),
    );
  }

  // --- Drawer ---
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 40),
          // --- Header ---
          Container(
            height: 60,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/juwara.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Jawara App',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text(
              "Menu",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          // --- Dashboard with submenu ---
          ExpansionTile(
            leading: const Icon(Icons.dashboard, color: Colors.blueAccent),
            title: const Text(
              "Dashboard",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.directions_walk,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                title: const Text("Kegiatan"),
                onTap: () {
                  context.pop(); // close the drawer
                  context.go('/home');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.people,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                title: const Text("Kependudukan"),
                onTap: () {
                  context.go('/kependudukan');
                },
              ),
            ],
          ),

          // --- Tambah Kegiatan ---
          ListTile(
            leading: const Icon(
              Icons.add_circle_outline,
              color: Colors.blueAccent,
            ),
            title: const Text("Tambah Kegiatan"),
            onTap: () {
              context.go('/addKegiatan');
            },
          ),

          const Divider(),

          // --- Logout / Profile ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () => _showProfileDialog(context),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Admin User",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        widget.email,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Admin User",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              context.go('/');
            },
            child: Row(
              children: const [
                Icon(Icons.logout, color: Colors.black),
                SizedBox(width: 20),
                Text(
                  "Log out",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Dashboard ---
  Widget _dashboardLayout() {
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
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

  void _showAddKegiatanDialog(BuildContext context) {
    final TextEditingController kegiatanController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Kegiatan"),
          content: TextField(
            controller: kegiatanController,
            decoration: const InputDecoration(
              labelText: "Nama Kegiatan",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Kegiatan '${kegiatanController.text}' berhasil ditambahkan!",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }
}
