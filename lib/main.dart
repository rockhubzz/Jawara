import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/pemasukan/tagih_iuran_page.dart';
import 'Kegiatan & Broadcast/KegiatanTambah.dart';
import 'pages/login_page.dart';
import 'Dashboard/Kegiatan.dart';
import 'Dashboard/Kependudukan.dart';
import 'Dashboard/Keuangan.dart';
import 'data_warga_rumah/tambahRumah_page.dart';
import 'data_warga_rumah/tambahWarga_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: [
        // debug mode
        // GoRoute(
        //   path: '/',
        //   builder: (context, state) => const HomePage(email: 'raki@mail.com'),
        // ),

        //present
        GoRoute(path: '/', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/dashboard/kegiatan',
          builder: (context, state) {
            final loggedInUserEmail = state.extra as String?;
            return HomePage(email: loggedInUserEmail ?? 'Unknown User');
          },
        ),
        GoRoute(
          path: '/dashboard/kependudukan',
          builder: (context, state) => const KependudukanPage(),
        ),

        GoRoute(
          path: '/dashboard/keuangan',
          builder: (context, state) => const Keuangan(),
        ),
        GoRoute(
          path: '/kegiatan/tambah',
          builder: (context, state) => const AddKegiatanPage(),
        ),
        GoRoute(
          path: '/data_warga_rumah/tambahRumah',
          builder: (context, state) => const TambahRumahPage(),
        ),
        GoRoute(
          path: '/data_warga_rumah/tambahWarga',
          builder: (context, state) => const TambahWargaPage(),
        ),
        GoRoute(
          path: '/pemasukan/tagihIuran',
          builder: (context, state) => const TagihIuranPage(),
        ),
        //end route
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Jawara App',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}