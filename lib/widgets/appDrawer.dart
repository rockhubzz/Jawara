import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  final String email;

  const AppDrawer({super.key, required this.email});

  // Warna aktif & tidak aktif
  final Color activeColor = Colors.blueAccent;
  final Color inactiveColor = Colors.black87;

  // Fungsi pembuat ListTile navigasi
  ListTile buildNavTile({
    required String title,
    required IconData icon,
    required String route,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go(route);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentPath = GoRouterState.of(context).uri.toString();

    // Tentukan submenu mana yang terbuka
    final bool isDashboardExpanded = currentPath.startsWith('/dashboard');
    final bool isDataWargaExpanded = currentPath.startsWith(
      '/data_warga_rumah',
    );
    final bool isPemasukanExpanded = currentPath.startsWith('/Pemasukan');
    final bool isPengeluaranExpanded = currentPath.startsWith('/Pengeluaran');
    final bool isKegiatanExpanded = currentPath.startsWith('/kegiatan');
    final bool isLapKeuExpanded = currentPath.startsWith('/laporanKeuangan');

    debugPrint('Current Path: $currentPath');

    Color activeColor = Colors.blueAccent;
    Color inactiveColor = Colors.black87;

    Widget buildNavTile({
      required String title,
      required IconData icon,
      required String route,
    }) {
      final bool isActive =
          currentPath == route || currentPath.startsWith('$route/');
      return ListTile(
        leading: Icon(icon, color: isActive ? activeColor : inactiveColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? activeColor : inactiveColor,
          ),
        ),
        tileColor: isActive ? Colors.blueAccent.withOpacity(0.1) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          Navigator.pop(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(route);
          });
        },
      );
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 40),

          // Header
          Container(
            height: 60,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Image.asset('assets/images/juwara.png', width: 40, height: 40),
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

          // --- Dashboard (dengan submenu) ---
          ExpansionTile(
            initiallyExpanded: isDashboardExpanded,
            leading: Icon(
              Icons.dashboard,
              color: isDashboardExpanded ? activeColor : inactiveColor,
            ),
            title: Text(
              "Dashboard",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDashboardExpanded ? activeColor : inactiveColor,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              buildNavTile(
                title: "Kegiatan",
                icon: Icons.directions_walk,
                route: '/dashboard/kegiatan',
              ),
              buildNavTile(
                title: "Keuangan",
                icon: Icons.account_balance_wallet,
                route: '/dashboard/keuangan',
              ),
              buildNavTile(
                title: "Kependudukan",
                icon: Icons.people,
                route: '/dashboard/kependudukan',
              ),
            ],
          ),

          // menu Data Warga & Rumah
          ExpansionTile(
            initiallyExpanded: isDataWargaExpanded,
            leading: Icon(
              Icons.home_work_rounded,
              color: isDataWargaExpanded ? activeColor : inactiveColor,
            ),
            title: Text(
              "Data Warga & Rumah",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDataWargaExpanded ? activeColor : inactiveColor,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              buildNavTile(
                title: "Rumah - Tambah",
                icon: Icons.house_outlined,
                route: '/data_warga_rumah/tambahRumah',
              ),
              buildNavTile(
                title: "Warga - Tambah",
                icon: Icons.people_alt_outlined,
                route: '/data_warga_rumah/tambahWarga',
              ),
            ],
          ),

          // menu Pemasukan
          ExpansionTile(
            initiallyExpanded: isPemasukanExpanded,
            leading: Icon(
              Icons.request_page_outlined,
              color: isPemasukanExpanded ? activeColor : inactiveColor,
            ),
            title: Text(
              "Pemasukan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPemasukanExpanded ? activeColor : inactiveColor,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              buildNavTile(
                title: "Tagih Iuran",
                icon: Icons.payments_outlined,
                route: '/Pemasukan/tagihIuran',
              ),
              buildNavTile(
                title: "Pemasukan Lain - Daftar",
                icon: Icons.payments_outlined,
                route: '/Pemasukan/PemasukanLainDaftar',
              ),
              buildNavTile(
                title: "Pemasukan Lain - Tambah",
                icon: Icons.payments_outlined,
                route: '/Pemasukan/PemasukanLainTambah',
              ),
            ],
          ),

          // Pengeluaran
          ExpansionTile(
            initiallyExpanded: isPengeluaranExpanded,
            leading: Icon(
              Icons.home_work_rounded,
              color: isPengeluaranExpanded ? activeColor : inactiveColor,
            ),
            title: Text(
              "Pengeluaran",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPengeluaranExpanded ? activeColor : inactiveColor,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              buildNavTile(
                // context: context,
                title: "Daftar - Pengeluaran",
                icon: Icons.list_alt_outlined,
                route: '/Pengeluaran/daftarPengeluaran',
              ),
              buildNavTile(
                // context: context,
                title: "Tambah - Pengeluaran",
                icon: Icons.add_circle_outline,
                route: '/Pengeluaran/tambahPengeluaran',
              ),
            ],
          ),

          // Laporan Keuangan
          ExpansionTile(
            initiallyExpanded: isLapKeuExpanded,
            leading: Icon(
              Icons.request_page_outlined,
              color: isLapKeuExpanded ? activeColor : inactiveColor,
            ),
            title: Text(
              "Laporan Keuangan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isLapKeuExpanded ? activeColor : inactiveColor,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              buildNavTile(
                // context: context,
                title: "Semua Pengeluaran",
                icon: Icons.payments_outlined,
                route: '/laporanKeuangan/semuaPengeluaran',
              ),
              buildNavTile(
                // context: context,
                title: "Semua Pemasukan",
                icon: Icons.payments_outlined,
                route: '/laporanKeuangan/semuaPemasukan',
              ),
              buildNavTile(
                // context: context,
                title: "Cetak Laporan",
                icon: Icons.print_outlined,
                route: '/laporanKeuangan/cetakLaporan',
              ),
            ],
          ),
          // const Divider(),
          // Profil admin
          // Kegiatan dan Broadcast
          ExpansionTile(
            initiallyExpanded: isKegiatanExpanded,
            leading: Icon(
              Icons.event_note_outlined,
              color: isKegiatanExpanded ? activeColor : inactiveColor,
            ),
            title: Text(
              "Kegiatan dan Broadcast",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isKegiatanExpanded ? activeColor : inactiveColor,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              buildNavTile(
                title: "Kegiatan - Daftar",
                icon: Icons.list_alt_outlined,
                route: '/kegiatan/daftar',
              ),
              buildNavTile(
                title: "Kegiatan - Tambah",
                icon: Icons.add_circle_outline,
                route: '/kegiatan/tambah',
              ),
              buildNavTile(
                title: "Broadcast - Daftar",
                icon: Icons.campaign_outlined,
                route: '/kegiatan/daftarbroad',
              ),
              buildNavTile(
                title: "Broadcast - Tambah",
                icon: Icons.add_alert_outlined,
                route: '/kegiatan/tambahbroad',
              ),
            ],
          ),

          const Divider(),

          // --- Profil Admin ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    content: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
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
                                email,
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          context.go('/');
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.logout, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              "Log out",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
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
                        email,
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
}
