// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:fl_chart/fl_chart.dart';

// class HomePage extends StatefulWidget {
//   final String email;
//   const HomePage({super.key, required this.email});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   final List<String> _menuTitles = ['Dashboard', 'Tambah Kegiatan'];
//   final List<IconData> _menuIcons = [Icons.dashboard, Icons.directions_walk];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
//       drawer: Drawer(
//         backgroundColor: Colors.white,
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             Container(
//               height: 60,
//               padding: const EdgeInsets.all(16),
//               color: Colors.white,
//               alignment: Alignment.centerLeft,
//               child: Row(
//                 children: [
//                   Image.asset(
//                     'assets/images/juwara.png',
//                     width: 40,
//                     height: 40,
//                     fit: BoxFit.contain,
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     'Jawara App',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 16),
//                 child: const Text(
//                   "Menu",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _menuTitles.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: Icon(
//                       _menuIcons[index],
//                       color: _selectedIndex == index
//                           ? Colors.black
//                           : Colors.grey[700],
//                     ),
//                     title: Text(
//                       _menuTitles[index],
//                       style: TextStyle(
//                         color: _selectedIndex == index
//                             ? Colors.black
//                             : Colors.grey,
//                         fontWeight: _selectedIndex == index
//                             ? FontWeight.bold
//                             : FontWeight.normal,
//                       ),
//                     ),
//                     selected: _selectedIndex == index,
//                     onTap: () {
//                       setState(() => _selectedIndex = index);
//                       Navigator.pop(context);
//                     },
//                   );
//                 },
//               ),
//             ),
//             const Divider(),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: InkWell(
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       backgroundColor: Colors.white,
//                       content: Row(
//                         children: [
//                           const CircleAvatar(
//                             backgroundColor: Colors.white,
//                             child: Icon(
//                               Icons.person,
//                               size: 40,
//                               color: Colors.blueAccent,
//                             ),
//                           ),
//                           const SizedBox(width: 20),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Text(
//                                   "Admin User",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                                 Text(
//                                   widget.email,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Divider(),
//                         ],
//                       ),
//                       actions: [
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);
//                             context.go('/');
//                           },
//                           child: Row(
//                             children: [
//                               const Icon(Icons.logout, color: Colors.black),
//                               const SizedBox(width: 20),
//                               const Text(
//                                 "Log out",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },

//                 child: Row(
//                   children: [
//                     const CircleAvatar(
//                       backgroundColor: Colors.white,
//                       child: Icon(
//                         Icons.person,
//                         size: 40,
//                         color: Colors.blueAccent,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Admin User",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         Text(
//                           widget.email,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             ListTile(
//               //   leading: const Icon(Icons.logout, color: Colors.red),
//               //   title: const Text("Logout"),
//               //   onTap: () => context.go('/'),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: _selectedIndex == 0
//             ? _dashboardLayout()
//             : Center(child: _buildPageContent(_selectedIndex)),
//       ),
//     );
//   }

