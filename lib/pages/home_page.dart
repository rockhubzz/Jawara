// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:jawara/widgets/appDrawer.dart';
// import '/services/auth_service.dart';
// import '/services/dashboard_service.dart';
// import 'package:intl/intl.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String? username;
//   int saldo = 0;
//   int keluarga = 0;
//   int kegiatan = 0;
//   bool loadingKegiatan = true;
//   bool loadingKeluarga = true;
//   bool loadingSaldo = true;

//   @override
//   void initState() {
//     super.initState();
//     loadUser();
//     _loadSaldo();
//     _loadKeluarga();
//     _loadKegiatan();
//   }

//   Future<void> loadUser() async {
//     final user = await AuthService.me();
//     if (user != null) {
//       if (!mounted) return;
//       setState(() {
//         username = user['name']; // get username
//       });
//     }
//   }

//   String formatRupiah(dynamic value) {
//     final number = int.tryParse(value.toString()) ?? 0;
//     final formatter = NumberFormat.currency(
//       locale: 'id_ID',
//       symbol: 'Rp ',
//       decimalDigits: 0,
//     );
//     return formatter.format(number);
//   }

//   Future<void> _loadSaldo() async {
//     try {
//       final result = await DashboardService.getSaldo();
//       if (!mounted) return;

//       setState(() {
//         saldo = result;
//         loadingSaldo = false;
//       });
//     } catch (e) {
//       if (!mounted) return;

//       setState(() => loadingSaldo = false);
//     }
//   }

//   Future<void> _loadKeluarga() async {
//     try {
//       final result = await DashboardService.getKeluarga();
//       if (!mounted) return;
//       setState(() {
//         keluarga = result;
//         loadingKeluarga = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => loadingKeluarga = false);
//     }
//   }

//   Future<void> _loadKegiatan() async {
//     try {
//       final result = await DashboardService.getKegiatan();

//       if (!mounted) return;

//       setState(() {
//         kegiatan = result;
//         loadingKegiatan = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => loadingKegiatan = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppDrawer(
//       username: "$username",
//       currentIndex: 0,
//       body: _buildBody(context), // langsung panggil body
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color.fromARGB(255, 255, 235, 188),
//             Color.fromARGB(255, 181, 255, 183),
//           ],
//         ),
//       ),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               "Selamat Datang,",
//               style: TextStyle(fontSize: 14, color: Colors.black54),
//             ),
//             Text(
//               "$username",
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2E7D32),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // CARD 1
//             _buildDashboardCard(
//               title: "Ringkasan Keuangan",
//               subtitle: "Saldo Kas RT",
//               value: loadingSaldo ? 'Loading...' : formatRupiah(saldo),
//               icon: Icons.account_balance_wallet,
//               onTap: () {
//                 context.go('/dashboard/keuangan');
//               },
//             ),

//             const SizedBox(height: 12),

//             // CARD 2
//             _buildDashboardCard(
//               title: "Ringkasan Warga",
//               subtitle: "Jumlah KK Terdaftar",
//               value: loadingKeluarga ? 'Loading...' : '$keluarga KK',
//               icon: Icons.people_alt,
//               onTap: () {
//                 context.go('/dashboard/kependudukan');
//               },
//             ),

//             const SizedBox(height: 12),

//             // CARD 3
//             _buildDashboardCard(
//               title: "Kegiatan RT & Broadcast",
//               subtitle: "Agenda Aktif",
//               value: loadingKegiatan ? 'Loading...' : '$kegiatan Kegiatan',
//               icon: Icons.event,
//               onTap: () {
//                 context.go('/dashboard/kegiatan');
//               },
//             ),

//             const SizedBox(height: 20),

