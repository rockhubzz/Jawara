import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/channel_transfer/edit_channel_page.dart';
import 'package:jawara/data_warga_rumah/tambahRumah_page.dart';
import 'package:jawara/kegiatan_dan_brodcast/kegiatan_daftar_page.dart';
import 'package:jawara/kegiatan_dan_brodcast/kegiatan_tambah_page.dart';
import 'package:jawara/kegiatan_dan_brodcast/broadcast_daftar_page.dart';
import 'package:jawara/kegiatan_dan_brodcast/broadcast_tambah_page.dart';
import 'package:jawara/data_warga_rumah/keluarga_page.dart';
import 'package:jawara/pemasukan/tagihan_page.dart';
import 'package:jawara/pemasukan/kategori_iuran_page.dart';
import 'package:jawara/pemasukan/tagih_iuran_page.dart';
import 'package:jawara/data_warga_rumah/daftar_rumah_page.dart';
import 'package:jawara/data_warga_rumah/daftar_warga_page.dart';
import 'package:jawara/data_warga_rumah/tambahWarga_page.dart';
import 'package:jawara/pages/semua_menu_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'dashboard/kegiatan_page.dart';
import 'dashboard/kependudukan_page.dart';
import 'dashboard/keuangan_page.dart';
import 'pengeluaran/daftar_pengeluaran_page.dart';
import 'pengeluaran/tambah_pengeluaran_page.dart';
import 'laporan_keuangan/semua_pengeluaran_page.dart';
import 'laporan_keuangan/semua_pemasukan_page.dart';
import 'laporan_keuangan/cetak_laporan_page.dart';
import 'pemasukan/pemasukan_lain_daftar_page.dart';
import 'pemasukan/pemasukan_lain_tambah_page.dart';
import 'pemasukan/pemasukan_lain_edit.dart';
import 'pesan_warga/informasi_aspirasi_page.dart';
import 'penerimaan_warga/penerimaan_warga_page.dart';
import 'mutasi_keluarga/daftar_page.dart';
import 'log_aktivitas/semua_aktivitas_page.dart';
import 'manajemen_pengguna/daftar_pengguna_page.dart';
import 'manajemen_pengguna/tambah_pengguna_page.dart';
import 'channel_transfer/daftar_channel_page.dart';
import 'channel_transfer/tambah_channel_page.dart';
import 'services/auth_service.dart';
import 'data_warga_rumah/rumah_form_page.dart';
import 'data_warga_rumah/rumah_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthService.init(); // auto-detect server

  runApp(MyApp());
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
        GoRoute(path: '/beranda', builder: (context, state) => HomePage()),
        GoRoute(
          path: '/beranda/semua_menu',
          builder: (context, state) => const SemuaMenuPage(),
        ),
        GoRoute(
          path: '/dashboard/kegiatan',
          builder: (context, state) {
            final loggedInUserEmail = state.extra as String?;
            return KegiatanPage(email: loggedInUserEmail ?? 'Unknown User');
          },
        ),
        GoRoute(
          path: '/dashboard/kependudukan',
          builder: (context, state) => const KependudukanPage(),
        ),

        GoRoute(
          path: '/dashboard/keuangan',
          builder: (context, state) => const KeuanganPage(),
        ),

        GoRoute(
          path: '/pengeluaran/daftar',
          builder: (context, state) => const DaftarPengeluaranPage(),
        ),

        GoRoute(
          path: '/pengeluaran/tambah',
          builder: (context, state) => const TambahPengeluaran(),
        ),

        GoRoute(
          path: '/laporan_keuangan/semua_pengeluaran',
          builder: (context, state) => const SemuaPengeluaran(),
        ),
        GoRoute(
          path: '/laporan_keuangan/semua_pemasukan',
          builder: (context, state) => const SemuaPemasukan(),
        ),
        GoRoute(
          path: '/laporan_keuangan/cetak_laporan',
          builder: (context, state) => const CetakLaporan(),
        ),

        GoRoute(
          path: '/pemasukan/lain_tambah',
          builder: (context, state) => const PemasukanLainTambah(),
        ),

        GoRoute(
          path: '/pemasukan-lain/edit',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            return EditPemasukanLain(data: data);
          },
        ),

        GoRoute(
          path: '/pemasukan/lain_daftar',
          builder: (context, state) => const PemasukanLainDaftar(),
        ),
        GoRoute(
          path: '/data_warga_rumah/tambahWarga',
          builder: (context, state) => const TambahWargaPage(),
        ),
        GoRoute(
          path: '/data_warga_rumah/tambahRumah',
          builder: (context, state) => const TambahRumahPage(),
        ),
        GoRoute(
          path: '/data_warga_rumah/keluarga',
          builder: (context, state) => const DataKeluargaPage(),
        ),
        GoRoute(
          path: '/data_warga_rumah/daftarRumah',
          builder: (context, state) => const RumahListPage(),
        ),
        GoRoute(
          path: '/data_warga_rumah/daftarWarga',
          builder: (context, state) => const WargaListPage(),
        ),
        GoRoute(
          path: '/pemasukan/tagih_iuran',
          builder: (context, state) => const TagihIuranPage(),
        ),
        GoRoute(
          path: '/pemasukan/kategori_iuran',
          builder: (context, state) => const KategoriIuranPage(),
        ),
        GoRoute(
          path: '/pemasukan/tagihan',
          builder: (context, state) => const TagihanPage(),
        ),
        GoRoute(
          path: '/pengeluaran/daftar',
          builder: (context, state) => const DaftarPengeluaranPage(),
        ),

        GoRoute(
          path: '/pengeluaran/tambah',
          builder: (context, state) => const TambahPengeluaran(),
        ),
        GoRoute(
          path: '/kegiatan/daftar',
          builder: (context, state) => const KegiatanDaftarPage(),
        ),
        GoRoute(
          path: '/kegiatan/tambah/:id', // id bisa "new" atau angka
          builder: (context, state) {
            final idString = state.pathParameters['id'];
            final id = int.tryParse(idString ?? '');
            return KegiatanTambahPage(id: id);
          },
        ),
        GoRoute(
          path: '/kegiatan/daftar_broad',
          builder: (context, state) => BroadcastDaftarPage(),
        ),
        GoRoute(
          path: '/kegiatan/tambah_broad',
          builder: (context, state) => const BroadcastFormPage(),
        ),
        GoRoute(
          path: '/broadcast/form/:id',
          builder: (context, state) {
            final idString = state.pathParameters['id'];
            final id = int.tryParse(idString ?? '');
            return BroadcastFormPage(id: id);
          },
        ),

        GoRoute(
          path: '/pesan/informasi',
          builder: (context, state) => const InformasiAspirasiPage(),
        ),
        GoRoute(
          path: '/penerimaan/warga',
          builder: (context, state) => const PenerimaanWargaPage(),
        ),
        // GoRoute(
        //   path: '/mutasi_keluarga/daftar',
        //   builder: (context, state) => const DaftarPage(),
        // ),
        GoRoute(
          path: '/mutasi',
          builder: (context, state) => const DaftarPage(),
        ),
        GoRoute(
          path: '/channel/edit/:id',
          builder: (context, state) {
            final idStr = state.pathParameters['id']!;
            return EditMetodePembayaranPage(id: int.parse(idStr));
          },
        ),
        GoRoute(
          path: '/log_aktivitas/semua_aktivitas',
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
          path: '/channel_transfer/daftar',
          builder: (context, state) => const DaftarMetodePembayaranPage(),
        ),
        GoRoute(
          path: '/channel_transfer/tambah',
          builder: (context, state) => const TambahChannelPage(),
        ),
        GoRoute(
          path: '/rumah',
          name: 'rumah-list',
          builder: (context, state) => const RumahListPage(),
          routes: [
            GoRoute(
              path: 'add',
              name: 'rumah-add',
              builder: (context, state) => const RumahFormPage(),
            ),
            GoRoute(
              path: 'edit/:id',
              name: 'rumah-edit',
              builder: (context, state) {
                final data = state.extra as Map<String, dynamic>;
                return RumahFormPage(data: data);
              },
            ),
            GoRoute(
              path: 'detail/:id',
              name: 'rumah-detail',
              builder: (context, state) {
                final data = state.extra as Map<String, dynamic>;
                return RumahDetailPage(rumah: data);
              },
            ),
          ],
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
