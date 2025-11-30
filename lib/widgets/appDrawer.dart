import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/services/user_service.dart';

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
    final bool isPesanExpanded = currentPath.startsWith('/pesan');
    final bool isPenerimaanExpanded = currentPath.startsWith('/penerimaan');
    final bool isMutasiExpanded = currentPath.startsWith('/mutasi');
    final bool isLogAktivitasExpanded = currentPath.startsWith('/log');
    final bool isManajemenPenggunaExpanded = currentPath.startsWith('/user');
    final bool isChannelExpanded = currentPath.startsWith('/channel');

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
                title: "Keuangan",
                icon: Icons.account_balance_wallet,
                route: '/dashboard/keuangan',
              ),
              buildNavTile(
                title: "Kegiatan",
                icon: Icons.directions_walk,
                route: '/dashboard/kegiatan',
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
                title: "Warga",
                icon: Icons.groups_2_outlined,
                route: '/data_warga_rumah/daftarWarga',
              ),
              buildNavTile(
                title: "Keluarga",
                icon: Icons.family_restroom_outlined,
                route: '/data_warga_rumah/keluarga',
              ),
              buildNavTile(
                title: "Rumah",
                icon: Icons.home_work_outlined,
                route: '/data_warga_rumah/daftarRumah',
              ),
            ],
          ),

          // menu Pemasukan
          ExpansionTile(
            initiallyExpanded: isPemasukanExpanded,
            leading: Icon(
              Icons.account_balance_wallet_outlined,
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
                title: "Kategori Iuran",
                icon: Icons.category_outlined,
                route: '/Pemasukan/kategoriIuran',
              ),
              buildNavTile(
                title: "Tagih Iuran",
                icon: Icons.attach_money_outlined,
                route: '/Pemasukan/tagihIuran',
              ),
              buildNavTile(
                title: "Tagihan",
                icon: Icons.receipt_long_outlined,
                route: '/Pemasukan/tagihan',
              ),
              buildNavTile(
                title: "Pemasukan Lain - Daftar",
                icon: Icons.list_alt_outlined,
                route: '/Pemasukan/PemasukanLainDaftar',
              ),
              buildNavTile(
                title: "Pemasukan Lain - Tambah",
                icon: Icons.add_card_outlined,
                route: '/Pemasukan/PemasukanLainTambah',
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
                title: "Semua Pemasukan",
                icon: Icons.trending_up_outlined,
                route: '/laporanKeuangan/semuaPemasukan',
              ),
              buildNavTile(
                // context: context,
                title: "Semua Pengeluaran",
                icon: Icons.trending_down_outlined,
                route: '/laporanKeuangan/semuaPengeluaran',
              ),
              buildNavTile(
                // context: context,
                title: "Cetak Laporan",
                icon: Icons.picture_as_pdf_outlined,
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

          // pesan warga
          ExpansionTile(
            initiallyExpanded: isPesanExpanded,
            leading: Icon(
              Icons.message_outlined,
              color: isPesanExpanded ? activeColor : inactiveColor,
            ),
            title: Text(
              "Pesan Warga",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPesanExpanded ? activeColor : inactiveColor,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              buildNavTile(
                title: "Informasi Aspirasi",
                icon: Icons.feedback_outlined,
                route: '/pesan/informasi',
              ),
            ],
          ),

          // penerimaan warga
          ExpansionTile(
            initiallyExpanded: isPenerimaanExpanded,
            leading: Icon(
              Icons.how_to_reg_outlined,
              color: isPenerimaanExpanded ? activeColor : inactiveColor,
            ),
            title: Text(
              "Penerimaan Warga",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPenerimaanExpanded ? activeColor : inactiveColor,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              buildNavTile(
                title: "Penerimaan Warga",
                icon: Icons.person_add_alt_outlined,
                route: '/penerimaan/warga',
              ),
            ],
          ),

          // mutasi keluarga
          ExpansionTile(
            initiallyExpanded: isMutasiExpanded,
            leading: Icon(
              Icons.sync_alt,
              color: isMutasiExpanded ? activeColor : inactiveColor,
            ),
            title: Text(
              "Mutasi Keluarga",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMutasiExpanded ? activeColor : inactiveColor,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              buildNavTile(
                title: "Daftar Mutasi Keluarga",
                icon: Icons.list_alt_outlined,
                route: '/mutasi/daftar',
              ),
              buildNavTile(
                title: "Tambah Mutasi Keluarga",
                icon: Icons.add_circle_outline,
                route: '/mutasi/tambah',
              ),
            ],
          ),
          ExpansionTile(
            initiallyExpanded: isLogAktivitasExpanded,
            leading: Icon(
              Icons.receipt_long_rounded,
              color: isLogAktivitasExpanded ? activeColor : inactiveColor,
            ),
            title: Text(
              "Log Aktivitas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isLogAktivitasExpanded ? activeColor : inactiveColor,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              buildNavTile(
                title: "Semua Aktivitas",
                icon: Icons.local_activity_rounded,
                route: '/log/daftar',
              ),
            ],
          ),

          ExpansionTile(
            initiallyExpanded: isManajemenPenggunaExpanded,
            leading: Icon(
              Icons.supervised_user_circle_outlined,
              color: isManajemenPenggunaExpanded ? activeColor : inactiveColor,
            ),
            title: Text(
              "Manajemen Pengguna",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isManajemenPenggunaExpanded
                    ? activeColor
                    : inactiveColor,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              buildNavTile(
                title: "Daftar Pengguna",
                icon: Icons.list_alt_sharp,
                route: '/user/daftar',
              ),
              buildNavTile(
                title: "Tambah Pengguna",
                icon: Icons.add_circle_outline_outlined,
                route: '/user/tambah',
              ),
            ],
          ),

          ExpansionTile(
            initiallyExpanded: isChannelExpanded,
            leading: Icon(
              Icons.attach_money_sharp,
              color: isChannelExpanded ? activeColor : inactiveColor,
            ),
            title: Text(
              "Channel Transfer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isChannelExpanded ? activeColor : inactiveColor,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              buildNavTile(
                title: "Daftar Channel Transfer",
                icon: Icons.list_alt_sharp,
                route: '/channel/daftar',
              ),
              buildNavTile(
                title: "Tambah Channel Transfer",
                icon: Icons.add_circle_outline_outlined,
                route: '/channel/tambah',
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
                              FutureBuilder<String?>(
                                future: UserService.getUsername(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                      "Loading...",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    );
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Text(
                                      "Unknown User",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    );
                                  }

                                  return Text(
                                    snapshot.data!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
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
                      FutureBuilder<String?>(
                        future: UserService.getUsername(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              "Loading...",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Text(
                              "Unknown User",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            );
                          }

                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      FutureBuilder<String?>(
                        future: UserService.getEmail(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              "Loading...",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Text(
                              "Unknown Email",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            );
                          }

                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          );
                        },
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
