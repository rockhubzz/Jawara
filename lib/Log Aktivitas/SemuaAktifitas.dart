import 'package:flutter/material.dart';
import '../widgets/appDrawer.dart';

class RiwayatAktivitasPage extends StatefulWidget {
  const RiwayatAktivitasPage({super.key});

  @override
  State<RiwayatAktivitasPage> createState() => _RiwayatAktivitasPageState();
}

class _RiwayatAktivitasPageState extends State<RiwayatAktivitasPage> {
  int currentPage = 1;
  final int totalPages = 18;
  final int itemsPerPage = 10;

  final List<String> deskripsiList = [
    'Menugaskan tagihan : Bersih Desa periode Oktober',
    'Membuat broadcast baru: Pengumuman',
    'Menugaskan tagihan : Bersih Desa periode Oktober',
    'Mendownload laporan keuangan',
    'Menambahkan iuran baru: asad',
    'Menugaskan tagihan : Mingguan periode Oktober',
    'Menugaskan tagihan : Mingguan periode Oktober',
    'Menugaskan tagihan : Mingguan periode Oktober',
    'Menambahkan iuran baru: yyy',
    'Menugaskan tagihan : Mingguan periode Oktober',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      drawer: const AppDrawer(email: 'admin1@mail.com'),

      appBar: AppBar(
        title: const Text(
          'Riwayat Aktivitas',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: Container(
          width: 700,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Filter Button
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF635BFF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.filter_alt, color: Colors.white),
                label: const Text('', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),

              // Table Header
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child: Text(
                          'NO',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child: Text(
                          'DESKRIPSI',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Table Rows
              Expanded(
                child: ListView.builder(
                  itemCount: deskripsiList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: Text(
                                deskripsiList[index],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Pagination
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: currentPage > 1
                        ? () => setState(() => currentPage--)
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  ..._buildPageButtons(),
                  IconButton(
                    onPressed: currentPage < totalPages
                        ? () => setState(() => currentPage++)
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageButtons() {
    List<Widget> buttons = [];

    buttons.addAll([
      _pageButton(1),
      if (currentPage > 3) const Text('...'),
      if (currentPage > 1 && currentPage < totalPages) _pageButton(currentPage),
      if (currentPage < totalPages - 2) const Text('...'),
      _pageButton(totalPages),
    ]);

    return buttons;
  }

  Widget _pageButton(int page) {
    final bool isActive = currentPage == page;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => setState(() => currentPage = page),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive
              ? const Color(0xFF635BFF)
              : Colors.grey.shade200,
          foregroundColor: isActive ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text('$page'),
      ),
    );
  }
}
