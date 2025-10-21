import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  final String email;

  const AppDrawer({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    String currentPath = GoRouterState.of(context).uri.toString();
    final bool isDashboardExpanded = currentPath.startsWith('/dashboard');
    final bool isDataWargaExpanded = currentPath.startsWith('/data_warga_rumah');
    final bool isPemasukanExpanded = currentPath.startsWith('/pemasukan');

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

          // --- Dashboard with submenus ---
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
              Icons
                  .home_work_rounded, 
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
                title: "Rumah - Daftar",
                icon: Icons.apartment_outlined, 
                route: '/data_warga_rumah/daftarRumah',
              ),
              buildNavTile(
                title: "Warga - Tambah",
                icon: Icons.people_alt_outlined, 
                route: '/data_warga_rumah/tambahWarga',
              ),
              buildNavTile(
                title: "Warga - Daftar",
                icon: Icons.apartment_outlined, 
                route: '/data_warga_rumah/daftarWarga',
              ),
            ],
          ),

          // menu Pemasukan
          ExpansionTile(
            initiallyExpanded: isPemasukanExpanded,
            leading: Icon(
              Icons
                  .request_page_outlined, 
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
                route: '/pemasukan/tagihIuran',
              ),
            ],
          ),

          const Divider(),

          buildNavTile(
            title: "Tambah Kegiatan",
            icon: Icons.add_circle_outline,
            route: '/kegiatan/tambah',
          ),

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
