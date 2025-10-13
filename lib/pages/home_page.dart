import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart'; // for pie chart

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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(_menuTitles[_selectedIndex]),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blueAccent),
              accountName: const Text("Admin User"),
              accountEmail: Text(widget.email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  // Build menu items dynamically
                  for (int index = 0; index < _menuTitles.length; index++)
                    ListTile(
                      leading: Icon(
                        _menuIcons[index],
                        color: _selectedIndex == index
                            ? Colors.blueAccent
                            : Colors.grey[700],
                      ),
                      title: Text(
                        _menuTitles[index],
                        style: TextStyle(
                          color: _selectedIndex == index
                              ? Colors.blueAccent
                              : Colors.black87,
                          fontWeight: _selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      selected: _selectedIndex == index,
                      onTap: () {
                        setState(() => _selectedIndex = index);
                        Navigator.pop(context); // close drawer
                      },
                    ),

                  const Divider(),

                  // 🆕 Tambah Kegiatan menu item
                  _buildSidebarItem(
                    icon: Icons.add_circle_outline,
                    title: "Tambah Kegiatan",
                    onTap: () {
                      Navigator.pop(context); // close drawer
                      _showAddKegiatanDialog(context);
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () => context.go('/'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _selectedIndex == 0
            ? _dashboardLayout()
            : Center(
                child: _buildPageContent(_selectedIndex),
                // child: Text(
                //   'Coming Soon: ${_menuTitles[_selectedIndex]}',
                //   style: const TextStyle(fontSize: 20),
                // ),
              ),
      ),
    );
  }

  Widget _buildPageContent(int index) {
    Widget content;

    switch (index) {
      case 0:
        content = _dashboardLayout();
        break;
      case 1:
        content = _addKegiatan();
        break;
      default:
        content = const SizedBox();
    }

    if (index != 0) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${_menuTitles[index]} berhasil disimpan!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                label: const Text(
                  "Simpan",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      );
    }

    return content;
  }

  Widget _addKegiatan() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: _templateGrid(
        title: "Kegiatan Baru Nich",
        items: [
          _featureCard("Nama kegiatan", Icons.tag_faces_outlined),
          _featureCard("Kategori kegiatan", Icons.category_outlined),
          _featureCard("Tanggal kegiatan", Icons.date_range_outlined),
          _featureCard("Lokasi kegiatan", Icons.location_on_outlined),
          _featureCard("Penanggung jawab", Icons.person_outline),
        ],
      ),
    );
  }

  Widget _templateGrid({required String title, required List<Widget> items}) {
    final screenWidth = MediaQuery.of(context).size.width;

    // determine how many columns fit nicely
    final crossAxisCount = screenWidth > 1000
        ? 3
        : screenWidth > 600
        ? 2
        : 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                itemCount: items.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  // Make aspect ratio dynamic based on width
                  childAspectRatio:
                      (constraints.maxWidth / crossAxisCount) / 160,
                ),
                itemBuilder: (context, index) => items[index],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _featureCard(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.purple[50],
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👇 Left-side Icon
              Icon(icon, size: 36, color: Colors.blueAccent),
              const SizedBox(width: 12),

              // 👇 Right-side content fits text field size
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Masukkan $title...",
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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

// --- 🧱 Card Template ---
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
                  color: Colors.black87,
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

// --- 📊 Pie Chart Sections ---
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

// --- 🎨 Legend Widget ---
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

Widget _buildSidebarItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.grey[800]),
    title: Text(title),
    onTap: onTap,
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
