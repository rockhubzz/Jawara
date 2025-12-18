import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final String username;

  const AppDrawer({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.username,
  });

  // WARNA SESUAI
  static const Color kombuGreen = Color(0xFF374426); // primary
  // static const Color timberwolf = Color(0xFFDFDDD1); // background

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/dashboard/keuangan');
        break;
      case 2:
        context.go('/beranda/tambah');
        break;
      case 3:
        context.go('/dashboard/kependudukan');
        break;
      case 4:
        _showLogoutDialog(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: timberwolf,

      // HEADER / APPBAR
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              "assets/images/logo_jawara.png",
              width: 36,
              height: 36,
              // color: Colors.white,
            ),
            const SizedBox(width: 10),
            const Text(
              "Jawara App",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 37, 44, 26),
              ),
            ),
          ],
        ),
      ),

      body: body,

      // FAB TENGAH
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: kombuGreen,
                shape: BoxShape.circle,
              ),
              child: RawMaterialButton(
                shape: const CircleBorder(),
                elevation: 0,
                onPressed: () => _onTap(context, 2),
                child: const Icon(Icons.add, size: 32, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // FOOTER / BOTTOM NAV
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black38,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 68,
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

              const SizedBox(width: 40), // space FAB

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
                onTap: () => _onTap(context, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NAV ITEM
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
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? kombuGreen : Colors.grey,
              size: isActive ? 28 : 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? kombuGreen : Colors.grey,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // LOGOUT DIALOG
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            "Konfirmasi Keluar",
            style: TextStyle(fontWeight: FontWeight.bold, color: kombuGreen),
          ),
          content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kombuGreen),
              onPressed: () {
                Navigator.pop(context);
                context.go('/');
              },
              child: const Text("Keluar"),
            ),
          ],
        );
      },
    );
  }
}
