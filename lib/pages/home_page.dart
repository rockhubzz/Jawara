import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/widgets/appDrawer.dart';
import '/services/auth_service.dart';
import '/services/dashboard_service.dart';
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
  int kegiatan = 0;
  bool loadingKegiatan = true;
  bool loadingKeluarga = true;
  bool loadingSaldo = true;

  @override
  void initState() {
    super.initState();
    loadUser();
    _loadSaldo();
    _loadKeluarga();
    _loadKegiatan();
  }

  Future<void> loadUser() async {
    final user = await AuthService.me();
    if (user != null) {
      if (!mounted) return;
      setState(() {
        username = user['name']; // get username
      });
    }
  }

  String formatRupiah(dynamic value) {
    final number = int.tryParse(value.toString()) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  Future<void> _loadSaldo() async {
    try {
      final result = await DashboardService.getSaldo();
      if (!mounted) return;

      setState(() {
        saldo = result;
        loadingSaldo = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => loadingSaldo = false);
    }
  }

  Future<void> _loadKeluarga() async {
    try {
      final result = await DashboardService.getKeluarga();
      if (!mounted) return;
      setState(() {
        keluarga = result;
        loadingKeluarga = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loadingKeluarga = false);
    }
  }

  Future<void> _loadKegiatan() async {
    try {
      final result = await DashboardService.getKegiatan();

      if (!mounted) return;

      setState(() {
        kegiatan = result;
        loadingKegiatan = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loadingKegiatan = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      username: "$username",
      currentIndex: 0,
      body: _buildBody(context), // langsung panggil body
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Selamat Datang,",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              "$username",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),

            const SizedBox(height: 20),

            // CARD 1
            _buildDashboardCard(
              title: "Ringkasan Keuangan",
              subtitle: "Saldo Kas RT",
              value: loadingSaldo ? 'Loading...' : formatRupiah(saldo),
              icon: Icons.account_balance_wallet,
              onTap: () {
                context.go('/dashboard/keuangan');
              },
            ),

            const SizedBox(height: 12),

            // CARD 2
            _buildDashboardCard(
              title: "Ringkasan Warga",
              subtitle: "Jumlah KK Terdaftar",
              value: loadingKeluarga ? 'Loading...' : '$keluarga KK',
              icon: Icons.people_alt,
              onTap: () {
                context.go('/dashboard/kependudukan');
              },
            ),

            const SizedBox(height: 12),

            // CARD 3
            _buildDashboardCard(
              title: "Kegiatan RT & Broadcast",
              subtitle: "Agenda Aktif",
              value: loadingKegiatan ? 'Loading...' : '$kegiatan Kegiatan',
              icon: Icons.event,
              onTap: () {
                context.go('/dashboard/kegiatan');
              },
            ),

            const SizedBox(height: 20),

            // MENU GRID
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _menuItem(
                    Icons.people,
                    "Data Warga",
                    Colors.green,
                    onTap: () => context.go(
                      '/data_warga_rumah/daftarWarga?from=beranda',
                    ),
                  ),

                  _menuItem(
                    Icons.house,
                    "Data Rumah",
                    Colors.blue,
                    onTap: () => context.go(
                      '/data_warga_rumah/daftarRumah?from=beranda',
                    ),
                  ),

                  _menuItem(
                    Icons.attach_money,
                    "Pemasukan",
                    Colors.teal,
                    onTap: () {
                      context.go('/beranda/pemasukan_menu');
                    },
                  ),

                  // _menuItem(
                  //   Icons.money_off,
                  //   "Pengeluaran",
                  //   Colors.red,
                  //   onTap: () {
                  //     context.go('/beranda/pengeluaran');
                  //   },
                  // ),

                  // _menuItem(
                  //   Icons.message,
                  //   "Pesan Warga",
                  //   Colors.purple,
                  //   onTap: () {
                  //     context.go('/beranda/pesan_warga');
                  //   },
                  // ),
                  _menuItem(
                    Icons.swap_horiz,
                    "Mutasi",
                    Colors.orange,
                    onTap: () => context.go('/mutasi?from=beranda'),
                  ),

                  _menuItem(
                    Icons.event_note,
                    "Kegiatan",
                    Colors.indigo,
                    onTap: () => context.go('/kegiatan/daftar?from=beranda'),
                  ),
                  _menuItem(
                    Icons.menu,
                    "Semua Menu",
                    Colors.grey,
                    onTap: () {
                      context.go('/beranda/semua_menu');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- Dashboard Card ---
  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3EB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xFF2E7D32), size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  // --- Menu Item ---
  Widget _menuItem(
    IconData icon,
    String label,
    Color color, {
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: color.withOpacity(
                    0.18,
                  ), // background mengikuti warna icon
                  shape: BoxShape.circle,
                ),
              ),
              Icon(icon, size: 26, color: color), // icon sesuai warna
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _menuItem(IconData icon, String label, {Function()? onTap}) {
  //   return InkWell(
  //     onTap: onTap,
  //     borderRadius: BorderRadius.circular(50),
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(14),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             shape: BoxShape.circle,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black12,
  //                 blurRadius: 4,
  //                 offset: Offset(0, 2),
  //               ),
  //             ],
  //           ),
  //           child: Icon(icon, size: 28, color: Color(0xFF2E7D32)),
  //         ),
  //         const SizedBox(height: 6),
  //         Text(
  //           label,
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(
  //             fontSize: 12,
  //             color: Color(0xFF2E7D32),
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _menuItem(IconData icon, String label, {Function()? onTap}) {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(14),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           shape: BoxShape.circle,
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black12,
  //               blurRadius: 4,
  //               offset: Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         child: Icon(icon, size: 28, color: Color(0xFF143621)),
  //       ),
  //       const SizedBox(height: 6),
  //       Text(
  //         label,
  //         textAlign: TextAlign.center,
  //         style: const TextStyle(
  //           fontSize: 12,
  //           color: Color(0xFF143621),
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
