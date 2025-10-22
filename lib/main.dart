import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/KegiatandanBroadcast/KegiatanDaftar.dart';
import 'package:jawara/KegiatandanBroadcast/KegiatanTambah.dart';
import 'package:jawara/KegiatandanBroadcast/BroadcastDaftar.dart';
import 'package:jawara/KegiatandanBroadcast/BroadcastTambah.dart';
import 'package:jawara/data_warga_rumah/keluarga_page.dart';
import 'package:jawara/Pemasukan/tagihan_page.dart';
import 'package:jawara/Pemasukan/kategori_iuran_page.dart';
import 'package:jawara/Pemasukan/tagih_iuran_page.dart';
import 'package:jawara/data_warga_rumah/daftar_rumah_page.dart';
import 'package:jawara/data_warga_rumah/daftar_warga_page.dart';
import 'package:jawara/data_warga_rumah/tambahRumah_page.dart';
import 'package:jawara/data_warga_rumah/tambahWarga_page.dart';
import 'pages/login_page.dart';
import 'Dashboard/Kegiatan.dart';
import 'Dashboard/Kependudukan.dart';
import 'Dashboard/Keuangan.dart';
import 'Pengeluaran/DaftarPengeluaran.dart';
import 'Pengeluaran/TambahPengeluaran.dart';
import 'Laporan Keuangan/SemuaPengeluaran.dart';
import 'Laporan Keuangan/SemuaPemasukan.dart';
import 'Laporan Keuangan/CetakLaporan.dart';
import 'Pemasukan/PemasukanLainDaftar.dart';
import 'Pemasukan/PemasukanLainTambah.dart';
import 'PesanWarga/InformasiAspirasi.dart';
import 'PenerimaanWarga/PenerimaanWarga.dart';
import 'MutasiKeluarga/Daftar.dart';
import 'MutasiKeluarga/Tambah.dart';
import 'Log Aktivitas/SemuaAktifitas.dart';
import 'Manajemen Pengguna/DaftarPengguna.dart';
import 'Manajemen Pengguna/TambahPengguna.dart';
import 'Channel Transfer/DaftarChannel.dart';
import 'Channel Transfer/TambahChannel.dart';

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
          path: '/Pengeluaran/daftarPengeluaran',
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
          path: '/Pemasukan/PemasukanLainTambah',
          builder: (context, state) => const PemasukanLainTambah(),
        ),

        GoRoute(
          path: '/Pemasukan/PemasukanLainDaftar',
          builder: (context, state) => const PemasukanLainDaftar(),
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
          path: '/data_warga_rumah/keluarga',
          builder: (context, state) => const DataKeluargaPage(),
        ),
        GoRoute(
          path: '/data_warga_rumah/daftarRumah',
          builder: (context, state) => const DaftarRumahPage(),
        ),
        GoRoute(
          path: '/data_warga_rumah/daftarWarga',
          builder: (context, state) => const DaftarWargaPage(),
        ),
        GoRoute(
          path: '/Pemasukan/tagihIuran',
          builder: (context, state) => const TagihIuranPage(),
        ),
        GoRoute(
          path: '/Pemasukan/kategoriIuran',
          builder: (context, state) => const KategoriIuranPage(),
        ),
        GoRoute(
          path: '/Pemasukan/tagihan',
          builder: (context, state) => const TagihanPage(),
        ),
        GoRoute(
          path: '/kegiatan/daftar',
          builder: (context, state) => const KegiatanDaftarPage(),
        ),
        GoRoute(
          path: '/kegiatan/tambah',
          builder: (context, state) => const KegiatanTambahPage(),
        ),
        GoRoute(
          path: '/kegiatan/daftarbroad',
          builder: (context, state) => const BroadcastDaftarPage(),
        ),
        GoRoute(
          path: '/kegiatan/tambahbroad',
          builder: (context, state) => const BroadcastTambahPage(),
        ),
        GoRoute(
          path: '/pesan/informasi',
          builder: (context, state) => const InformasiAspirasiPage(),
        ),
        GoRoute(
          path: '/penerimaan/warga',
          builder: (context, state) => const PenerimaanWargaPage(),
        ),
        GoRoute(
          path: '/mutasi/daftar',
          builder: (context, state) => const DaftarPage(),
        ),
        GoRoute(
          path: '/mutasi/tambah',
          builder: (context, state) => const BuatMutasiKeluargaPage(),
        ),
        GoRoute(
          path: '/log/daftar',
          builder: (context, state) => const RiwayatAktivitasPage(),
        ),
        GoRoute(
          path: '/user/daftar',
          builder: (context, state) => const DaftarPenggunaPage(),
        ),
        GoRoute(
          path: '/user/tambah',
          builder: (context, state) => const TambahAkunPenggunaPage(),
        ),
        GoRoute(
          path: '/channel/daftar',
          builder: (context, state) => const DaftarMetodePembayaranPage(),
        ),
        GoRoute(
          path: '/channel/tambah',
          builder: (context, state) => const BuatTransferChannelPage(),
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
