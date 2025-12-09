import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SemuaMenuPage extends StatefulWidget {
  const SemuaMenuPage({super.key});

  @override
  State<SemuaMenuPage> createState() => _SemuaMenuPageState();
}

class _SemuaMenuPageState extends State<SemuaMenuPage> {
  final Color primaryGreen = const Color(0xFF2E7D32);
  final TextEditingController searchController = TextEditingController();

  // MenuSection untuk tiap kategori
  late List<MenuSection> allMenuSections;

  @override
  void initState() {
    super.initState();

    allMenuSections = [
      MenuSection(
        title: "DATA WARGA & RUMAH",
        items: [
          MenuItem(
            "Warga Daftar",
            Icons.people,
            Colors.green,
            onTap: () => context.go('/data_warga_rumah/daftarWarga'),
          ),
          MenuItem(
            "Warga Tambah",
            Icons.person_add,
            Colors.teal,
            onTap: () => context.go('/data_warga_rumah/tambahWarga'),
          ),
          MenuItem(
            "Rumah Daftar",
            Icons.house,
            Colors.blue,
            onTap: () => context.go('/data_warga_rumah/daftarRumah'),
          ),
          MenuItem(
            "Rumah Tambah",
            Icons.home_work,
            Colors.indigo,
            onTap: () => context.go('/data_warga_rumah/tambahRumah'),
          ),
          MenuItem(
            "Keluarga",
            Icons.family_restroom,
            Colors.orange,
            onTap: () => context.go('/data_warga_rumah/keluarga'),
          ),
        ],
      ),
      MenuSection(
        title: "PEMASUKAN RT",
        items: [
          MenuItem(
            "Kategori Iuran",
            Icons.category,
            Colors.blue,
            onTap: () => context.go('/pemasukan/kategori_iuran'),
          ),
          MenuItem(
            "Tagih Iuran",
            Icons.request_page,
            Colors.green,
            onTap: () => context.go('/pemasukan/tagih_iuran'),
          ),
          MenuItem(
            "Tagihan",
            Icons.receipt_long,
            Colors.red,
            onTap: () => context.go('/pemasukan/tagihan'),
          ),
          MenuItem(
            "Daftar Pemasukan Lainnya",
            Icons.add_chart,
            Colors.purple,
            onTap: () => context.go('/pemasukan/lain_daftar'),
          ),
          MenuItem(
            "Tambah Pemasukan Lainnya",
            Icons.playlist_add,
            Colors.teal,
            onTap: () => context.go('/pemasukan/lain_tambah'),
          ),
        ],
      ),
      MenuSection(
        title: "KEGIATAN & BROADCAST",
        items: [
          MenuItem(
            "Kegiatan Daftar",
            Icons.event_note,
            Colors.blue,
            onTap: () => context.go('/kegiatan/daftar'),
          ),
          MenuItem(
            "Kegiatan Tambah",
            Icons.event_available,
            Colors.green,
            onTap: () => context.go('/kegiatan/tambah/new'),
          ),
          MenuItem(
            "Broadcast Daftar",
            Icons.campaign,
            Colors.purple,
            onTap: () => context.go('/kegiatan/daftar_broad'),
          ),
          MenuItem(
            "Broadcast Tambah",
            Icons.add_alert,
            Colors.teal,
            onTap: () => context.go('/kegiatan/tambah_broad'),
          ),
        ],
      ),
      // MenuSection(
      //   title: "PESAN & ASPIRASI WARGA",
      //   items: [
      //     MenuItem(
      //       "Informasi Aspirasi",
      //       Icons.forum,
      //       Colors.blue,
      //       onTap: () => context.go('/pesan/informasi'),
      //     ),
      //   ],
      // ),
      // MenuSection(
      //   title: "PENERIMAAN WARGA BARU",
      //   items: [
      //     MenuItem(
      //       "Penerimaan Warga",
      //       Icons.how_to_reg,
      //       Colors.green,
      //       onTap: () => context.go('/penerimaan/warga'),
      //     ),
      //   ],
      // ),
      MenuSection(
        title: "MUTASI KELUARGA",
        items: [
          MenuItem(
            "Daftar Mutasi",
            Icons.list_alt,
            Colors.orange,
            onTap: () => context.go('/mutasi_keluarga/daftar'),
          ),
          MenuItem(
            "Tambah Mutasi",
            Icons.add_box,
            Colors.teal,
            onTap: () => context.go('/mutasi_keluarga/tambah'),
          ),
        ],
      ),
      // MenuSection(
      //   title: "LOG AKTIVITAS",
      //   items: [
      //     MenuItem(
      //       "Semua Aktivitas",
      //       Icons.list_alt,
      //       Colors.blue,
      //       onTap: () => context.go('/log_aktivitas/semua_aktivitas'),
      //     ),
      //   ],
      // ),
      MenuSection(
        title: "LAPORAN KEUANGAN",
        items: [
          MenuItem(
            "Semua Pemasukan",
            Icons.attach_money,
            Colors.teal,
            onTap: () => context.go('/laporan_keuangan/semua_pemasukan'),
          ),
          MenuItem(
            "Semua Pengeluaran",
            Icons.money_off_csred,
            Colors.orange,
            onTap: () => context.go('/laporan_keuangan/semua_pengeluaran'),
          ),
          MenuItem(
            "Cetak Laporan",
            Icons.print,
            Colors.red,
            onTap: () => context.go('/laporan_keuangan/cetak_laporan'),
          ),
        ],
      ),
      MenuSection(
        title: "MANAJEMEN PENGGUNA",
        items: [
          MenuItem(
            "Daftar Pengguna",
            Icons.manage_accounts,
            Colors.green,
            onTap: () => context.go('/user/daftar'),
          ),
          MenuItem(
            "Tambah Pengguna",
            Icons.person_add_alt_1,
            Colors.teal,
            onTap: () => context.go('/user/tambah'),
          ),
        ],
      ),
      MenuSection(
        title: "CHANNEL TRANSFER",
        items: [
          MenuItem(
            "Daftar Channel",
            Icons.tv,
            Colors.blue,
            onTap: () => context.go('/channel_transfer/daftar'),
          ),
          MenuItem(
            "Tambah Channel",
            Icons.add_to_queue,
            Colors.purple,
            onTap: () => context.go('/channel_transfer/tambah'),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2E7D32)),
          onPressed: () => context.go('/beranda'),
        ),
        title: const Text(
          "Semua Menu",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
      ),
      body: Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 SEARCH BAR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (query) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    hintText: "Pencarian...",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Render tiap section
              ...allMenuSections.map((section) {
                final filteredItems = section.items
                    .where(
                      (item) => item.title.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      ),
                    )
                    .toList();

                if (filteredItems.isEmpty) return Container();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildMenuGrid(filteredItems),
                    const SizedBox(height: 25),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuGrid(List<MenuItem> items) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((item) => buildMenuIcon(item)).toList(),
    );
  }

  Widget buildMenuIcon(MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(100),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
              ),
              Icon(item.icon, color: item.color, size: 26),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

// ---------------- MODEL ----------------
class MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  MenuItem(this.title, this.icon, this.color, {this.onTap});
}

class MenuSection {
  final String title;
  final List<MenuItem> items;

  MenuSection({required this.title, required this.items});
}
