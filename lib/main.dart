import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/pages/addKegiatan_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/kependudukan_page.dart';
import 'Dashboard/Keuangan.dart';
import 'Pengeluaran/DaftarPengeluaran.dart';
import 'Pengeluaran/TambahPengeluaran.dart';
import 'Laporan Keuangan/SemuaPengeluaran.dart';
import 'Laporan Keuangan/SemuaPemasukan.dart';
import 'Laporan Keuangan/CetakLaporan.dart';
import 'Pemasukan/PemasukanLainDaftar.dart';
import 'Pemasukan/PemasukanLainTambah.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LoginPage()),

        GoRoute(
          path: '/home',
          builder: (context, state) {
            final loggedInUserEmail = state.extra as String?;
            return HomePage(email: loggedInUserEmail ?? 'Unknown User');
          },
        ),

        GoRoute(
          path: '/kependudukan',
          builder: (context, state) => const KependudukanPage(),
        ),

        GoRoute(
          path: '/keuangan',
          builder: (context, state) => const Keuangan(),
        ),

        GoRoute(
          path: '/addKegiatan',
          builder: (context, state) => const AddKegiatanPage(),
        ),

        GoRoute(
          path: '/Pengeluaran',
          builder: (context, state) => const DaftarPengeluaranPage(),
        ),

        GoRoute(
          path: '/Pengeluaran/tambahPengeluaran',
          builder: (context, state) => const TambahPengeluaran(),
        ),

        GoRoute(
          path: '/laporanKeuangan/semuaPengeluaran',
          builder: (context, state) => const SemuaPengeluaran(),
        ),
        GoRoute(
          path: '/laporanKeuangan/semuaPemasukan',
          builder: (context, state) => const SemuaPemasukan(),
        ),
        GoRoute(
          path: '/laporanKeuangan/cetakLaporan',
          builder: (context, state) => const CetakLaporan(),
        ),

        GoRoute(
          path: '/Pemasukan',
          builder: (context, state) => const PemasukanLainDaftar(),
        ),

        GoRoute(
          path: '/Pemasukan/PemasukanLainTambah',
          builder: (context, state) => const PemasukanLainTambah(),
        ),
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
