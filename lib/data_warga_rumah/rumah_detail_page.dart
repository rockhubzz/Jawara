// import 'package:flutter/material.dart';
// import 'rumah_form_page.dart';
// import 'package:jawara/services/rumah_service.dart';

// class RumahDetailPage extends StatelessWidget {
//   final Map<String, dynamic> rumah;

//   const RumahDetailPage({super.key, required this.rumah});

//   Widget _row(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(rumah['kode'])),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _row("No. Rumah", rumah['kode']),
//             _row("Alamat", rumah['alamat']),
//             _row("Status", rumah['status'] ?? "-"),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 ElevatedButton(
//                   child: const Text("Edit"),
//                   onPressed: () async {
//                     final res = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => RumahFormPage(data: rumah),
//                       ),
//                     );
//                     if (res == true) Navigator.pop(context, true);
//                   },
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                   onPressed: () async {
//                     final confirm = await showDialog(
//                       context: context,
//                       builder: (_) => AlertDialog(
//                         title: const Text("Hapus Rumah?"),
//                         content: const Text(
//                           "Data akan dihapus secara permanen.",
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text("Batal"),
//                           ),
//                           ElevatedButton(
//                             onPressed: () => Navigator.pop(context, true),
//                             child: const Text("Hapus"),
//                           ),
//                         ],
//                       ),
//                     );

//                     if (confirm == true) {
//                       await RumahService.delete(rumah['id']);
//                       Navigator.pop(context, true);
//                     }
//                   },
//                   child: const Text("Hapus"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'rumah_form_page.dart';
import 'package:jawara/services/rumah_service.dart';
import 'package:go_router/go_router.dart';

class RumahDetailPage extends StatelessWidget {
  final Map<String, dynamic> rumah;

  const RumahDetailPage({super.key, required this.rumah});

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);
    const Color lightGreen = Color(0xFFE0F2F1);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(rumah['kode']),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryGreen),
          onPressed: () => context.pop(),
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
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row("No. Rumah", rumah['kode']),
                    _row("Alamat", rumah['alamat']),
                    _row("Status", rumah['status'] ?? "-"),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        // EDIT BUTTON
                        Container(
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RumahFormPage(data: rumah),
                                ),
                              );
                              if (res == true) context.pop(true);
                            },
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // DELETE BUTTON
                        Container(
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  backgroundColor: lightGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text(
                                    "Hapus Rumah",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryGreen,
                                    ),
                                  ),
                                  content: const Text(
                                    "Data akan dihapus secara permanen.",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                  actionsPadding: const EdgeInsets.only(
                                    bottom: 10,
                                    right: 10,
                                  ),
                                  actions: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: primaryGreen,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text(
                                        "Batal",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: primaryGreen,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text(
                                          "Hapus",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await RumahService.delete(rumah['id']);
                                context.pop(true);
                              }
                            },
                            child: const Text(
                              "Hapus",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