//             // MENU GRID
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 6,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: GridView.count(
//                 crossAxisCount: 4,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   _menuItem(
//                     Icons.people,
//                     "Data Warga",
//                     Colors.green,
//                     onTap: () => context.go(
//                       '/data_warga_rumah/daftarWarga?from=beranda',
//                     ),
//                   ),

//                   _menuItem(
//                     Icons.house,
//                     "Data Rumah",
//                     Colors.blue,
//                     onTap: () => context.go(
//                       '/data_warga_rumah/daftarRumah?from=beranda',
//                     ),
//                   ),

//                   _menuItem(
//                     Icons.attach_money,
//                     "Pemasukan",
//                     Colors.teal,
//                     onTap: () {
//                       context.go('/beranda/pemasukan_menu');
//                     },
//                   ),

//                   _menuItem(
//                     Icons.swap_horiz,
//                     "Mutasi",
//                     Colors.orange,
//                     onTap: () => context.go('/mutasi?from=beranda'),
//                   ),

//                   _menuItem(
//                     Icons.event_note,
//                     "Kegiatan",
//                     Colors.indigo,
//                     onTap: () => context.go('/kegiatan/daftar?from=beranda'),
//                   ),
//                   _menuItem(
//                     Icons.menu,
//                     "Semua Menu",
//                     Colors.grey,
//                     onTap: () {
//                       context.go('/beranda/semua_menu');
//                     },
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- Dashboard Card ---
//   Widget _buildDashboardCard({
//     required String title,
//     required String subtitle,
//     required String value,
//     required IconData icon,
//     required Function() onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(14),
//       child: Container(
//         padding: const EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE8F3EB),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: Color(0xFF2E7D32), size: 28),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2E7D32),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(fontSize: 12, color: Colors.black54),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     value,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2E7D32),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.chevron_right, color: Colors.black45),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- Menu Item ---
//   Widget _menuItem(
//     IconData icon,
//     String label,
//     Color color, {
//     Function()? onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(50),
//       child: Column(
//         children: [
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(22),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(
//                     0.18,
//                   ), // background mengikuti warna icon
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               Icon(icon, size: 26, color: color), // icon sesuai warna
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.black87,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/widgets/appDrawer.dart';
import '/services/auth_service.dart';
import '/services/dashboard_service.dart';
import '/services/keuangan_service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;

  int saldo = 0;
  int keluarga = 0;

  int pemasukanBulanan = 0;
  int pengeluaranBulanan = 0;

  bool loadingSaldo = true;
  bool loadingKeluarga = true;
  bool loadingRekap = true;

  @override
  void initState() {
    super.initState();
    loadUser();
    _loadSaldo();
    _loadKeluarga();
    _loadRekapBulanan();
  }

  Future<void> loadUser() async {
    final user = await AuthService.me();
    if (user != null && mounted) {
      setState(() => username = user['name']);
    }
  }

  String formatRupiah(dynamic value) {
    final number = int.tryParse(value.toString()) ?? 0;
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  Future<void> _loadSaldo() async {
    try {
      final result = await DashboardService.getSaldo();
      if (mounted) {
        setState(() {
          saldo = result;
          loadingSaldo = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => loadingSaldo = false);
    }
  }

  Future<void> _loadKeluarga() async {
    try {
      final result = await DashboardService.getKeluarga();
      if (mounted) {
        setState(() {
          keluarga = result;
          loadingKeluarga = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => loadingKeluarga = false);
    }
  }

  Future<void> _loadRekapBulanan() async {
    try {
      final data = await DashboardService.getRekapKeuanganCurrentMonth();
      if (!mounted) return;

      setState(() {
        pemasukanBulanan = data['total_pemasukan'] ?? 0;
        pengeluaranBulanan = data['total_pengeluaran'] ?? 0;
        loadingRekap = false;
      });
    } catch (_) {
      if (mounted) setState(() => loadingRekap = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      username: "$username",
      currentIndex: 0,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        Container(height: 260, color: const Color(0xFF374426)),
        Positioned.fill(
          top: 220,
          child: Container(color: const Color(0xFFF4F7F2)),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // SELAMAT DATANG (NAMA SAJA BOLD)
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  children: [
                    const TextSpan(text: "Selamat Datang, "),
                    TextSpan(
                      text: username ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // RINGKASAN ATAS (3 CARD - SCROLLABLE)
              SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _summaryCard(
                      title: "Keuangan",
                      subtitle: "Saldo Kas RT",
                      value: loadingSaldo ? "Loading..." : formatRupiah(saldo),
                      icon: Icons.account_balance_wallet,
                      onTap: () => context.go('/dashboard/keuangan'),
                    ),
                    _summaryCard(
                      title: "Warga",
                      subtitle: "Jumlah KK",
                      value: loadingKeluarga ? "Loading..." : "$keluarga KK",
                      icon: Icons.people_alt,
                      onTap: () => context.go('/dashboard/kependudukan'),
                    ),
                    _summaryCard(
                      title: "Kegiatan",
                      subtitle: "Kegiatan Warga",
                      value: "Lihat",
                      icon: Icons.campaign,
                      onTap: () => context.go('/dashboard/kegiatan'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _menuGrid(context),

              const SizedBox(height: 24),

              _monthlyFinanceCard(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  // --- CARD RINGKASAN ---
  Widget _summaryCard({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF374426)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  // --- MENU GRID ---
  Widget _menuGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _menuItem(
            Icons.people,
            "Data Warga",
            () => context.go('/data_warga_rumah/daftarWarga?from=beranda'),
          ),
          _menuItem(
            Icons.house,
            "Data Rumah",
            () => context.go('/data_warga_rumah/daftarRumah?from=beranda'),
          ),
          _menuItem(
            Icons.attach_money,
            "Pemasukan",
            () => context.go('/beranda/pemasukan_menu'),
          ),
          _menuItem(
            Icons.swap_horiz,
            "Mutasi",
            () => context.go('/mutasi_keluarga/daftar'),
          ),
          _menuItem(
            Icons.event,
            "Kegiatan",
            () => context.go('/kegiatan/daftar?from=beranda'),
          ),
          _menuItem(
            Icons.menu,
            "Semua Menu",
            () => context.go('/beranda/semua_menu'),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFF9FB878),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // --- CARD BULANAN ---
  Widget _monthlyFinanceCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ringkasan Bulan Ini",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _FinanceRow(
            label: "Pemasukan",
            value: loadingRekap ? "Loading..." : formatRupiah(pemasukanBulanan),
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          _FinanceRow(
            label: "Pengeluaran",
            value: loadingRekap
                ? "Loading..."
                : formatRupiah(pengeluaranBulanan),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

class _FinanceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _FinanceRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
