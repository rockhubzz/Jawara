import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  final String email;

  const AppDrawer({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    String currentPath = '/home';
    currentPath = GoRouterState.of(context).uri.toString();
    final bool isDashboardExpanded =
        currentPath.startsWith('/home') ||
        currentPath.startsWith('/kependudukan');
    debugPrint('Current Path: $currentPath');

    return Drawer(
      child: Column(
        children: [
          // ========= TOP CONTENT (Menus) =========
          Expanded(
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

                // --- Dashboard (with submenu) ---
                ExpansionTile(
                  initiallyExpanded: isDashboardExpanded,
                  leading: const Icon(
                    Icons.dashboard,
                    color: Colors.blueAccent,
                  ),
                  title: const Text(
                    "Dashboard",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  childrenPadding: const EdgeInsets.only(left: 32),
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.directions_walk,
                      label: "Kegiatan",
                      route: '/home',
                      currentPath: currentPath,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.people,
                      label: "Kependudukan",
                      route: '/kependudukan',
                      currentPath: currentPath,
                    ),
                  ],
                ),

                // --- Tambah Kegiatan ---
                _buildMenuItem(
                  context,
                  icon: Icons.add_circle_outline,
                  label: "Tambah Kegiatan",
                  route: '/addKegiatan',
                  currentPath: currentPath,
                ),

                const Divider(),
              ],
            ),
          ),

          // ========= BOTTOM SECTION (Logout/Profile) =========
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
                                'admin1@mail.com',
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

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required String currentPath,
  }) {
    final bool isSelected = currentPath == route;

    return Container(
      color: isSelected ? Colors.blue.shade50 : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blueAccent : Colors.black,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blueAccent : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          context.pop(); // close drawer
          context.go(route);
        },
      ),
    );
  }
}
