import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'widgets/form_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Make sure /home route is declared here
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
      ],
    );

    // ✅ Use MaterialApp.router instead of MaterialApp
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router, // <- This must be passed
      title: 'Jawara App',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
} 
 