//   // --- Dashboard ---
//   Widget _dashboardLayout() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         bool isWide = constraints.maxWidth > 800;
//         return GridView.count(
//           crossAxisCount: isWide ? 2 : 1,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           childAspectRatio: isWide ? 1.8 : 1.4,
//           children: [
//             _infoCard(
//               title: "Total Kegiatan",
//               emoji: "🎉",
//               color: Colors.blue[100]!,
//               content: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text(
//                     "1",
//                     style: TextStyle(
//                       fontSize: 48,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     "Jumlah seluruh event yang sudah ada",
//                     style: TextStyle(fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//             _infoCard(
//               title: "Kegiatan per Kategori",
//               emoji: "📁",
//               color: Colors.green[100]!,
//               content: Column(
//                 children: [
//                   Expanded(
//                     child: PieChart(
//                       PieChartData(
//                         sectionsSpace: 2,
//                         centerSpaceRadius: 40,
//                         sections: _buildPieChartSections(),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 4,
//                     alignment: WrapAlignment.center,
//                     children: [
//                       _legend("Komunitas & Sosial", Colors.blue),
//                       _legend("Kebersihan & Keamanan", Colors.green),
//                       _legend("Keagamaan", Colors.orange),
//                       _legend("Pendidikan", Colors.purple),
//                       _legend("Kesehatan & Olahraga", Colors.pink),
//                       _legend("Lainnya", Colors.lightBlue),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             _infoCard(
//               title: "Kegiatan berdasarkan Waktu",
//               emoji: "⏰",
//               color: Colors.yellow[100]!,
//               content: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text("Sudah Lewat: 1", style: TextStyle(fontSize: 16)),
//                   Text("Hari Ini: 0", style: TextStyle(fontSize: 16)),
//                   Text("Akan Datang: 0", style: TextStyle(fontSize: 16)),
//                 ],
//               ),
//             ),
//             _infoCard(
//               title: "Penanggung Jawab Terbanyak",
//               emoji: "🧑‍💼",
//               color: Colors.purple[100]!,
//               content: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Pak Agus", style: TextStyle(fontSize: 18)),
//                   const SizedBox(height: 4),
//                   LinearProgressIndicator(
//                     value: 1,
//                     color: Colors.purple,
//                     backgroundColor: Colors.purple[200],
//                   ),
//                 ],
//               ),
//             ),
//             _infoCard(
//               title: "Kegiatan per Bulan (Tahun Ini)",
//               emoji: "📅",
//               color: Colors.pink[50]!,
//               content: SizedBox(
//                 height: 220,
//                 child: BarChart(
//                   BarChartData(
//                     alignment: BarChartAlignment.spaceAround,
//                     gridData: FlGridData(show: false),
//                     borderData: FlBorderData(show: false),
//                     titlesData: FlTitlesData(
//                       leftTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           reservedSize: 28,
//                         ),
//                       ),
//                       rightTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       topTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           getTitlesWidget: (value, meta) {
//                             final months = [
//                               'Jan',
//                               'Feb',
//                               'Mar',
//                               'Apr',
//                               'Mei',
//                               'Jun',
//                               'Jul',
//                               'Agu',
//                               'Sep',
//                               'Okt',
//                             ];
//                             if (value.toInt() >= 0 &&
//                                 value.toInt() < months.length) {
//                               return Text(months[value.toInt()]);
//                             }
//                             return const SizedBox.shrink();
//                           },
//                         ),
//                       ),
//                     ),
//                     barGroups: List.generate(10, (i) {
//                       return BarChartGroupData(
//                         x: i,
//                         barRods: [
//                           BarChartRodData(
//                             toY: (i == 9) ? 1 : 0.4 + (i * 0.05),
//                             color: Colors.pinkAccent,
//                             width: 16,
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                         ],
//                       );
//                     }),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // --- Add Kegiatan ---
//   Widget _addKegiatan() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.only(bottom: 24),
//       child: _templateGrid(
//         title: "Kegiatan Baru Nich",
//         items: [
//           _featureCard("Nama kegiatan", Icons.tag_faces_outlined),
//           _featureCard("Kategori kegiatan", Icons.category_outlined),
//           _featureCard("Tanggal kegiatan", Icons.date_range_outlined),
//           _featureCard("Lokasi kegiatan", Icons.location_on_outlined),
//           _featureCard("Penanggung jawab", Icons.person_outline),
//         ],
//       ),
//     );
//   }

//   Widget _buildPageContent(int index) {
//     Widget content;

//     switch (index) {
//       case 0:
//         content = _dashboardLayout();
//         break;
//       case 1:
//         content = _addKegiatan();
//         break;
//       default:
//         content = const SizedBox();
//     }

//     if (index != 0) {
//       return SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             content,
//             const SizedBox(height: 24),
//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("${_menuTitles[index]} berhasil disimpan!"),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 },
//                 icon: const Icon(
//                   Icons.check_circle_outline,
//                   color: Color.fromARGB(255, 255, 255, 255),
//                 ),
//                 label: const Text(
//                   "Simpan",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.greenAccent,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 14,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//           ],
//         ),
//       );
//     }

//     return content;
//   }

//   Widget _templateGrid({required String title, required List<Widget> items}) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     // determine how many columns fit nicely
//     final crossAxisCount = screenWidth > 1000
//         ? 3
//         : screenWidth > 600
//         ? 2
//         : 1;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 16),
//           LayoutBuilder(
//             builder: (context, constraints) {
//               return GridView.builder(
//                 itemCount: items.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: crossAxisCount,
//                   mainAxisSpacing: 12,
//                   crossAxisSpacing: 12,
//                   childAspectRatio:
//                       (constraints.maxWidth / crossAxisCount) / 160,
//                 ),
//                 itemBuilder: (context, index) => items[index],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _featureCard(String title, IconData icon) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       width: double.infinity,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         color: const Color.fromARGB(255, 255, 255, 255),
//         elevation: 3,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(icon, size: 36, color: Colors.black),
//               const SizedBox(width: 12),

//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextField(
//                       decoration: InputDecoration(
//                         hintText: "Masukkan $title...",
//                         contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10,
//                           horizontal: 12,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // --- Info Card ---
// Widget _infoCard({
//   required String title,
//   required String emoji,
//   required Color color,
//   required Widget content,
// }) {
//   return Card(
//     elevation: 4,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//     color: color,
//     child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(emoji, style: const TextStyle(fontSize: 20)),
//               const SizedBox(width: 6),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Expanded(child: content),
//         ],
//       ),
//     ),
//   );
// }

// List<PieChartSectionData> _buildPieChartSections() {
//   return [
//     PieChartSectionData(
//       color: Colors.blue,
//       value: 100,
//       title: "100%",
//       radius: 50,
//     ),
//   ];
// }

// Widget _legend(String label, Color color) {
//   return Row(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Container(width: 12, height: 12, color: color),
//       const SizedBox(width: 4),
//       Text(label, style: const TextStyle(fontSize: 12)),
//     ],
//   );
// }
