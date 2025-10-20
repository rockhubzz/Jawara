import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/pages/addKegiatan_page.dart';
import 'package:jawara/pages/login_page.dart';
import 'package:jawara/pages/home_page.dart';
import 'package:jawara/pages/kependudukan_page.dart';
import 'package:jawara/Dashboard/Keuangan.dart';
import 'package:jawara/data_warga_rumah/tambahRumah_page.dart';

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
          path: '/tambahRumah',
          builder: (context, state) => const TambahRumahPage(),
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