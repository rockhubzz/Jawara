import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final String email;

  const AppDrawer({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.email,
  });

  // Warna utama hijau tua
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFFE8F3EB);

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/warga');
        break;
      case 2:
        context.go('/tambah');
        break;
      case 3:
        context.go('/keuangan');
        break;
      case 4:
        context.go('/menu');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔵 APPBAR MODERN
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Image.asset("assets/images/logo_jawara.png", width: 40, height: 40),
            const SizedBox(width: 10),
            const Text(
              "Jawara App",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
          ],
        ),
      ),

      // 🔥 BODY DARI HALAMAN
      body: body,

      // 🔥 TOMBOL TENGAH (FAB)
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 235, 188),
              Color.fromARGB(255, 181, 255, 183),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          elevation: 0,
          onPressed: () => _onTap(context, 2),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 🔥 BOTTOM NAVIGATION
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                icon: Icons.home_outlined,
                label: "Beranda",
                isActive: currentIndex == 0,
                onTap: () => _onTap(context, 0),
              ),
              _navItem(
                icon: Icons.account_balance_wallet_outlined,
                label: "Kas",
                isActive: currentIndex == 1,
                onTap: () => _onTap(context, 1),
              ),

              const SizedBox(width: 40), // ruang FAB

              _navItem(
                icon: Icons.people_alt_outlined,
                label: "Warga",
                isActive: currentIndex == 3,
                onTap: () => _onTap(context, 3),
              ),
              _navItem(
                icon: Icons.logout,
                label: "Keluar",
                isActive: currentIndex == 4,
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 NAV ITEM
  Widget _navItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? primaryGreen : Colors.grey,
              size: isActive ? 28 : 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? primaryGreen : Colors.grey,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // supaya tidak tertutup saat klik luar
      builder: (context) {
        return AlertDialog(
          backgroundColor: lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Konfirmasi Keluar",
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen),
          ),
          content: const Text(
            "Apakah Anda yakin ingin keluar dari aplikasi?",
            style: TextStyle(color: Colors.black87, fontSize: 14),
          ),
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: primaryGreen),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Tidak",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/');
                },
                child: const Text(
                  "Iya, Keluar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
