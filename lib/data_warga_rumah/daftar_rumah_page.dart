// import 'package:flutter/material.dart';
// import 'package:jawara/services/rumah_service.dart';
// import 'rumah_form_page.dart';
// import 'rumah_detail_page.dart';
// import 'package:go_router/go_router.dart';

// import 'package:jawara/widgets/appDrawer.dart';

// class RumahListPage extends StatefulWidget {
//   const RumahListPage({super.key});

//   @override
//   State<RumahListPage> createState() => _RumahListPageState();
// }

// class _RumahListPageState extends State<RumahListPage> {
//   List<Map<String, dynamic>> rumahList = [];
//   bool loading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     try {
//       final data = await RumahService.getAll();
//       setState(() {
//         rumahList = data;
//         loading = false;
//       });
//     } catch (e) {
//       setState(() => loading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Daftar Rumah"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => context.go('/beranda/semua_menu'),
//         ),
//       ),

//       // drawer: const AppDrawer(email: 'admin1@mail.com'),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: rumahList.length,
//               itemBuilder: (_, i) {
//                 final r = rumahList[i];
//                 return ListTile(
//                   title: Text(r['kode']),
//                   subtitle: Text("Alamat: ${r['alamat']}"),
//                   trailing: const Icon(Icons.chevron_right),
//                   onTap: () async {
//                     await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => RumahDetailPage(rumah: r),
//                       ),
//                     );
//                     fetchData();
//                   },
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const RumahFormPage()),
//           );
//           if (result == true) fetchData();
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:jawara/services/rumah_service.dart';
import 'rumah_form_page.dart';
import 'rumah_detail_page.dart';
import 'package:go_router/go_router.dart';

class RumahListPage extends StatefulWidget {
  const RumahListPage({super.key});

  @override
  State<RumahListPage> createState() => _RumahListPageState();
}

class _RumahListPageState extends State<RumahListPage> {
  List<Map<String, dynamic>> rumahList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await RumahService.getAll();
      setState(() {
        rumahList = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryGreen),
          onPressed: () => context.go('/beranda/semua_menu'),
        ),
        title: const Text(
          "Daftar Rumah",
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen),
        ),
      ),

      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primaryGreen, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RumahFormPage()),
            ).then((_) => fetchData()),
            child: const Center(
              child: Icon(Icons.add, color: primaryGreen, size: 30),
            ),
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
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: rumahList.map((r) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              r['kode'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text("Alamat: ${r['alamat']}"),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: primaryGreen, // icon hijau
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RumahDetailPage(rumah: r),
                              ),
                            ).then((_) => fetchData()),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
