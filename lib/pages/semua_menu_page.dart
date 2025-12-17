import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SemuaMenuPage extends StatefulWidget {
  const SemuaMenuPage({super.key});

  @override
  State<SemuaMenuPage> createState() => _SemuaMenuPageState();
}

class _SemuaMenuPageState extends State<SemuaMenuPage> {
  final Color kombuGreen = const Color(0xFF374426);
  final TextEditingController searchController = TextEditingController();

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
            () => context.go('/data_warga_rumah/daftarWarga?from=semua'),
          ),
          MenuItem(
            "Warga Tambah",
            Icons.person_add,
            Colors.teal,
            () => context.go('/data_warga_rumah/tambahWarga?from=semua'),
          ),
          MenuItem(
            "Rumah Daftar",
            Icons.house,
            Colors.blue,
            () => context.go('/data_warga_rumah/daftarRumah?from=semua'),
          ),
          MenuItem(
            "Rumah Tambah",
            Icons.home_work,
            Colors.indigo,
            () => context.go('/data_warga_rumah/tambahRumah?from=semua'),
          ),
          MenuItem(
            "Keluarga",
            Icons.family_restroom,
            Colors.orange,
            () => context.go('/data_warga_rumah/keluarga'),
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
            () => context.go('/pemasukan/kategori_iuran?from=semua'),
          ),
          MenuItem(
            "Tagih Iuran",
            Icons.request_page,
            Colors.green,
            () => context.go('/pemasukan/tagih_iuran?from=semua'),
          ),
          MenuItem(
            "Tagihan",
            Icons.receipt_long,
            Colors.red,
            () => context.go('/pemasukan/tagihan?from=semua'),
          ),
          MenuItem(
            "Pemasukan Lain",
            Icons.add_chart,
            Colors.purple,
            () => context.go('/pemasukan/lain_daftar?from=semua'),
          ),
        ],
      ),
      MenuSection(
        title: "KEGIATAN & BROADCAST",
        items: [
          MenuItem(
            "Kegiatan",
            Icons.event_note,
            Colors.blue,
            () => context.go('/kegiatan/daftar?from=semua'),
          ),
          MenuItem(
            "Tambah Kegiatan",
            Icons.event_available,
            Colors.green,
            () => context.go('/kegiatan/tambah/new?from=semua'),
          ),
          MenuItem(
            "Broadcast",
            Icons.campaign,
            Colors.purple,
            () => context.go('/kegiatan/daftar_broad'),
          ),
          // ✅ TAMBAH BROADCAST (DIPERBAIKI)
          MenuItem(
            "Tambah Broadcast",
            Icons.add_alert,
            Colors.orange,
            () => context.go('/kegiatan/tambah_broad?from=semua'),
          ),
        ],
      ),
      MenuSection(
        title: "MUTASI KELUARGA",
        items: [
          MenuItem(
            "Daftar Mutasi",
            Icons.list_alt,
            Colors.orange,
            () => context.go('/mutasi_keluarga/daftar'),
          ),
          MenuItem(
            "Tambah Mutasi",
            Icons.add_box,
            Colors.teal,
            () => context.go('/mutasi/tambah?from=semua'),
          ),
        ],
      ),
      MenuSection(
        title: "LAPORAN KEUANGAN",
        items: [
          MenuItem(
            "Pemasukan",
            Icons.attach_money,
            Colors.teal,
            () => context.go('/laporan_keuangan/semua_pemasukan'),
          ),
          MenuItem(
            "Pengeluaran",
            Icons.money_off,
            Colors.red,
            () => context.go('/laporan_keuangan/semua_pengeluaran'),
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
            () => context.go('/user/daftar'),
          ),
          MenuItem(
            "Tambah Pengguna",
            Icons.person_add_alt_1,
            Colors.teal,
            () => context.go('/user/tambah?from=semua'),
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
            () => context.go('/channel_transfer/daftar'),
          ),
          MenuItem(
            "Tambah Channel",
            Icons.add_to_queue,
            Colors.purple,
            () => context.go('/channel_transfer/tambah'),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: kombuGreen),
          onPressed: () => context.go('/beranda'),
        ),
        title: Text(
          "Semua Menu",
          style: TextStyle(color: kombuGreen, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 SEARCH BAR (DIPERBAIKI)
            Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kombuGreen),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: "Cari menu...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: kombuGreen),
                ),
              ),
            ),

            ...allMenuSections.map(_buildSectionCard).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(MenuSection section) {
    final filteredItems = section.items.where((item) {
      return item.title.toLowerCase().contains(
        searchController.text.toLowerCase(),
      );
    }).toList();

    if (filteredItems.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              return _buildMenuItem(filteredItems[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: item.color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ================= MODEL =================
class MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  MenuItem(this.title, this.icon, this.color, this.onTap);
}

class MenuSection {
  final String title;
  final List<MenuItem> items;

  MenuSection({required this.title, required this.items});
}
