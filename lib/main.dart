import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/pages/addKegiatan_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/kependudukan_page.dart';

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
        // end debug mode

        //present
        GoRoute(path: '/', builder: (context, state) => const LoginPage()),
        //end present
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
        GoRoute(path: '/', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/addKegiatan',
          builder: (context, state) => const AddKegiatanPage(),
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
