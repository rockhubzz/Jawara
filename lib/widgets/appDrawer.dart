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
    final bool isDashboardExpanded =
        currentPath.startsWith('/home') ||
        currentPath.startsWith('/kependudukan');
    final bool isPengeluaranExpanded = currentPath.startsWith('/Pengeluaran');
    final bool isPemasukanExpanded = currentPath.startsWith('/pemasukan');

    debugPrint('Current Path: $currentPath');

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

          // Dashboard
          ExpansionTile(
            initiallyExpanded: isDashboardExpanded,
            leading: const Icon(Icons.dashboard, color: Colors.blueAccent),
            title: const Text(
              "Dashboard",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            childrenPadding: const EdgeInsets.only(left: 32),
            children: [
              ListTile(
                leading: const Icon(Icons.directions_walk, color: Colors.black),
                title: const Text("Kegiatan"),
                onTap: () {
                  context.pop();
                  context.go('/home');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.black,
                ),
                title: const Text("Keuangan"),
                onTap: () {
                  Navigator.pop(context);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.go('/keuangan');
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.people, color: Colors.black),
                title: const Text("Kependudukan"),
                onTap: () {
                  Navigator.pop(context);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.go('/kependudukan');
                  });
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.black,
                ),
                title: const Text("Tambah Kegiatan"),
                onTap: () {
                  Navigator.pop(context);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.go('/addKegiatan');
                  });
                },
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
                context: context,
                title: "Daftar - Pengeluaran",
                icon: Icons.list_alt_outlined,
                route: '/Pengeluaran',
              ),
              buildNavTile(
                context: context,
                title: "Tambah - Pengeluaran",
                icon: Icons.add_circle_outline,
                route: '/Pengeluaran/tambahPengeluaran',
              ),
            ],
          ),

          // Pemasukan
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
                context: context,
                title: "Tagih Iuran",
                icon: Icons.payments_outlined,
                route: '/pemasukan/tagihIuran',
              ),
            ],
          ),

          const Divider(),

          // Profil admin
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
